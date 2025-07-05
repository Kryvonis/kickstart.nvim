return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    keys = {
      { '<leader>e', ':Neotree toggle<CR>', desc = 'NeoTree reveal', silent = true },
    },

    opts = {
      bigfile = { enabled = false },
      dashboard = {
        enabled = true,
        sections = {
          { section = 'header' },
          {
            pane = 2,
            section = 'terminal',
            cmd = 'colorscript -e fade',
            height = 5,
            padding = 1,
          },
          { section = 'keys', gap = 1, padding = 1 },
          { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          {
            pane = 2,
            icon = ' ',
            title = 'Git Status',
            section = 'terminal',
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = 'git status --short --branch --renames',
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = 'startup' },
        },
      },
      explorer = { enabled = false },
      indent = { enabled = true },
      input = { enabled = false },
      picker = { enabled = false },
      notifier = { enabled = true },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },
}
