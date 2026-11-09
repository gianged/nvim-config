return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            flavour = "mocha",
            custom_highlights = function(c)
                return {
                    -- Types: colour by kind
                    ["@lsp.type.struct"] = { fg = c.yellow },
                    ["@lsp.type.class"] = { fg = c.yellow },
                    ["@lsp.type.typeAlias"] = { fg = c.yellow, italic = true },
                    ["@lsp.type.enum"] = { fg = c.teal },
                    ["@lsp.type.enumMember"] = { fg = c.teal },
                    ["@lsp.type.interface"] = { fg = c.sky, italic = true },
                    ["@lsp.type.typeParameter"] = { fg = c.flamingo, italic = true },
                    ["@lsp.type.builtinType"] = { fg = c.sapphire },
                    ["@lsp.type.namespace"] = { fg = c.overlay2 },

                    -- Values
                    ["@lsp.type.function"] = { fg = c.blue },
                    ["@lsp.type.method"] = { fg = c.blue },
                    ["@lsp.type.macro"] = { fg = c.pink },
                    ["@lsp.type.parameter"] = { fg = c.maroon },
                    ["@lsp.type.property"] = { fg = c.lavender },
                    ["@lsp.type.const"] = { fg = c.peach },
                    ["@lsp.type.static"] = { fg = c.peach },
                    ["@lsp.type.lifetime"] = { fg = c.rosewater, italic = true },
                    ["@lsp.type.selfKeyword"] = { fg = c.red, italic = true },

                    -- Modifiers: layered on top of the kind colour
                    ["@lsp.mod.mutable"] = { underline = true },
                    ["@lsp.mod.usedAsMutableReference"] = { underline = true },
                    ["@lsp.mod.usedAsMutablePointer"] = { underline = true },
                    ["@lsp.mod.unsafe"] = { fg = c.red, bold = true },
                    ["@lsp.mod.deprecated"] = { strikethrough = true },
                }
            end,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        opts = {},
    },
}
