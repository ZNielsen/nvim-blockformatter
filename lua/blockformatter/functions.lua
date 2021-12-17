local M = {}

function M.format_block_visual(col)
    M.format_block(vim.fn.line("'<"), vim.fn.line("'>"), col)
end

function M.format_block_normal(num_lines, col)
    -- Get range
    local start_line_num = vim.fn.line('.')
    local end_line_num = start_line_num + num_lines - 1
    M.format_block(start_line_num, end_line_num, col)
end

function M.format_block(start_line_num, end_line_num, col)
    print("start: " .. start_line_num .. ", end: " .. end_line_num .. ", col: " .. col)
    -- Get the leading number of spaces from the start line
    local line = vim.fn.getline(start_line_num)
    local whitespace = line:match("^%s+")
    local leading_space = 0
    if whitespace ~= nil then
        leading_space = whitespace:len()
    end
    print("leading_space: " .. leading_space)

    if leading_space >= col then
        print("Leading space of ["..leading_space.."] is greater than requested end column ["..col.."]")
        return
    end
    local leading_space_str = string.rep(" ", leading_space)
    print("leading_space_str: [" .. leading_space_str .. "]")

    -- Trim newline + leading whitespace
    local holding_str = ""
    for line_num=start_line_num,end_line_num do
        local line = vim.fn.getline(line_num)
        holding_str = holding_str .. line:gsub("^%s+", "") .. " "
    end
    -- Remove any trailing whitespace
    holding_str = holding_str:gsub("%s+$", "")


    -- Dole out newlines + leading whitespace until we have processed
    -- the whole block
    local ret_str = ""
    local formatted_list = {}
    while holding_str ~= ""
    do
        -- print("holding_str: [" .. holding_str.."]")

        -- local next_word_regex = "^(%s*[%w%p]+)%s.*"
        local next_word_regex = "^(%s-.-)%s?.*"
        local leading_whitespace_regex = "^%s+"
        -- Grab words that will fit in column (minimum 1)
        local num_chars = col - leading_space;
        local line = holding_str:gsub(next_word_regex, "%1", 1)
        holding_str = holding_str:sub(line:len() + 1)
        local next_word = holding_str:gsub(next_word_regex, "%1", 1)
        print("holding_str: [" .. holding_str.."]")
        print("starting word: [" .. line .."]")
        print("next word: [" .. next_word.."]")
        print("num_chars: "..num_chars..", len()s: " .. line:len()..' + '..next_word:len()..' = '..line:len() + next_word:len())
        while line:len() + next_word:len() < num_chars and holding_str ~= "" and matches ~= 0
        do
            line = line .. next_word
            holding_str = holding_str:sub(next_word:len() + 1)
            next_word, matches = holding_str:gsub(next_word_regex, "%1", 1)
            print("holding_str: [" .. holding_str.."]")
            print("line so far: [" .. line .."]")
            print("next word: [" .. next_word.."]")
            print("num_chars: "..num_chars..", len()s: " .. line:len()..' + '..next_word:len()..' = '..line:len() + next_word:len())

            -- Consolidate whitespace into single space
            holding_str = holding_str:gsub(leading_whitespace_regex, " ")
        end

        ret_str = ret_str .. leading_space_str .. line .. "\n"
        table.insert(formatted_list, leading_space_str .. line)

        -- Strip leading spaces for the next line
        holding_str = holding_str:gsub(leading_whitespace_regex, "", 1)
    end

    vim.fn.deletebufline(vim.fn.bufname(), start_line_num, end_line_num)
    vim.fn.append(start_line_num-1, formatted_list)
end

return M

