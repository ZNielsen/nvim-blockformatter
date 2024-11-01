-- Copyright © Zach Nielsen 2021

local M = {}

local util = require('blockformatter.common_utils')

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
    local space_per_tab = 4 -- GH-12
    -- print("start: " .. start_line_num .. ", end: " .. end_line_num .. ", col: " .. col)
    -- Get the leading number of spaces from the start line
    local line = vim.fn.getline(start_line_num)
    local whitespace = line:match("^%s+")
    local leading_space_vis_len = 0
    local leading_space_count = 0
    local leading_space_type = " "
    if whitespace ~= nil then
        leading_space_count = whitespace:len()
        leading_space_vis_len = leading_space_count
        if whitespace:sub(1, 1) == "\t" then
            leading_space_type = "\t"
            leading_space_vis_len = leading_space_count * space_per_tab
        end
    end

    if leading_space_vis_len >= col then
        print("Leading space of ["..leading_space_vis_len.."] is greater than requested end column ["..col.."]")
        return
    end
    -- Don't want to reuse `whitespace`, since it can be nil. Make a known-good leading space string
    local leading_space_str = string.rep(leading_space_type, leading_space_count)

    -- Check for leading comment
    local do_comments = false
    local comment = util.line_comment_table(vim.api.nvim_eval('&filetype'))
    local stripped_line = line:gsub("^%s+", "")
    if nil ~= comment and util.leads_with(stripped_line, comment) then
        do_comments = true
    end

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
            local stripped_line = line:gsub("^%s+", "")
            if do_comments then
                stripped_line = stripped_line:gsub(util.esc(comment), "", 1):gsub("^%s+", "")
            end
            holding_str = holding_str .. stripped_line .. " "
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

            -- Set up first word and optional leading comment
            local num_chars = col - leading_space_vis_len;
            local line = holding_str:gsub(next_word_regex, "%1", 1)
            holding_str = holding_str:sub(line:len() + 1)
            local next_word = holding_str:gsub(next_word_regex, "%1", 1)
            if do_comments then
                line = comment .. " " .. line
            end

            -- Grab words that will fit under the specified column (minimum 1)
            while line:len() + next_word:len() <= num_chars and holding_str ~= ""
            do
                line = line .. next_word
                holding_str = holding_str:sub(next_word:len() + 1)
                -- Consolidate any leading whitespace into single space
                holding_str = holding_str:gsub(leading_whitespace_regex, " ")
                next_word, matches = holding_str:gsub(next_word_regex, "%1", 1)
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

