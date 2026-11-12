local M = {}

local function is_bin(target)
    return vim.list_contains(target.kind, "bin")
end

local function bin_name_counts(packages)
    local counts = {}
    for _, pkg in ipairs(packages) do
        for _, target in ipairs(pkg.targets) do
            if is_bin(target) then
                counts[target.name] = (counts[target.name] or 0) + 1
            end
        end
    end
    return counts
end

local function entry(meta, pkg, target, counts)
    local selector = { "-p", pkg.name, "--bin", target.name }
    local features = target["required-features"] or {}
    if #features > 0 then
        vim.list_extend(selector, { "--features", table.concat(features, ",") })
    end
    return {
        name = counts[target.name] > 1 and (pkg.name .. "/" .. target.name) or target.name,
        cwd = meta.workspace_root,
        run_cmd = vim.list_extend({ "cargo", "run" }, selector),
        build_cmd = vim.list_extend({ "cargo", "build" }, selector),
        program = vim.fs.joinpath(meta.target_directory, "debug", target.name),
    }
end

local function to_group(meta)
    local counts = bin_name_counts(meta.packages)
    local entries = {}
    local build_all = { "cargo", "build" }
    local features = {}
    for _, pkg in ipairs(meta.packages) do
        local has_bin = false
        for _, target in ipairs(pkg.targets) do
            if is_bin(target) then
                has_bin = true
                table.insert(entries, entry(meta, pkg, target, counts))
                for _, feature in ipairs(target["required-features"] or {}) do
                    table.insert(features, pkg.name .. "/" .. feature)
                end
            end
        end
        if has_bin then
            vim.list_extend(build_all, { "-p", pkg.name })
        end
    end
    if #entries == 0 then
        return nil
    end
    table.insert(build_all, "--bins")
    if #features > 0 then
        vim.list_extend(build_all, { "--features", table.concat(features, ",") })
    end
    return { lang = "rust", root = meta.workspace_root, build_all_cmd = build_all, entries = entries }
end

function M.discover(dir, cb)
    local manifest = vim.fs.find("Cargo.toml", { upward = true, type = "file", path = dir })[1]
    if not manifest then
        return cb(nil, nil)
    end
    if vim.fn.executable("cargo") == 0 then
        return cb("cargo not found on PATH", nil)
    end
    vim.system(
        { "cargo", "metadata", "--no-deps", "--format-version", "1" },
        { cwd = vim.fs.dirname(manifest), text = true },
        vim.schedule_wrap(function(out)
            if out.code ~= 0 then
                return cb("cargo metadata: " .. vim.trim(out.stderr), nil)
            end
            local ok, meta = pcall(vim.json.decode, out.stdout)
            if not ok then
                return cb("cargo metadata: " .. meta, nil)
            end
            cb(nil, to_group(meta))
        end)
    )
end

return M
