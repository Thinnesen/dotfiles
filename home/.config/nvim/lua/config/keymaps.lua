-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- herdr/tmux muscle memory: prefix+" splits below, prefix+% splits beside
-- (herdr uses ctrl+space as prefix; in vim it is just <leader>)
vim.keymap.set("n", '<leader>"', "<C-W>s", { desc = "Split Window Below (herdr)", remap = true })
vim.keymap.set("n", "<leader>%", "<C-W>v", { desc = "Split Window Right (herdr)", remap = true })
