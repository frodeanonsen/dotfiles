return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
      local dap = require("dap")

      --
      -- See
      -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Interpreters.html
      -- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Debugger-Adapter-Protocol.html
      dap.adapters.gdb = {
        id = "gdb",
        type = "executable",
        command = "arm-none-eabi-gdb",
        args = { "--quiet", "--interpreter=dap" },
        --[[
    args = {
        '-iex',
        'set debug dap-log-file /tmp/gdb-dap.log',
        '--quiet',
        '--interpreter=dap',
    },
]]
      }

      dap.adapters.cortex_debug = {
        id = "cortex-debug",
        type = "executable",
        command = "/Users/frode/.nvm/versions/node/v20.3.1/bin/node",
        args = { "/Users/frode/git/zygizo/stm/cortex-debug/c/extension/dist/debugadapter.js" },
      }

      dap.configurations.c = {
        {
          name = "Radar",
          type = "cortex_debug",
          executable = "/Users/frode/git/zygizo/stm/radar-sensor-firmware/build/ZygizoHS_STM32_Test.elf",
          request = "launch",
          servertype = "external",
          gdbTarget = "10.0.10.10:3333",
          miDebuggerPath = "arm-none-eabi-gdb",
          cwd = "${workspaceRoot}",
          MImode = "gdb",
        },
      }
    end,
  },
}
--[[
      "showDevDebugOutput": "parsed",
      "cwd": "${workspaceRoot}",
      "executable": "./build/ZygizoHS_STM32_Test.elf",
      "name": "Debug STM32 on zygizo-one",
      "request": "launch",
      "type": "cortex-debug",
      "servertype": "external",
      "gdbTarget": "10.0.10.10:3333",
      "preLaunchTask": "Build STM",
      "device": "stm32g474",
      "configFiles": [
        "openocd.cfg"
      ],
      "svdFile": "STM32F407.svd",
      "liveWatch": {
        "enabled": true,
        "samplesPerSecond": 4
      }
--]]
