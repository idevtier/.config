vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    "folke/twilight.nvim",
    lazy = true,
    cmd = { "Twilight" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          'icon',
          'permission',
          'size',
          'mtime',
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["l"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["h"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
        },
      })
      vim.keymap.set('n', '<leader>oe', ':Oil<CR>', { silent = true })
    end
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
      {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
        config = function()
          require('neodev').setup()
          vim.g.code_action_menu_show_details = false
          vim.g.code_action_menu_show_diff = false
        end
      },
      {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          require('conform').setup({
            formatters_by_ft = {
              python = { "isort", "black" },

            },
            format_on_save = {
              lsp_fallback = true,
              async = false,
              timeout_ms = 1000,
            },
          })
        end
      },
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require('luasnip.loaders.from_snipmate').load()
        end
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
    config = function()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}

      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = "luasnip" }
        },
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end
        },
      }
    end
  },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({})
      vim.keymap.set('n', ']g', require('gitsigns').next_hunk, { desc = 'Next git hunk' })
      vim.keymap.set('n', '[g', require('gitsigns').prev_hunk, { desc = 'Previous git hunk' })
      vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { desc = '[H]unk [P]review' })
    end
  },
  {
    -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = { progress = { enabled = true, view = 'mini' } },
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        'rcarriga/nvim-notify',
        opts = {
          render = 'compact',
          icons = {
            DEBUG = " ",
            ERROR = " ",
            INFO = " ",
            TRACE = " ✎",
            WARN = " "
          },
          timeout = 1000,
          stages = 'slide',
        },
      },
    }
  },
  {
    'lambdalisue/suda.vim',
  },
  {
    "catppuccin/nvim",
    name = "catpuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",             -- latte, frappe, macchiato, mocha
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
        term_colors = true,             -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false,              -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15,            -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,              -- Force no italic
        no_bold = false,                -- Force no bold
        no_underline = false,           -- Force no underline
        styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" },      -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          notify = true,
          harpoon = true,
          telescope = true,
          fidget = true,
          noice = true,
        },
      })

      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end
  },
  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     vim.cmd.colorscheme 'github_dark_dimmed'
  --   end,
  -- },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      -- local auto_theme_custom = require('lualine.themes.auto')
      -- auto_theme_custom.normal.c.bg = 'none'
      -- auto_theme_custom.visual.c.bg = 'none'
      -- auto_theme_custom.command.c.bg = 'none'
      -- auto_theme_custom.insert.c.bg = 'none'

      require('lualine').setup({
        sections = {
          lualine_a = {
            { 'mode', fmt = function(str) return ' ' end }
          },
          lualine_b = {
            'branch',
            {
              'diff',
              colored = true,
              symbols = {
                added = ' ',
                modified = '󰏬 ',
                removed = ' ',
              },
            },
          },
          lualine_c = {
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              sections = {
                'info',
                'error',
                'warn',
                'hint',
              },
              diagnostic_color = {
                error = { fg = 'DiagnosticError' },
                warn = { fg = 'DiagnosticWarn' },
                info = { fg = 'DiaganosticInfo' },
                hint = { fg = 'DiagnosticHint' },
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
              symbols = {
                error = ' ',
                warn = ' ',
                hint = ' ',
                info = ' ',
              },
              separator = { left = '', right = '' },
            },
          },
          lualine_x = {
            function()
              return require('harpoon.mark').status()
            end,
          },
          lualine_y = {
            'encoding',
            'filesize',
          },
          lualine_z = {
            'location',
            'progress',
            {
              function()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.api.nvim_buf_get_option(buf, 'modified') then
                    return 'Unsaved buffers' -- any message or icon
                  end
                end
                return ''
              end,
            },
          },
        },
        options = {
          icons_enabled = true,
          component_separators = '',
          section_separators = '',
          globalstatus = true,
          theme = "catppuccin",
        },
      })
    end
  },

  {
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup({
        show_numbers = true,
        show_relative_numbers = true,
        autofold_depth = 1,
      })
      vim.keymap.set('n', '<leader>o', ':SymbolsOutline<CR>', { silent = true })
    end,
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy",
          },
          live_grep = {
            theme = "ivy",
          },
          help_tags = {
            theme = "ivy",
          },
          diagnostics = {
            theme = "ivy",
          },
          buffers = {
            previewer = false,
            theme = "dropdown",
          },
          current_buffer_fuzzy_find = {
            previewer = false,
            theme = "dropdown",
          },
          git_status = {
            theme = "ivy",
          },
          git_branches = {
            theme = "ivy",
          },
          lsp_references = {
            theme = "ivy",
            previewer = false,
          }
        },
      }

      vim.keymap.set('n', '<leader>ma', require('harpoon.mark').add_file, { noremap = true })
      vim.keymap.set('n', '<leader>ml', require('harpoon.ui').toggle_quick_menu, { noremap = true })
      vim.keymap.set('n', '<leader>h', require('harpoon.ui').nav_prev, { noremap = true })
      vim.keymap.set('n', '<leader>l', require('harpoon.ui').nav_next, { noremap = true })

      vim.keymap.set('n', '<leader>j', ':cn<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>k', ':cp<CR>', { noremap = true, silent = true })

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'harpoon')
      pcall(require('telescope').load_extension, 'git_worktree')

      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
      vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find,
        { desc = 'Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search git files' })
      vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = 'Search git status' })
      vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Find files' })
      vim.keymap.set('v', '<leader>f', '"zy:Telescope find_files default_text=<C-R>z<CR>',
        { desc = 'Find file with selected name', silent = true })
      vim.keymap.set('v', '<leader>;', '"zy:Telescope live_grep default_text=<C-R>z<CR>',
        { desc = 'Find selected name in files', silent = true })
      vim.keymap.set('n', '<leader>;', require('telescope.builtin').live_grep, { desc = 'Search by grep' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = 'Search diagnostics' })
      vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
      vim.keymap.set('n', "<leader>'", require('telescope.builtin').resume, { desc = 'Open last telescope picker' })
      vim.keymap.set('n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees,
        { desc = 'Git worktree switch' })
      vim.keymap.set('n', '<leader>gW', require('telescope').extensions.git_worktree.create_git_worktree,
        { desc = 'Git worktree create' })
    end
  },
  -- Mark buffers and jumps between them
  { 'ThePrimeagen/harpoon',  dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Automatically closes brackets
  { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end },
  { 'aserowy/tmux.nvim',     config = function() return require('tmux').setup() end },


  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/playground',
        lazy = true,
        cmd = { "TSPlaygroundToggle" }
      },
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end
  },
  { import = 'custom.plugins' },
  {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  },
  {
    'ThePrimeagen/git-worktree.nvim',
    config = function()
      require("git-worktree").setup({
        change_directory_command = "cd",  -- default: "cd",
        update_on_change = true,          -- default: true,
        update_on_change_command = "e .", -- default: "e .",
        clearjumps_on_change = true,      -- default: true,
        autopush = false,                 -- default: false,
      })
    end
  },
}, {})

-- Set highlight on search
vim.o.hlsearch = false

-- Save undo history
vim.o.undofile = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Case insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

vim.opt.winbar = '%=%m %f'
vim.opt.wrap = false -- No wrap lines
vim.wo.relativenumber = true

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.cmd [[ autocmd BufReadPost * normal zR ]]
-- vim.cmd [[ autocmd FileReadPre * normal zR ]]

vim.opt.scrolloff = 7
vim.opt.shell = 'fish'

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Buffers navigation
vim.keymap.set('n', '<leader>bk', ':bp|bd #<CR>', { silent = true })
vim.keymap.set('n', '<leader>bak', ':%bd<CR>', { silent = true })
vim.keymap.set("n", "gn", ":bn<CR>", { silent = true })
vim.keymap.set("n", "gp", ":bp<CR>", { silent = true })

-- Paste without yank
vim.keymap.set('x', '<leader>R', '"_dP', { silent = true })

-- Move selectd lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

-- Keep cursor in a middle while scrolling
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })

-- Keep cursor in a middle while seaching
vim.keymap.set('n', 'n', 'nzzzv', { silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true })

-- Replace word under cursor
vim.keymap.set("n", "<leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace words under cursor" })

-- Better horisontal navigation
vim.keymap.set('n', 'gh', '0', { silent = true })
vim.keymap.set('n', 'gl', '$', { silent = true })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { silent = true })

-- Diagnostic keymaps
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', ':CodeActionMenu<CR>', '[C]ode [A]ction')

  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Change diagnostic icons
  vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })
  vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint', linehl = '', numhl = '' })
end
local servers = {
  clangd = {},
  pyright = {},
  bashls = {},
  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
    },
  },
  rust_analyzer = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
      },
      check = {
        command = 'clippy',
      }
    }
  }
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- region:    Toggle wrap
vim.opt.wrap = false
vim.opt.linebreak = false

function Toggle_wrap()
  vim.cmd [[ set wrap! ]]
  vim.cmd [[ set linebreak! ]]
end

vim.keymap.set('n', '<leader>w', Toggle_wrap, { desc = 'Toggle [W]rap', silent = true })
-- endregion: Toggle wrap

vim.opt.splitright = true;
vim.opt.guicursor = ""
