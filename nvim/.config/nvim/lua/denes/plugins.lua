return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Autoload lua/plugin/*.lua
    use("tjdevries/astronauta.nvim")

    -- THEME gruvbox-material
    use("sainnhe/gruvbox-material")

    -- THEME Tokyo Night
    use("folke/tokyonight.nvim")

    -- THEME material
    use("marko-cerovac/material.nvim")

    -- THEME Moonlight
    use("shaunsingh/moonlight.nvim")

    -- THEME github
    use("projekt0n/github-nvim-theme")

    -- OneDarkPro
    use("olimorris/onedarkpro.nvim")

    -- Catppuccin
    use("catppuccin/nvim")

    -- Tree-sitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "JoosepAlviste/nvim-ts-context-commentstring", -- better comments
            "windwp/nvim-ts-autotag", -- html autoclose tags
        },
    })

    -- Dockerfiles
    use("ekalinin/dockerfile.vim")

    -- Statusline
    -- INFO: Fork of the original lualine.nvim
    use("nvim-lualine/lualine.nvim")

    -- Bufferline
    use("akinsho/nvim-bufferline.lua")

    -- Devicons
    use("kyazdani42/nvim-web-devicons")

    -- ToDo Comments
    use("folke/todo-comments.nvim")

    -- Diagnostics
    use("folke/trouble.nvim")

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzy-native.nvim" },
        },
    })

    -- Harpoon
    use("ThePrimeagen/harpoon")

    -- LSP
    use("neovim/nvim-lspconfig")

    -- LSP Autocomletion
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
        },
    })
    use({ "tzachar/cmp-tabnine", run = "./install.sh" })

    -- Null-Ls -> formatter, linter,...
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    })

    use("saadparwaiz1/cmp_luasnip")

    -- LSP install language server
    use("williamboman/nvim-lsp-installer")

    -- VSCode-like pictograms
    use("onsails/lspkind-nvim")

    -- Lsp UI
    use("tami5/lspsaga.nvim")

    -- Filetree
    use("kyazdani42/nvim-tree.lua")

    -- Projekt specific working directory
    use("ahmedkhalf/project.nvim")

    -- GIT signs
    use("lewis6991/gitsigns.nvim")

    -- Comments
    use("numToStr/Comment.nvim")

    -- Surround
    use("tpope/vim-surround")

    -- Indentlines
    use({ "lukas-reineke/indent-blankline.nvim" })

    -- Colored parentheses
    use("p00f/nvim-ts-rainbow")

    -- Auto pairs
    use("windwp/nvim-autopairs")

    -- Undotree
    use("mbbill/undotree")

    -- Git
    use("TimUntersberger/neogit")

    -- Git diffs
    use("sindrets/diffview.nvim")

    -- Peek registers
    use("gennaro-tedesco/nvim-peekup")

    -- Quickly move in document
    use({
        "phaazon/hop.nvim",
        branch = "v1", -- optional but strongly recommended
    })
    -- Snippets
    use("rafamadriz/friendly-snippets")
    use("L3MON4D3/LuaSnip")

    -- Startpage
    use("mhinz/vim-startify")

    -- Which Key
    use("folke/which-key.nvim")

    -- LaTeX
    use({ "lervag/vimtex", ft = "tex" })

    -- Neorg
    use("nvim-neorg/neorg")
    use("nvim-neorg/neorg-telescope")

    -- Orgmode.nvim
    use({
        "kristijanhusak/orgmode.nvim",
        config = function()
            require("orgmode").setup({})
        end,
    })

    use({
        "akinsho/org-bullets.nvim",
        config = function()
            require("org-bullets").setup({
                symbols = { "◉", "○", "✸", "✿" },
            })
        end,
    })

    -- Smoonth Scrolling
    use("karb94/neoscroll.nvim")

    -- Color Highlighter
    use("norcalli/nvim-colorizer.lua")
end)
