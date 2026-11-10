local ABBREV = "claude"

local function expand_abbrev()
    if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == ABBREV then
        return "ClaudeCode"
    end
    return ABBREV
end

return {
    "coder/claudecode.nvim",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    opts = {
        terminal = {
            snacks_win_opts = {
                keys = { term_normal = false },
            },
        },
    },
    config = function(_, opts)
        require("claudecode").setup(opts)
        vim.keymap.set("ca", ABBREV, expand_abbrev, { expr = true, desc = "Expand :claude to :ClaudeCode" })
    end,
    keys = {
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>as", "<cmd>.ClaudeCodeSend<cr>", desc = "Send to Claude" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
    },
}
