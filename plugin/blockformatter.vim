if exists('g:loaded_blockformatter')
    finish
endif


command! -nargs=1 -range   BlockFormatterNormalize       lua require("blockformatter").normalize_block_visual(<args>)
" Example normal mode map
" nnoremap <leader>nb100 :<C-U>silent lua require("blockformatter").normalize_block_normal(vim.v.count1, 100)<CR>
" nnoremap <leader>nb80  :<C-U>silent lua require("blockformatter").normalize_block_normal(vim.v.count1, 80)<CR>

let g:loaded_blockformatter = 1

