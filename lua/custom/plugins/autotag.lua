return {
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter', -- optional: load lazily on insert
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {}, -- enables the plugin with default config
  },
}
