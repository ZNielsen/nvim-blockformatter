-- Copyright © Zach Nielsen 2021

local M = {}

local util = require('blockformatter.common_utils')

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
    local space_per_tab = 4 -- GH-12
    local comment = util.line_comment_table(vim.api.nvim_eval('&filetype'))
    local wrapping_comment = util.wrapping_comment_table(vim.api.nvim_eval('&filetype'))

    if comment == nil and wrapping_comment == nil then
        error("Filetype not in comment table. &filetype is " .. vim.api.nvim_eval('&filetype'))
    end

    -- By default prefer single line comments
    local use_wrapping = false
    if comment == nil or (vim.g.prefer_wrapping_comments ~= 0 and wrapping_comment ~= nil) then
        use_wrapping = true
        comment = wrapping_comment['open']
    end

    -- If any lines are uncommented, it's an add
    local nocomment_count = 0
    local add_comment = true
    -- Track the column that the comment will go in
    local comment_col = 9999
    local longest_line = 0
    for line_num=start_line_num,end_line_num do
        local line = vim.fn.getline(line_num)

        -- Strip the leading whitespace
        local whitespace = line:match("^%s+")
        local leading_space_vis_len = 0
        local leading_space_count = 0
        -- Check how much leading whitespace there is
        if whitespace ~= nil and whitespace:len() > 0 then
            leading_space_count = whitespace:len()
            leading_space_vis_len = leading_space_count
            if whitespace:sub(1, 1) == "\t" then
                leading_space_vis_len = leading_space_count * space_per_tab
            end
            line = line:sub(leading_space_count + 1)
            -- Get new minimum space
            comment_col = math.min(comment_col, leading_space_vis_len)
        elseif line ~= "" then
            comment_col = 0
        end

        -- Track the longest line for wrapping comments
        longest_line = math.max(line:len(), longest_line)

        if line ~= "" and false == util.leads_with(line, comment) then
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
            local new_line = ""
            -- Strip the leading whitespace - keep it for later
            local put_whitespace_back = false
            local whitespace = line:match("^%s+")
            local leading_space_count = 0
            local leading_space_type = " "
            local num_space_to_insert = comment_col
            if whitespace ~= nil and whitespace:len() > 0 then
                leading_space_count = whitespace:len()
                if whitespace:sub(1, 1) == "\t" then
                    leading_space_type = "\t"
                    num_space_to_insert = comment_col / space_per_tab
                end
                line = line:sub(leading_space_count + 1)
                put_whitespace_back = true
            end

            if add_comment then
                new_line = comment .. " "
                if put_whitespace_back then
                    -- Add whitespace sandwich
                    new_line = string.rep(leading_space_type, num_space_to_insert) .. new_line .. string.rep(leading_space_type, leading_space_count - num_space_to_insert)
                end

                if use_wrapping then
                    -- Add enough whitespace to line up all the back comments
                    local spaces_to_add = longest_line - line:len() + 1
                    for i=1,spaces_to_add do
                        line = line .. " "
                    end
                    line = line .. wrapping_comment['close']
                end
                new_line = new_line .. line
            elseif util.leads_with(line, comment) then
                -- Remove the comment
                line = line:sub(comment:len()+1)
                -- If there's a leading space, delete it
                if util.leads_with(line, " ") then
                    line = line:sub(2)
                end

                -- Remove the end comment if it's there
                if use_wrapping and util.ends_with(line, wrapping_comment['close']) then
                    line = line:sub(0, line:len() - wrapping_comment['close']:len())
                    -- Strip off all trailing space
                    line = line:gsub("%s+$", "")
                end

                -- Set the new line
                new_line = line
                -- Add the whitespace back in
                if put_whitespace_back then
                    new_line = whitespace .. new_line
                end
            end

            vim.fn.setline(line_num, new_line)
        end
    end
end

return M
