return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
            slash_commands = {
              ["buffer"] = {
                opts = {
                  provider = "fzf_lua", -- Use fzf-lua
                },
              },
              ["file"] = {
                opts = {
                  contains_code = true,
                  max_lines = 1000,
                  provider = "fzf_lua", -- Use fzf-lua
                },
              },
              ["help"] = {
                opts = {
                  contains_code = false,
                  max_lines = 128, -- Maximum number of lines of the help file to send
                  provider = "fzf_lua", -- Use fzf-lua
                },
              },
              ["symbols"] = {
                opts = {
                  contains_code = true,
                  provider = "fzf_lua", -- Use fzf-lua
                },
              },
            },
          },
          inline = {
            adapter = "copilot",
          },
        },
        opts = {
          log_level = "DEBUG",
        },
      })
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      sources = {
        default = { "lsp", "path", "buffer", "codecompanion" },
        cmdline = {}, -- Disable sources for command-line mode
        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
          },
        },
      },
    },
  },
}
