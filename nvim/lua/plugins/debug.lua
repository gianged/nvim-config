local MASON_ADAPTERS = { "codelldb" }

local SIGNS = {
    DapBreakpoint = { text = "●", texthl = "DiagnosticError" },
    DapBreakpointCondition = { text = "◆", texthl = "DiagnosticWarn" },
    DapLogPoint = { text = "◉", texthl = "DiagnosticInfo" },
    DapBreakpointRejected = { text = "○", texthl = "DiagnosticHint" },
    DapStopped = { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine" },
}

local function define_adapters(dap)
    local codelldb = {
        type = "server",
        port = "${port}",
        executable = { command = "codelldb", args = { "--port", "${port}" } },
    }
    dap.adapters.lldb = codelldb
    dap.adapters.codelldb = codelldb
end

local function dap_call(method, ...)
    local args = { ... }
    return function()
        require("dap")[method](unpack(args))
    end
end

local function targets(method)
    return function()
        require("debug_targets")[method]()
    end
end

local function prompt_breakpoint(prompt, apply)
    return function()
        vim.ui.input({ prompt = prompt }, function(value)
            if value and value ~= "" then
                apply(require("dap"), value)
            end
        end)
    end
end

local conditional_breakpoint = prompt_breakpoint("Condition: ", function(dap, condition)
    dap.set_breakpoint(condition)
end)

local log_point = prompt_breakpoint("Log message: ", function(dap, message)
    dap.set_breakpoint(nil, nil, message)
end)

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "igorlfs/nvim-dap-view",
            "jay-babu/mason-nvim-dap.nvim",
            "stevearc/overseer.nvim",
        },
        cmd = { "DapNew", "DapContinue", "DapToggleBreakpoint" },
        config = function()
            local dap = require("dap")
            require("mason-nvim-dap").setup({ ensure_installed = MASON_ADAPTERS })
            define_adapters(dap)
            require("overseer").enable_dap()
            require("debug_targets").register()
            dap.providers.configs["dap.launch.json"] = nil
            for name, sign in pairs(SIGNS) do
                vim.fn.sign_define(name, sign)
            end
        end,
        keys = {
            { "<leader>dd", targets("pick"), desc = "Debug: pick target" },
            { "<leader>dc", targets("continue"), desc = "Debug: continue" },
            { "<F5>", targets("continue"), desc = "Debug: continue" },
            { "<leader>db", dap_call("toggle_breakpoint"), desc = "Debug: toggle breakpoint" },
            { "<F9>", dap_call("toggle_breakpoint"), desc = "Debug: toggle breakpoint" },
            { "<leader>dB", conditional_breakpoint, desc = "Debug: conditional breakpoint" },
            { "<leader>dL", log_point, desc = "Debug: log point" },
            { "<leader>dn", dap_call("step_over"), desc = "Debug: step over" },
            { "<F10>", dap_call("step_over"), desc = "Debug: step over" },
            { "<leader>di", dap_call("step_into"), desc = "Debug: step into" },
            { "<F11>", dap_call("step_into"), desc = "Debug: step into" },
            { "<leader>do", dap_call("step_out"), desc = "Debug: step out" },
            { "<S-F11>", dap_call("step_out"), desc = "Debug: step out" },
            { "<F23>", dap_call("step_out"), desc = "Debug: step out" },
            { "<leader>dC", dap_call("run_to_cursor"), desc = "Debug: run to cursor" },
            { "<leader>dl", dap_call("run_last"), desc = "Debug: run last" },
            { "<leader>dr", targets("restart"), desc = "Debug: restart session" },
            { "<leader>dq", dap_call("terminate"), desc = "Debug: terminate session" },
            { "<leader>dQ", dap_call("terminate", { all = true }), desc = "Debug: terminate all sessions" },
            { "<leader>dv", "<cmd>DapViewToggle<cr>", desc = "Debug: toggle view" },
            { "<leader>dw", "<cmd>DapViewWatch<cr>", mode = { "n", "x" }, desc = "Debug: watch expression" },
            { "<leader>dk", "<cmd>DapViewHover<cr>", mode = { "n", "x" }, desc = "Debug: hover value" },
        },
    },
    {
        "igorlfs/nvim-dap-view",
        version = "1.*",
        opts = {
            auto_toggle = true,
            winbar = {
                sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "sessions" },
            },
            virtual_text = { enabled = true },
        },
    },
}
