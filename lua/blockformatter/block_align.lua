-- Copyright © Zach Nielsen 2021

local M = {}

function M.token_align_visual()
    M.token_align(vim.fn.line("'<"), vim.fn.line("'>"))
end

function M.token_align_normal(num_lines)
    -- Get range
    local start_line_num = vim.fn.line('.')
    local end_line_num = start_line_num + num_lines - 1
    M.token_align(start_line_num, end_line_num)
end

function M.token_align(start_line_num, end_line_num)
    -- Get character under the cursor. This is the token character.
    -- TODO - might need to do a selection for multi-character keys (e.g. comments tokens)
    -- Grab lines until a line doesn't have the token
    -- Get the column that will allow all tokens to align
    -- Put the proper padding on each line
end

return M

