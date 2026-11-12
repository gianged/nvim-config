local DETECTORS = { "entrypoints.rust" }

local M = {}

function M.discover(dir, cb)
    local groups, errors = {}, {}
    local pending = #DETECTORS
    for _, detector in ipairs(DETECTORS) do
        require(detector).discover(dir, function(err, group)
            if err then
                table.insert(errors, err)
            elseif group then
                table.insert(groups, group)
            end
            pending = pending - 1
            if pending == 0 then
                cb(groups, errors)
            end
        end)
    end
end

return M
