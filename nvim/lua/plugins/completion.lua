return {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
    opts = {
        keymap = { preset = "default" },
        completion = {
            documentation = { auto_show = true },
        },
        fuzzy = {
            prebuilt_binaries = { extra_curl_args = { "--retry", "5" } },
        },
    },
}
