return {
  {
    'nvim-lua/lsp-status.nvim',
    -- It's common to lazy-load LSP-related plugins.
    -- You could trigger it on LSP attach or when an LSP command is used.
    -- For basic functionality in statusline, 'LspAttach' is a good event.
    event = 'LspAttach',
    config = function()
      local lsp_status = require 'lsp-status'

      -- You'll usually want to register progress messages from LSP servers.
      -- This allows lsp-status to track loading indicators, etc.
      lsp_status.register_progress()

      -- === Integration with your statusline (e.g., Lualine) ===
      -- This is the most common use case.
      -- If you use Lualine, you would add a component that calls lsp_status.status().
      -- Example (adjust for your Lualine config structure):
      -- local lualine = require('lualine')
      -- lualine.setup {
      --   sections = {
      --     lualine_x = {
      --       {
      --         lsp_status.status, -- This is the key part for displaying LSP status
      --         cond = lsp_status.check_client_started, -- Only show if an LSP client is active
      --         color = { fg = '#ffffff' }, -- Customize colors if needed
      --       },
      --     },
      --   },
      -- }

      -- === Optional: Configure kind labels or other options ===
      -- See lsp-status.nvim documentation for all config options.
      lsp_status.config {
        -- Customize the symbols for diagnostic kinds (errors, warnings, etc.)
        indicator_errors = '●',
        indicator_warnings = '●',
        indicator_info = '●',
        indicator_hint = '●',
        indicator_ok = '✓',
        -- You can also customize symbol labels for current function display
        -- kind_labels = {
        --   Text = "",
        --   Method = "",
        --   Function = "",
        --   -- ... more
        -- },
      }

      -- === Optional: Integrate with nvim-lspconfig (if you use it) ===
      -- If you're using nvim-lspconfig, you might want to pass lsp-status.nvim's
      -- capabilities or on_attach function to your LSP server setups.
      -- This helps with features like showing the current function/symbol.
      -- This is an advanced step and depends on your lspconfig setup.
      -- Example within an lspconfig setup:
      -- local lspconfig = require('lspconfig')
      -- lspconfig.lua_ls.setup {
      --   on_attach = lsp_status.on_attach, -- Attach lsp-status's handler
      --   capabilities = lsp_status.capabilities, -- Add lsp-status's capabilities
      --   settings = {
      --     Lua = {
      --       workspace = {
      --         checkThirdParty = false,
      --       },
      --       telemetry = {
      --         enable = false,
      --       },
      --     },
      --   },
      -- }
    end,
    -- Dependencies (optional, but good practice if you use them together)
    dependencies = {
      'neovim/nvim-lspconfig', -- If you use nvim-lspconfig to set up LSP servers
      'nvim-tree/nvim-web-devicons', -- If you want icons for statusline display
      -- 'nvim-lualine/lualine.nvim', -- If you integrate it with Lualine
    },
  },
}
