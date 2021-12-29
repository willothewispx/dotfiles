require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {}, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    personal = "~/Nextcloud/Neorg",
                },
                -- Automatically detect whenever we have entered a subdirectory of a workspace
                autodetect = true,
                -- Automatically change the directory to the root of the workspace every time
                autochdir = true,
            },
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
            },
        },
        ["core.integrations.telescope"] = {}, -- Enable the telescope module
    },
})

-- Get the current Neorg state
local neorg = require("neorg")

--- Loads the Neorg completion module
local function load_completion()
    neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp", -- Choose your completion engine here
    })
end

-- If Neorg is loaded already then don't hesitate and load the completion
if neorg.is_loaded() then
    load_completion()
else -- Otherwise wait until Neorg gets started and load the completion module then
    neorg.callbacks.on_event("core.started", load_completion)
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
    },
}

parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main",
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main",
    },
}
