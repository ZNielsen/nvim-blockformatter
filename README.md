# nvim-blockformatter
A small block formatting plugin for Neovim

| Command                              | Description                                                                |
|--------------------------------------|----------------------------------------------------------------------------|
| `BlockFormatterNormalize <arg>`      | Formats a block of text to wrap at the specified column.                   |
| `BlockFormatterNormalizeRange <arg>` | Formats a visual range of text to wrap at the specified column.            |
| `BlockFormatterComment`              | Toggles a leading comment for the line. May take a leading count argument. |
| `BlockFormatterCommentRange`         | Toggles a leading comment for a visual range.                              |


To use, just `Plug 'ZNielsen/nvim-blockformatter'` or similar. Mappings are recommended, as the command names are a bit verbose. Suggestions are below.

The minimap in the examples is [minimap.vim](https://github.com/wfxr/minimap.vim).

## Examples
### Block Normalization
![Block Normalization Example](https://raw.githubusercontent.com/znielsen/nvim-blockformatter/main/.github/images/block_normalizer_example.gif)

#### Example Maps
```
nnoremap <leader>nb100 :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_normal(vim.v.count1, 100)<CR>
nnoremap <leader>nb80  :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_normal(vim.v.count1, 80)<CR>
vnoremap <leader>nb100 :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_visual(100)<CR>
vnoremap <leader>nb80  :<C-U>silent lua require("blockformatter.block_normalize").normalize_block_visual(80)<CR>
```

### Block Commenting
![Block Commenting Example](https://raw.githubusercontent.com/znielsen/nvim-blockformatter/main/.github/images/block_commenter_example.gif)

#### Example Maps
```
nnoremap \\ :<C-U>silent lua require('blockformatter.block_comment').toggle_comment_normal(vim.v.count1)<CR>
vnoremap \\ :<C-U>silent lua require('blockformatter.block_comment').toggle_comment_visual()<CR>
```


#### Supported filetypes
- Javascript
- Dockerfile
- Python
- Rust
- Ruby
- Bash
- Yaml
- Toml
- Lua
- Cpp
- Zig
- Vim
- sh
- C
