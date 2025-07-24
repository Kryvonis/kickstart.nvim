return {
  'xiyaowong/transparent.nvim',
  lazy = false, -- Often, transparent.nvim needs to load early
  keys = {
    { '<leader>tt', '<Cmd>TransparentToggle<CR>', desc = 'Toggle Transparency' },
  },
  config = function()
    -- Optional, you don't have to run setup.
    require('transparent').setup {
      -- table: default groups
      groups = {
        'Normal',
        'NormalNC',
        'Comment',
        'Constant',
        'Special',
        'Identifier',
        'Statement',
        'PreProc',
        'Type',
        'Underlined',
        'Todo',
        'String',
        'Function',
        'Conditional',
        'Repeat',
        'Operator',
        'Structure',
        'LineNr',
        'NonText',
        'SignColumn',
        'CursorLine',
        'CursorLineNr',
        'StatusLine',
        'StatusLineNC',
        'EndOfBuffer',
      },
      -- table: additional groups that should be cleared
      extra_groups = {
        -- Bufferline transparency
        'BufferLineBackground',
        'BufferLineFill',
        'BufferLineTab',
        'BufferLineTabSelected',
        'BufferLineTabClose',
        'BufferLineCloseButton',
        'BufferLineCloseButtonSelected',
        'BufferLineCloseButtonVisible',
        'BufferLineSeparator',
        'BufferLineSeparatorSelected',
        'BufferLineSeparatorVisible',
        'BufferLineIndicatorSelected',
        'BufferLineIndicatorVisible',
        'BufferLineModified',
        'BufferLineModifiedSelected',
        'BufferLineModifiedVisible',
        'BufferLineNumbers',
        'BufferLineNumbersSelected',
        'BufferLineNumbersVisible',
        'BufferLinePickSelected',
        'BufferLinePickVisible',
        'BufferLinePick',
        'BufferLineOffsetSeparator',
      },
      -- table: groups you don't want to clear
      exclude_groups = {},
      -- function: code to be executed after highlight groups are cleared
      -- Also the user event "TransparentClear" will be triggered
      on_clear = function() end,
    }
  end,
}
