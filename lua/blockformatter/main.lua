local M = {}

function M.format_block_visual(col)
    M.format_block(vim.fn.line("'<"), vim.fn.line("'>"))
end

function M.format_block_normal(num_lines, col)
    -- Get range
    local start_line_num = vim.fn.line('.')
    local end_line_num = start_line_num + num_lines - 1
    M.toggle_comment(start_line_num, end_line_num, col)
end

function M.format_block(start_line_num, end_line_num, col)
    -- Get the leading number of spaces from the start line
    local line = vim.fn.getline(start_line_num)
    local whitespace = line:match("^%s+")
    local leading_space = whitespace:len()

    -- Trim newline + leading whitespace
    local holding_str = ""
    for (line_num=start_line_num,end_line_num) do
        holding_str = holding_str .. line:gsub("^%s+", "")
    end

    -- Dole out newlines + leading whitespace until we have processed
    -- the whole block
    local ret_str = ""
    while (holding_str ~= "")
    do
        -- Strip leading spaces for this line
        holding_str = holding_str:gsub("^%s+", "")

        -- Grab words that will fit in column (minimum 1)
        local num_chars = col - leading_space;
        local line = holding_str:gsub("^(.+)%s.*", "%1")
        holding_str = holding_str:sub(line:len() + 1)
        local next_word = holding_str:gsub("^(.+)%s.*", "%1")
        while (line:len() + next_word:len() < num_chars)
        do
            line = line .. next_word
            holding_str = holding_str:sub(next_word:len() + 1)
            next_word = holding_str:gsub("^(.+)%s.*", "%1")
        end

        ret_str = ret_str .. string.rep(" ", leading_space) .. line .. "\n"
    end

    return ret_str
end

return M

