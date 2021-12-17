# nvim-blockformatter
A small block formatting plugin for Neovim

| Command                              | Description                                                                |
|--------------------------------------|----------------------------------------------------------------------------|
| `BlockFormatterNormalize <arg>`      | Formats a block of text to wrap at the specified column.                   |
| `BlockFormatterNormalizeRange <arg>` | Formats a visual range of text to wrap at the specified column.            |
| `BlockFormatterComment`              | Toggles a leading comment for the line. May take a leading count argument. |
| `BlockFormatterCommentRange`         | Toggles a leading comment for a visual range.                              |

## Examples
### Block Normalization

#### Example Maps
```
nnoremap <leader>nb100 :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_normal(vim.v.count1, 100)<CR>
nnoremap <leader>nb80  :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_normal(vim.v.count1, 80)<CR>
```

### Block Commenting

#### Example Maps
```
nnoremap \\ :<C-U>silent lua require('blockformatter.block_comment').toggle_comment_normal(vim.v.count1)<CR>
vnoremap \\ :<C-U>silent lua require('blockformatter.block_comment').toggle_comment_visual()<CR>
```
