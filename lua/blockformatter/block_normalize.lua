-- Copyright © Zach Nielsen 2021

local M = {}

function M.normalize_block_visual(col)
    M.normalize_block(vim.fn.line("'<"), vim.fn.line("'>"), col)
end

function M.normalize_block_normal(num_lines, col)
    -- Get range
    local start_line_num = vim.fn.line('.')
    local end_line_num = start_line_num + num_lines - 1
    M.normalize_block(start_line_num, end_line_num, col)
end

function M.normalize_block(start_line_num, end_line_num, col)
    -- print("start: " .. start_line_num .. ", end: " .. end_line_num .. ", col: " .. col)
    -- Get the leading number of spaces from the start line
    local line = vim.fn.getline(start_line_num)
    local whitespace = line:match("^%s+")
    local leading_space = 0
    if whitespace ~= nil then
        leading_space = whitespace:len()
    end
    -- print("leading_space: " .. leading_space)

    if leading_space >= col then
        print("Leading space of ["..leading_space.."] is greater than requested end column ["..col.."]")
        return
    end
    local leading_space_str = string.rep(" ", leading_space)
    -- print("leading_space_str: [" .. leading_space_str .. "]")

    -- Trim newline + leading whitespace
    local holding_list = {}
    local holding_str = ""
    local table_size = 0
    for line_num=start_line_num,end_line_num do
        local line = vim.fn.getline(line_num)
        if line == "" then
            -- Remove any trailing whitespace
            holding_str = holding_str:gsub("%s+$", "")
            table.insert(holding_list, holding_str)
            table_size = table_size + 1
            holding_str = ""
        else
            holding_str = holding_str .. line:gsub("^%s+", "") .. " "
        end
    end
    -- Remove any trailing whitespace
    holding_str = holding_str:gsub("%s+$", "")
    table.insert(holding_list, holding_str)
    table_size = table_size + 1

    -- Dole out newlines + leading whitespace until we have processed the whole block
    local formatted_list = {}
    local first_loop = 1
    for section_number, holding_str in ipairs(holding_list) do
        while holding_str ~= ""
        do
            -- print("holding_str: [" .. holding_str.."]")

            local next_word_regex = "^(%s*[%g]+)%s.*"
            local leading_whitespace_regex = "^%s+"
            -- Grab words that will fit in column (minimum 1)
            local num_chars = col - leading_space;
            local line = holding_str:gsub(next_word_regex, "%1", 1)
            holding_str = holding_str:sub(line:len() + 1)
            local next_word = holding_str:gsub(next_word_regex, "%1", 1)
            -- print("holding_str: [" .. holding_str.."]")
            -- print("starting word: [" .. line .."]")
            -- print("next word: [" .. next_word.."]")
            -- print("num_chars: "..num_chars..", len()s: " .. line:len()..' + '..next_word:len()..' = '..line:len() + next_word:len())
            while line:len() + next_word:len() < num_chars and holding_str ~= ""
            do
                line = line .. next_word
                holding_str = holding_str:sub(next_word:len() + 1)
                -- Consolidate any leading whitespace into single space
                holding_str = holding_str:gsub(leading_whitespace_regex, " ")
                next_word, matches = holding_str:gsub(next_word_regex, "%1", 1)
                -- print("holding_str: [" .. holding_str.."]")
                -- print("line so far: [" .. line .."]")
                -- print("next word: [" .. next_word.."]")
                -- print("num_chars: "..num_chars..", len()s: " .. line:len()..' + '..next_word:len()..' = '..line:len() + next_word:len())
            end

            table.insert(formatted_list, leading_space_str .. line)

            -- Strip leading spaces for the next line
            holding_str = holding_str:gsub(leading_whitespace_regex, "", 1)
        end

        if section_number < table_size then
            -- Respect the hard break
            table.insert(formatted_list, "")
        end
    end

    vim.fn.deletebufline(vim.fn.bufname(), start_line_num, end_line_num)
    vim.fn.append(start_line_num-1, formatted_list)
end

return M

