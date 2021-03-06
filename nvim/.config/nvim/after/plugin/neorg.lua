require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.norg.concealer"] = {}, -- Allows for use of icons
        ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
                workspaces = {
                    personal = "~/Nextcloud/Neorg/personal",
                    huong = "~/Nextcloud/Neorg/huong",
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

-- This sets the leader for all Neorg keybinds. It is separate from the regular <Leader>,
-- And allows you to shove every Neorg keybind under one "umbrella".
local neorg_leader = "<Leader>" -- You may also want to set this to <Leader>o for "organization"

-- Require the user callbacks module, which allows us to tap into the core of Neorg
local neorg_callbacks = require("neorg.callbacks")

-- Listen for the enable_keybinds event, which signals a "ready" state meaning we can bind keys.
-- This hook will be called several times, e.g. whenever the Neorg Mode changes or an event that
-- needs to reevaluate all the bound keys is invoked
neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode

            -- Keys for managing TODO items and setting their states
            { "gtd", "core.norg.qol.todo_items.todo.task_done" },
            { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
            { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
            { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },
        },
    }, { silent = true, noremap = true })
end)

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
