-- Copyright © Zach Nielsen 2021

local M = {}

function M.toggle_comment_visual()
    M.toggle_comment(vim.fn.line("'<"), vim.fn.line("'>"))
end

function M.toggle_comment_normal(num_lines)
    -- Get range
    local start_line_num = vim.fn.line('.')
    local end_line_num = start_line_num + num_lines - 1
    M.toggle_comment(start_line_num, end_line_num)
end

function M.toggle_comment(start_line_num, end_line_num)
    -- Insert value from comment table into beginning of line
    local comment_table = {}
    comment_table['javascript'] = '//'
    comment_table['dockerfile'] = '#'
    comment_table['python'] = '#'
    comment_table['rust'] = '//'
    comment_table['ruby'] = '#'
    comment_table['bash'] = '#'
    comment_table['yaml'] = '#'
    comment_table['toml'] = '#'
    comment_table['lua'] = '--'
    comment_table['cpp'] = '//'
    comment_table['cpp'] = '//'
    comment_table['zig'] = '//'
    comment_table['vim'] = '"'
    comment_table['sh'] = '#'
    comment_table['c'] = '//'
    local comment = comment_table[vim.api.nvim_eval('&filetype')]
    if comment == nil then
        print("Error getting comment!")
        print("&filetype is " .. vim.api.nvim_eval('&filetype'))
    end

    -- If any lines are uncommented, it's an add
    local nocomment_count = 0
    local add_comment = true
    -- Track the column that the comment will go in
    local comment_col = 9999
    for line_num=start_line_num,end_line_num do
        local line = vim.fn.getline(line_num)

        -- Strip the leading whitespace
        local whitespace = line:match("^%s+")
        if whitespace ~= nil and whitespace:len() > 1 then
            line = line:sub(whitespace:len() + 1)
            comment_col = math.min(comment_col, whitespace:len())
        elseif line ~= "" then
            comment_col = 0
        end

        if line ~= "" and false == leads_with(line, comment) then
            nocomment_count = nocomment_count + 1
        end
    end

    if nocomment_count == 0 then
        comment_col = 0
        add_comment = false
    end

    for line_num=start_line_num,end_line_num do
        -- Get the line
        local line = vim.fn.getline(line_num)
        if line ~= "" then
            local newline = ""
            -- Strip the leading whitespace - keep it for later
            local put_whitespace_back = false
            local whitespace = line:match("^%s+")
            if whitespace ~= nil and whitespace:len() > 1 then
                line = line:sub(whitespace:len() + 1)
                put_whitespace_back = true
            end

            if add_comment then
                newline = comment .. " "
                if put_whitespace_back then
                -- Add whitespace sandwich
                newline = string.rep(" ", comment_col) .. newline .. string.rep(" ", whitespace:len() - comment_col)
                end
                newline = newline .. line
            elseif leads_with(line, comment) then
                -- Remove the comment
                line = line:sub(comment:len()+1)
                -- If there's a leading space, delete it
                if leads_with(line, " ") then
                line = line:sub(2)
                end
                -- Set the new line
                newline = line
                -- Add the whitespace back in
                if put_whitespace_back then
                newline = whitespace .. newline
                end
            end

            vim.fn.setline(line_num, newline)
        end
    end
end

function leads_with(string, lead_query)
    -- print("string:[" .. string .. "] length: " .. string:len())
    -- print("query: [" .. lead_query .."], length: " .. lead_query:len())
    for i=1,lead_query:len(),1 do
        -- print("idx [" .. i .. "]: string[" .. string:sub(i,i) .. "], query[" .. lead_query:sub(i,i) .. "]")
        if string:sub(i,i) ~= lead_query:sub(i,i) then
            return false
        end
    end
    return true
end

return M
