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
        },
        highlights = {
          -- This section allows you to override individual highlight groups for bufferline
          -- Set the foreground color of the separator characters
          separator = {
            -- Set 'fg' to a color that complements your theme.
            -- You can use a hex code (e.g., '#4b4b4b' for a dark gray)
            -- Or you can inherit from another highlight group (e.g., 'Comment' or 'Normal')
            -- Let's try inheriting from 'Comment' which is usually a softer color in dark themes:
            fg = { attribute = 'fg', highlight = 'Comment' },
            -- Ensure background is transparent if not already. This is redundant if you did Step 1, but harmless.
            bg = { attribute = 'bg', highlight = 'TabLineFill' }, -- Inherit background from TabLineFill (which we set to none)
          },
          separator_selected = {
            -- For the separator next to the currently selected buffer
            fg = { attribute = 'fg', highlight = 'Comment' }, -- Or a slightly different color if you prefer
            bg = { attribute = 'bg', highlight = 'TabLineFill' },
          },
          -- You might also want to ensure the actual buffer names have appropriate backgrounds too
          -- buffer_selected = { bg = { attribute = 'bg', highlight = 'TabLineFill' } },
          -- buffer_visible = { bg = { attribute = 'bg', highlight = 'TabLineFill' } },
          -- buffer_current = { bg = { attribute = 'bg', highlight = 'TabLineFill' } },
          -- buffer_inactive = { bg = { attribute = 'bg', highlight = 'TabLineFill' } },
        },
      }
    end,
  },
}
