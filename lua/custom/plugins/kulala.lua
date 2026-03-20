-- Sending requests via http
return {
  {
    -- http processor
    'mistweaverco/kulala.nvim',
    keys = {
      { '<leader>Rs', desc = 'Send request' },
      { '<leader>Ra', desc = 'Send all requests' },
      { '<leader>Rb', desc = 'Open scratchpad' },
    },
    ft = { 'http', 'rest' },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = '<leader>R',
      kulala_keymaps_prefix = '',
      -- We explicitly tell kulala to treat fhir+json as json
      content_types = {
        ['application/json'] = 'json',
        ['application/fhir+json'] = 'json',
      },
      formatters = {
        json = { 'jq', '.' },
      },
    },
  },
}
