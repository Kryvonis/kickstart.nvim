-- Bottom bar with add info
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'nightfox',
          disabled_filetypes = { 'dashboard', 'startify', 'NvimTree', 'packer' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            { 'filename', path = 1 },
            { 'diagnostics', sources = { 'nvim_lsp' } },
          },
          lualine_x = {
            {
              function()
                local ok, lsp_status = pcall(require, 'lsp-status')
                if ok then
                  return lsp_status.status()
                end
                return ''
              end,
            },
            'diff',
          },
          lualine_y = { 'filetype' },
          lualine_z = {
            { 'progress', padding = { right = 0 }, separator = '' },
            { 'location', padding = { left = 0 } },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
}
