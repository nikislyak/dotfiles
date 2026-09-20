return {
  -- sourcekit-lsp ships with Xcode, so it is not installed through mason.
  -- The lspconfig defaults (root_dir, capabilities) are fine; only restrict filetypes so it
  -- doesn't attach next to clangd on c/cpp/objc buffers.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          filetypes = { "swift" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "swift" } },
  },

  -- `swift format` is bundled with the Swift 6+ toolchain
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        swift = { "swift" },
      },
    },
  },

  -- lldb-dap ships with Xcode
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.adapters.lldb = {
        type = "executable",
        command = "xcrun",
        args = { "lldb-dap" },
        name = "lldb",
      }
      dap.configurations.swift = {
        {
          name = "Launch executable",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/.build/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
