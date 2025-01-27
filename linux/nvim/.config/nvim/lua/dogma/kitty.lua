-- set kitty margin and padding to 0 while using neovim
-- no more kitty and neovim colorscheme conflict

vim.cmd([[
augroup kitty_mp
    autocmd!
    au VimLeave * :silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=5 margin=5
    au VimEnter * :silent !kitty @ --to=$KITTY_LISTEN_ON set-spacing padding=0 margin=0
augroup END
]])
