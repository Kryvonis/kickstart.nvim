return {
  {
    'akinsho/bufferline.nvim',
    version = '*', -- or a specific tag like "v4.*"
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    keys = {
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>bo', '<Cmd>BufferLineCloseOther<CR>', desc = 'Close Other' },
      { '<leader>bd', '<Cmd>BufferLinePickClose<CR>', desc = 'Close Other' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    },
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers', -- or "tabs"
          diagnostics = 'nvim_lsp',
          right_mouse_command = 'bdelete! %d', -- can be a string | function | false, see "Mouse actions"
          indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
          },
          show_buffer_close_icons = false,
          separator_style = 'thin',
          color_icons = true, -- whether or not to add the filetype icon highlights
          -- These options help with transparency
          show_tab_indicators = true,
          enforce_regular_tabs = false,
          always_show_bufferline = true,
        },
        highlights = {
          -- Let the transparent plugin handle the background clearing
          -- This ensures proper transparency behavior
        },
      }
    end,
  },
}
