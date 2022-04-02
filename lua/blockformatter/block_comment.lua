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
    local comment = util.comment_table(vim.api.nvim_eval('&filetype'))
    local wrapping_comment = util.wrapping_comment_table(vim.api.nvim_eval('&filetype'))

    if comment == nil and wrapping_comment == nil then
        print("Error getting comment!")
        print("&filetype is " .. vim.api.nvim_eval('&filetype'))
    end

    -- By default prefer single line comments
    local use_wrapping = false
    if comment == nil or (vim.g.prefer_wrapping_comment ~= 0 and wrapping_comment ~= nil) then
        use_wrapping = true
        comment = wrapping_comment['open']
    end

    -- TODO - wrapping comment support
        -- Check if wrapping comment preferred
        -- Do everything the same, but append the closing wrapping at the end
        -- Use the wrapping aligner to tie off the back end
        -- Add stripping off the back comment, if it exists
        -- TODO - decide if we want to detect a wrapping comment?
            -- I'm leaning no, just assume we are undoing what this plugin puts in.

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
        -- Check how much leading whitespace there is
        if whitespace ~= nil and whitespace:len() > 1 then
            line = line:sub(whitespace:len() + 1)
            comment_col = math.min(comment_col, whitespace:len())
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
                if use_wrapping then
                    line = line .. " " .. wrapping_comment['close']
                end
                newline = newline .. line
            elseif util.leads_with(line, comment) then
                -- Remove the comment
                line = line:sub(comment:len()+1)
                -- If there's a leading space, delete it
                if util.leads_with(line, " ") then
                    line = line:sub(2)
                end

                -- Remove the end comment if it's there
                if use_wrapping and util.ends_with(line, wrapping_comment['close']) then
                    print("line, about to remove back: " .. line)
                    line = line:sub(0, line:len() - wrapping_comment['close']:len())
                    print("line, after removing back : " .. line)
                    -- Strip off all trailing space
                    line = line:gsub("%s+$", "")
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

return M
