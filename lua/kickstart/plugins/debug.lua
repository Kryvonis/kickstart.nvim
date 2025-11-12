-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<leader>do',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
        'js-debug-adapter',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
    
    -- Python DAP configuration
    -- Configure adapter to use Mason's global debugpy (no per-project install needed)
    local mason_debugpy = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
    
    dap.adapters.python = {
      type = 'executable',
      command = mason_debugpy,
      args = { '-m', 'debugpy.adapter' },
    }

    -- Additional Python configurations (current file and FastAPI via uvicorn)
    dap.configurations.python = dap.configurations.python or {}
    
    -- Helper to resolve project python from VIRTUAL_ENV or Poetry
    local function resolve_python()
      -- Try Poetry first
      local handle = io.popen('poetry env info -p 2>/dev/null')
      if handle then
        local result = handle:read('*a')
        handle:close()
        if result and result ~= '' then
          local poetry_venv = result:gsub('%s+', '')
          if poetry_venv ~= '' then
            return poetry_venv .. '/bin/python'
          end
        end
      end
      
      -- Fall back to VIRTUAL_ENV
      local venv = os.getenv('VIRTUAL_ENV')
      if venv and venv ~= '' then
        return venv .. '/bin/python'
      end
      
      return 'python'
    end

    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Python: Current file',
      program = '${file}',
      console = 'integratedTerminal',
      cwd = vim.fn.getcwd(),
      pythonPath = resolve_python,
    })

    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Python: FastAPI (uvicorn) - port 8000',
      module = 'uvicorn',
      args = { 'app.main:app', '--host', '127.0.0.1', '--port', '8000' },
      console = 'integratedTerminal',
      cwd = vim.fn.getcwd(),
      pythonPath = resolve_python,
      justMyCode = false,
    })

    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Python: FastAPI (uvicorn) - custom port',
      module = 'uvicorn',
      args = function()
        local port = vim.fn.input('Port number: ', '8000')
        return { 'app.main:app', '--host', '127.0.0.1', '--port', port }
      end,
      console = 'integratedTerminal',
      cwd = vim.fn.getcwd(),
      pythonPath = resolve_python,
      justMyCode = false,
    })
    -- TypeScript/JavaScript DAP configuration
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      -- Use Mason's js-debug server entrypoint
      args = { vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js' },
    }

    -- Modern JS debugger (pwa-node) via js-debug-adapter
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        -- Use Mason's js-debug server entrypoint
        args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.configurations.typescript = {
      {
        name = 'Debug TypeScript',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
    }

    dap.configurations.javascript = dap.configurations.typescript

    -- NestJS: Launch compiled dist (requires source maps in tsconfig and a prior build)
    table.insert(dap.configurations.typescript, {
      name = 'NestJS: Launch (dist)',
      type = 'pwa-node',
      request = 'launch',
      program = '${workspaceFolder}/dist/main.js',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      outFiles = { '${workspaceFolder}/dist/**/*.js' },
      console = 'integratedTerminal',
      skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
      resolveSourceMapLocations = { '${workspaceFolder}/dist/**/*.js', '!**/node_modules/**' },
    })

    -- NestJS: Launch using ts-node (ensure ts-node is installed; adjust if using ESM)
    table.insert(dap.configurations.typescript, {
      name = 'NestJS: Launch (ts-node)',
      type = 'pwa-node',
      request = 'launch',
      runtimeExecutable = 'node',
      runtimeArgs = { '-r', 'ts-node/register', '-r', 'tsconfig-paths/register' },
      program = '${workspaceFolder}/src/main.ts',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
      skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
      resolveSourceMapLocations = { '${workspaceFolder}/**/*.ts', '!**/node_modules/**' },
      env = { TS_NODE_PROJECT = '${workspaceFolder}/tsconfig.json' },
    })

    -- NestJS: Attach to running process (pick process)
    table.insert(dap.configurations.typescript, {
      name = 'NestJS: Attach (pick process)',
      type = 'pwa-node',
      request = 'attach',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
      resolveSourceMapLocations = { '${workspaceFolder}/dist/**/*.js', '${workspaceFolder}/**/*.ts', '!**/node_modules/**' },
    })

    -- NestJS: Attach to default inspector port 9229 (use with `npm run start:debug`)
    table.insert(dap.configurations.typescript, {
      name = 'NestJS: Attach (9229)',
      type = 'pwa-node',
      request = 'attach',
      address = '127.0.0.1',
      port = 9229,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
      resolveSourceMapLocations = { '${workspaceFolder}/dist/**/*.js', '${workspaceFolder}/**/*.ts', '!**/node_modules/**' },
    })
  end,
}
