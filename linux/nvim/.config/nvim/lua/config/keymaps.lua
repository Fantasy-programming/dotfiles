-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local discipline = require("dogma/discipline")
-- discipline.cowboy()

local opts = { noremap = true, silent = true }
local keymap = vim.keymap

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", { desc = "Go to next tab", silent = true })
keymap.set("n", "<s-tab>", ":tabprev<Return>", { desc = "Go to previous tab", silent = true })

keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Goto Windows left", silent = true })
keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Goto Windows right", silent = true })

-- -- Split window
-- vim.keymap.set("n", "ss", ":split<Return>", { desc = "Split the window horizontaly", silent = true })
-- vim.keymap.set("n", "sv", ":vsplit<Return>", { desc = "Split the window vertically", silent = true })

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
vim.api.nvim_create_user_command("W", "w !sudo tee > /dev/null %", {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Pick a buffer
keymap.set("n", "<Leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", {})
keymap.set("n", "<Leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", {})
keymap.set("n", "<Leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", {})
keymap.set("n", "<Leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", {})
keymap.set("n", "<Leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", {})
keymap.set("n", "<Leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", {})
keymap.set("n", "<Leader>9", "<Cmd>BufferLineGoToBuffer -1<CR>", {})

-- Moving text
-- Move text up and down

keymap.set("v", "<C-k>", ":m .-2<CR>", opts)
keymap.set("v", "<C-j>", ":m .+1<CR>", opts)
keymap.set("x", "<C-j>", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "<C-k>", ":move '<-2<CR>gv-gv", opts)

-- Diagnostics
keymap.set("n", "<C-Down>", function()
  vim.diagnostic.goto_next()
end, opts)

-- AI
keymap.set("n", "<leader>aic", "<cmd>CodeCompanionToggle<cr>", {
  desc = "Chat with AI",
  silent = true,
})

keymap.set("n", "<leader>ai<CR>", "<cmd>CodeCompanionInlineAssist<cr>", {
  desc = "Inline AI Assist",
  silent = true,
})

-- require("which-key").register({
--   ["<leader>a"] = { name = "CodeCompanion", _ = "which_key_ignore" },
-- })
