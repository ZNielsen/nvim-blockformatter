" Copyright © Zach Nielsen 2021

if exists('g:loaded_blockformatter')
    finish
endif

if !exists('g:prefer_wrapping_comment')
    let g:prefer_wrapping_comment = 0
endif

command! -nargs=1 -range=1 BlockFormatterNormalize          lua require('blockformatter.block_normalize').normalize_block_normal(<count>, <args>)
command! -nargs=1 -range   BlockFormatterNormalizeRange     lua require('blockformatter.block_normalize').normalize_block(<line1>, <line2>, <args>)
" Example maps
" nnoremap <leader>nb100 :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_normal(vim.v.count1, 100)<CR>
" nnoremap <leader>nb80  :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_normal(vim.v.count1, 80)<CR>

command! -range=1 BlockFormatterComment         lua require('blockformatter.block_comment').toggle_comment_normal(<count>)
command! -range   BlockFormatterCommentRange    lua require('blockformatter.block_comment').toggle_comment(<line1>, <line2>)
" Example maps
" nnoremap \\ :<C-U>silent lua require('blockformatter.block_comment').toggle_comment_normal(vim.v.count1)<CR>
" vnoremap \\ :<C-U>silent lua require('blockformatter.block_comment').toggle_comment_visual()<CR>

command! -range=1 BlockFormatterAlign         lua require('blockformatter.block_align').token_align_normal(<count>)
command! -range   BlockFormatterAlignRange    lua require('blockformatter.block_align').token_align_visual()
command!          BlockFormatterAlignAuto     lua require('blockformatter.block_align').token_align_auto()

let g:loaded_blockformatter = 1

