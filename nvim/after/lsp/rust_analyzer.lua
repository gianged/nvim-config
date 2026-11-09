return {
    settings = {
        ["rust-analyzer"] = {
            check = { command = "clippy" },
            references = { excludeImports = true },
            imports = {
                granularity = { group = "crate", enforce = true },
                group = { enable = true },
                prefix = "crate",
            },
            inlayHints = {
                maxLength = vim.NIL,
                bindingModeHints = { enable = true },
                expressionAdjustmentHints = { enable = "reborrow" },
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
            },
        },
    },
}
