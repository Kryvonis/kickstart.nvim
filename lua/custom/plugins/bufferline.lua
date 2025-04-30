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
          indicator = {
            style = 'underline',
          },
          show_buffer_close_icons = false,
          show_close_icon = true,
          separator_style = 'slant',
        },
      }
    end,
  },
}
