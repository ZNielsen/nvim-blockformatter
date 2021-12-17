if exists('g:loaded_blockformatter')
    finish
endif


command! -nargs=1 BlockFormat       lua require("BlockFormatter/main").format_block_visual(<args>)


let g:loaded_blockformatter = 1

