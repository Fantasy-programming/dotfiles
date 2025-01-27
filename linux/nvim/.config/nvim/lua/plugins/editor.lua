return {
  -- add gruvbox
  { "christoomey/vim-tmux-navigator", lazy = false },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
    config = function()
      require("colorizer").setup({
        filetypes = {
          "css",
          "javascript",
          html = { mode = "foreground" },
        },
        css = true,
      })
    end,
  },
}
