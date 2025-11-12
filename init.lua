--[[

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false
-- Add fold
vim.o.foldmethod = 'expr'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldcolumn = '0' -- Show fold column '1'
vim.opt.fillchars:append { fold = ' ' } -- Optional: cleaner look
vim.opt.guicursor = {
  -- This is a common setting that enables blinking across all modes
  -- and sets the blinking rate.
  'n-v-c:block-Cursor/lCursor',
  'i-ci-ve:ver25-Cursor/lCursor',
  'r-cr:hor20-Cursor/lCursor',
  'o:hor50-Cursor/lCursor',
  'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor', -- The blinking part
  'sm:block-blinkwait175-blinkoff150-blinkon175-Cursor/lCursor',
}

-- LSP and DAP logging (only enable when debugging)
-- vim.lsp.set_log_level 'WARN'
-- vim.g.dap_log_level = 'DEBUG'
-- vim.g.dap_log_file = '/tmp/nvim-dap.log'

-- Auto-save and restore folds using views (optimized)
local view_group = vim.api.nvim_create_augroup('ViewManagement', { clear = true })

vim.api.nvim_create_autocmd('BufWinLeave', {
  group = view_group,
  pattern = '*',
  callback = function()
    if vim.bo.buftype == '' and vim.fn.expand '%' ~= '' then
      vim.cmd 'silent! mkview'
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = view_group,
  pattern = '*',
  callback = function()
    if vim.bo.buftype == '' and vim.fn.expand '%' ~= '' then
      vim.cmd 'silent! loadview'
    end
  end,
})

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.o.clipboard = 'unnamedplus'
-- end)
vim.opt.clipboard = 'unnamedplus'

-- Remap common delete actions to use the black hole register "_
vim.keymap.set('n', 'd', '"_d', { desc = 'Delete without yanking (Blackhole)' })
vim.keymap.set('n', 'D', '"_D', { desc = 'Delete line end without yanking' })
vim.keymap.set('n', 'x', '"_x', { desc = 'Delete character without yanking' })
vim.keymap.set('n', 's', '"_s', { desc = 'Substitute character without yanking' })

-- In Visual mode, replace the text with content from the black hole register
-- This prevents a visual delete from copying to the register.
vim.keymap.set('x', 'd', '"_d', { desc = 'Delete visual selection without yanking' })
vim.keymap.set('x', 'x', '"_x', { desc = 'Delete visual selection without yanking' })
vim.keymap.set('x', 's', '"_s', { desc = 'Substitute selection without yanking' })

-- Enable break indent
vim.o.breakindent = true
vim.o.expandtab = true -- convert tabs to spaces
vim.o.shiftwidth = 2 -- indentation level = 2 spaces
vim.o.tabstop = 2 -- a tab = 2 spaces
vim.o.softtabstop = 2 -- tab key behaves like 2 spaces

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Quit on leader q
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', function()
-- Save of C-s
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', function()
  vim.cmd 'w'
end, { noremap = true, silent = true, desc = 'Save File' })

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Stay in visual mode when indenting
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open Session Window' })
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Visual mode navigation
vim.keymap.set('v', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window in visual mode' })
vim.keymap.set('v', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window in visual mode' })
vim.keymap.set('v', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window in visual mode' })
vim.keymap.set('v', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window in visual mode' })

-- JavaScript console.log macro (lazy-loaded)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript' },
  once = false,
  callback = function()
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
    vim.fn.setreg('c', 'yoconsole.log("' .. esc .. 'pa:", ' .. esc .. 'pa);' .. esc)
  end,
})

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
    },
    keys = {
      {
        '<leader>ghp',
        function()
          require('gitsigns').preview_hunk()
        end,
        mode = 'n',
        desc = '[G]it [Hunk] [P]review',
      },
      {
        '<leader>ghr',
        function()
          require('gitsigns').reset_hunk()
        end,
        mode = 'n',
        desc = '[G]it [Hunk] [R]eset',
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`

      { 'mason-org/mason.nvim', version = '^1.0.0', opts = {} },
      { 'mason-org/mason-lspconfig.nvim', version = '^1.0.0' },
      -- { 'mason-org/mason.nvim', opts = {} },
      -- 'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `ma:lua vim.lsp.buf.code_action()son` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Python-specific keymaps
          if vim.bo.filetype == 'python' then
            map('<leader>po', function()
              vim.cmd '!poetry install'
            end, '[P]oetry Install')

            map('<leader>pr', function()
              vim.cmd '!poetry run python %'
            end, '[P]oetry [R]un current file')

            map('<leader>ps', function()
              vim.cmd '!poetry shell'
            end, '[P]oetry [S]hell')

            map('<leader>plr', function()
              vim.cmd 'LspRestart pyright'
              vim.notify('Pyright LSP restarted', vim.log.levels.INFO)
            end, '[P]yright [L]SP [R]estart')

            map('<leader>pli', function()
              local clients = vim.lsp.get_clients { name = 'pyright' }
              if #clients > 0 then
                local config = clients[1].config
                local settings = config.settings.python
                local analysis = settings.analysis or {}

                local info = {
                  'Pyright Configuration:',
                  '  Root: ' .. (config.root_dir or 'Not set'),
                  '  Python: ' .. (settings.pythonPath or 'Not set'),
                  '  Venv: ' .. (settings.venvPath or 'Not set'),
                  '  Extra Paths: ' .. (analysis.extraPaths and table.concat(analysis.extraPaths, ', ') or 'Not set'),
                  '  Include: ' .. (analysis.include and table.concat(analysis.include, ', ') or 'Not set'),
                }

                vim.notify(table.concat(info, '\n'), vim.log.levels.INFO, { title = 'Pyright Config' })
              else
                vim.notify('Pyright LSP not active', vim.log.levels.WARN)
              end
            end, '[P]yright [L]SP [I]nfo')

            map('<leader>plc', function()
              -- Check pyproject.toml configuration
              local root_dir = vim.fs.root(0, '.git') or vim.fn.getcwd()
              local pyproject_path = vim.fs.joinpath(root_dir, 'pyproject.toml')

              if vim.fn.filereadable(pyproject_path) == 1 then
                vim.cmd('edit ' .. pyproject_path)
              else
                vim.notify('No pyproject.toml found in project root: ' .. root_dir, vim.log.levels.WARN)
              end
            end, '[P]yright [L]SP [C]onfig (open pyproject.toml)')

            map('<leader>pld', function()
              vim.diagnostic.setloclist()
            end, '[P]yright [L]SP [D]iagnostics')
          end

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many', max_width = 100, focusable = true },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        pyright = {
          cmd = { vim.fn.stdpath 'data' .. '/mason/bin/pyright-langserver', '--stdio' },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = 'openFilesOnly', -- Changed from 'workspace' for better performance
                typeCheckingMode = 'basic',
                disableOrganizeImports = false, -- Enable organize imports code actions
                -- Enable more diagnostics for better code actions
                reportMissingImports = 'error',
                reportMissingTypeStubs = false,
                reportUnusedImport = 'warning',
                reportUnusedVariable = 'warning',
                reportDuplicateImport = 'warning',
                -- Enable undefined variable reporting for auto-import suggestions
                reportUndefinedVariable = 'error',
              },
            },
          },

          -- Enhanced Poetry and pyproject.toml integration
          before_init = function(_, config)
            -- Use native vim.fs for path operations
            local path = {
              join = function(...)
                return vim.fs.joinpath(...)
              end,
              dirname = function(p)
                return vim.fs.dirname(p)
              end,
            }

            -- Function to parse pyproject.toml more robustly
            local function parse_pyproject_toml(file_path)
              local file = io.open(file_path, 'r')
              if not file then
                return nil
              end

              local content = file:read '*all'
              file:close()

              local result = {
                is_poetry_project = false,
                pyright_config = {},
                project_name = nil,
                src_layout = false,
              }

              -- Check if it's a Poetry project
              result.is_poetry_project = content:match '%[tool%.poetry%]' ~= nil or content:match '%[build%-system%].-poetry' ~= nil

              -- Extract project name for src layout detection
              local name_match = content:match '%[tool%.poetry%].-name%s*=%s*["\']([^"\']+)["\']'
              if name_match then
                result.project_name = name_match
              end

              -- Parse [tool.pyright] section more carefully
              local pyright_section = content:match '%[tool%.pyright%](.-)%[tool%.'
              if not pyright_section then
                pyright_section = content:match '%[tool%.pyright%](.*)$'
              end

              if pyright_section then
                -- Parse include paths (handle both single-line and multi-line arrays)
                local include_pattern = 'include%s*=%s*%[([^%]]+)%]'
                local include_match = pyright_section:match(include_pattern)
                if include_match then
                  result.pyright_config.include = {}
                  -- Handle both quoted and unquoted strings
                  for path_item in include_match:gmatch '["\']([^"\']+)["\']' do
                    table.insert(result.pyright_config.include, path_item)
                  end
                end

                -- Parse exclude paths
                local exclude_pattern = 'exclude%s*=%s*%[([^%]]+)%]'
                local exclude_match = pyright_section:match(exclude_pattern)
                if exclude_match then
                  result.pyright_config.exclude = {}
                  for path_item in exclude_match:gmatch '["\']([^"\']+)["\']' do
                    table.insert(result.pyright_config.exclude, path_item)
                  end
                end

                -- Parse other settings
                local version_match = pyright_section:match 'pythonVersion%s*=%s*["\']([^"\']+)["\']'
                if version_match then
                  result.pyright_config.pythonVersion = version_match
                end

                local missing_imports = pyright_section:match 'reportMissingImports%s*=%s*["\']?([^"\'%s]+)["\']?'
                if missing_imports then
                  result.pyright_config.reportMissingImports = missing_imports
                end
              end

              return result
            end

            -- Function to detect common Python project layouts (enhanced for monorepo)
            local function detect_project_structure(root_dir, project_name)
              local src_paths = {}
              local common_patterns = {
                'src',
                project_name and ('src/' .. project_name) or nil,
                project_name,
                'lib', -- Common in monorepos
                'app',
                'services', -- Common in monorepos
                'shared', -- Common in monorepos
                'packages', -- Common in monorepos
              }

              -- Add paths from common patterns
              for _, pattern in ipairs(common_patterns) do
                if pattern then
                  local full_path = path.join(root_dir, pattern)
                  if vim.fn.isdirectory(full_path) == 1 then
                    table.insert(src_paths, full_path)
                    -- Also check for __init__.py to confirm it's a Python package
                    local init_file = path.join(full_path, '__init__.py')
                    if vim.fn.filereadable(init_file) == 1 then
                      -- This is likely a package directory, include parent too
                      table.insert(src_paths, path.dirname(full_path))
                    end
                  end
                end
              end

              -- For monorepos, also scan for any directory with __init__.py at the root level
              local handle = vim.loop.fs_scandir(root_dir)
              if handle then
                while true do
                  local name, type = vim.loop.fs_scandir_next(handle)
                  if not name then
                    break
                  end

                  if type == 'directory' and not name:match '^%.' then
                    local dir_path = path.join(root_dir, name)
                    local init_file = path.join(dir_path, '__init__.py')
                    if vim.fn.filereadable(init_file) == 1 then
                      table.insert(src_paths, dir_path)
                    end
                  end
                end
              end

              -- Always include the root directory
              table.insert(src_paths, root_dir)

              -- Remove duplicates and sort by length (shorter paths first)
              local unique_paths = {}
              local seen = {}
              for _, p in ipairs(src_paths) do
                if not seen[p] then
                  seen[p] = true
                  table.insert(unique_paths, p)
                end
              end

              -- Sort by path length (shorter first) for better resolution order
              table.sort(unique_paths, function(a, b)
                return #a < #b
              end)

              return unique_paths
            end

            -- Function to setup Poetry virtual environment
            local function setup_poetry_venv(root_dir)
              -- Try multiple methods to get Poetry venv info
              local commands = {
                'poetry env info --path',
                'poetry env info -p',
              }

              for _, cmd in ipairs(commands) do
                local handle = io.popen('cd "' .. root_dir .. '" && ' .. cmd .. ' 2>/dev/null')
                if handle then
                  local venv_path = handle:read '*a'
                  handle:close()

                  if venv_path and venv_path ~= '' then
                    venv_path = vim.trim(venv_path)
                    if vim.fn.isdirectory(venv_path) == 1 then
                      -- Find Python executable
                      local python_paths = {
                        path.join(venv_path, 'bin', 'python'),
                        path.join(venv_path, 'bin', 'python3'),
                        path.join(venv_path, 'Scripts', 'python.exe'), -- Windows
                        path.join(venv_path, 'Scripts', 'python3.exe'), -- Windows
                      }

                      for _, python_path in ipairs(python_paths) do
                        if vim.fn.executable(python_path) == 1 then
                          return python_path, venv_path
                        end
                      end
                    end
                  end
                end
              end

              return nil, nil
            end

            -- Function to find the correct pyproject.toml (handles monorepo structure)
            local function find_pyproject_toml(start_dir)
              local current_dir = start_dir
              local pyproject_files = {}

              -- Walk up the directory tree to find all pyproject.toml files
              while current_dir and current_dir ~= '/' do
                local pyproject_path = path.join(current_dir, 'pyproject.toml')
                if vim.fn.filereadable(pyproject_path) == 1 then
                  table.insert(pyproject_files, {
                    path = pyproject_path,
                    dir = current_dir,
                    is_root = vim.fn.isdirectory(path.join(current_dir, '.git')) == 1,
                  })
                end
                current_dir = path.dirname(current_dir)
              end

              -- Prefer the root project (with .git) that has Pyright config
              for _, file_info in ipairs(pyproject_files) do
                local project_info = parse_pyproject_toml(file_info.path)
                if project_info and (project_info.pyright_config.include or file_info.is_root) then
                  return file_info.path, file_info.dir, project_info
                end
              end

              -- Fallback to the first Poetry project found
              for _, file_info in ipairs(pyproject_files) do
                local project_info = parse_pyproject_toml(file_info.path)
                if project_info and project_info.is_poetry_project then
                  return file_info.path, file_info.dir, project_info
                end
              end

              return nil, nil, nil
            end

            -- Main setup function
            local function setup_poetry_project()
              local start_dir = config.root_dir or vim.fs.root(vim.fn.getcwd(), '.git') or vim.fn.getcwd()
              local pyproject_path, root_dir, project_info = find_pyproject_toml(start_dir)

              if not pyproject_path or not project_info then
                return
              end

              -- Setup Python interpreter from Poetry
              local python_path, venv_path = setup_poetry_venv(root_dir)
              if python_path then
                config.settings.python.pythonPath = python_path
                config.settings.python.defaultInterpreterPath = python_path
                if venv_path then
                  config.settings.python.venvPath = venv_path
                end
              end

              -- Apply pyproject.toml Pyright configuration
              if project_info.pyright_config.include then
                config.settings.python.analysis.include = project_info.pyright_config.include
              end

              if project_info.pyright_config.exclude then
                config.settings.python.analysis.exclude = project_info.pyright_config.exclude
              end

              if project_info.pyright_config.pythonVersion then
                config.settings.python.pythonVersion = project_info.pyright_config.pythonVersion
              end

              if project_info.pyright_config.reportMissingImports then
                config.settings.python.analysis.reportMissingImports = project_info.pyright_config.reportMissingImports
              end

              -- Setup extra paths for local package resolution
              local extra_paths = detect_project_structure(root_dir, project_info.project_name)

              -- Add any explicitly configured include paths
              if project_info.pyright_config.include then
                for _, include_path in ipairs(project_info.pyright_config.include) do
                  local full_path = path.join(root_dir, include_path)
                  if vim.fn.isdirectory(full_path) == 1 then
                    table.insert(extra_paths, full_path)
                  end
                end
              end

              if #extra_paths > 0 then
                config.settings.python.analysis.extraPaths = extra_paths
              end

              -- Only show notification if there are issues
              if not python_path then
                vim.schedule(function()
                  vim.notify('Poetry venv not found for: ' .. root_dir, vim.log.levels.WARN, { title = 'Pyright Setup' })
                end)
              end
            end

            -- Run the setup
            setup_poetry_project()
          end,
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'pyright', -- Python language server
        'ruff', -- Python linter and formatter
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            -- TODO: Migrate to vim.lsp.config API when stable
            -- Currently using require('lspconfig') for compatibility
            -- The deprecation warning is expected in Neovim 0.11+
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'ruff_format' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'enter',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  --
  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     ---@diagnostic disable-next-line: missing-fields
  --     require('tokyonight').setup {
  --       styles = {
  --         comments = { italic = false }, -- Disable italics in comments
  --       },
  --     }
  --
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --   end,
  -- },

  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
    },
    config = function(_, opts)
      require('nightfox').setup(opts)
      vim.cmd.colorscheme 'carbonfox'
    end,
  },

  -- Highlight todo, notes, etc in comments (lazy-loaded)
  { 'folke/todo-comments.nvim', event = { 'BufReadPost', 'BufNewFile' }, dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      -- statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'javascript',
        'typescript',
        'tsx',
        'vue',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'toml',
        'yaml',
        'json',
        'query',
        'vim',
        'vimdoc',
      },
      autotag = {
        enable = true,
        filetypes = {
          'html',
          'xml',
          'javascript',
          'typescript',
          'javascriptreact',
          'typescriptreact',
          'vue',
          'svelte',
        },
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Disable for very large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = {
        enable = true,
        disable = { 'ruby', 'python' }, -- Python indentation can be slow
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  require 'kickstart.plugins.lazygit',
  { import = 'kickstart.plugins.undotree' },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Optional: Explicitly force some core groups to none AFTER the colorscheme
-- This is a fallback if the colorscheme or transparent.nvim isn't catching everything.
vim.cmd [[
  highlight Normal guibg=none ctermbg=none
  highlight NonText guibg=none ctermbg=none
  highlight EndOfBuffer guibg=none ctermbg=none

  highlight NormalNC guibg=none ctermbg=none
  highlight FoldColumn guibg=none ctermbg=none
  highlight SignColumn guibg=none ctermbg=none
  highlight LineNr guibg=none ctermbg=none
  highlight LineNrNC guibg=none ctermbg=none
  highlight ColorColumn guibg=none ctermbg=none

]]

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
