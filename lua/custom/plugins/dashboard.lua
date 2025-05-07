return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('dashboard').setup {
        config = {
          header = {
            '   NEOVIM   ',
            -- add your own ASCII art here if you want
          },
        },
      }
    end,
  },
}
