-- Copyright © Zach Nielsen 2021

local M = {}

local util = require('blockformatter.common_utils')

local function get_token(cursor_pos)
    -- Get character/word under the cursor. This is the token character.
    -- DANGER - col is byte position - may not work with larger unicode characters
    local line_num  = cursor_pos[2]
    local start_col = cursor_pos[3]
    local end_col   = cursor_pos[3]

    local line = vim.fn.getline(line_num)
    while line:sub(start_col-1, start_col-1) ~= " " do
        -- print("idx [".. start_col-1 .."]: [" .. line:sub(start_col-1, start_col-1) .."]")
        start_col = start_col - 1
    end
    while line:sub(end_col+1, end_col+1) ~= " " do
        -- print("idx [".. end_col+1 .."]: [" .. line:sub(end_col+1, end_col+1) .."]")
        end_col = end_col + 1
    end

    return line:sub(start_col, end_col)
end

function M.token_align_auto()
    M.token_align(get_token(vim.fn.getpos('.')), vim.fn.line('.'), nil)
end

function M.token_align_visual()
    M.token_align(get_token(vim.fn.getpos('.')), vim.fn.line("'<"), vim.fn.line("'>"))
end

function M.token_align_normal(num_lines)
    -- Get range
    local start_line_num = vim.fn.line('.')
    local end_line_num = start_line_num + num_lines - 1
    M.token_align(get_token(vim.fn.getpos('.')), start_line_num, end_line_num)
end

-- end_line_num is optional, it's the upper bound for where to format
function M.token_align(token, start_line_num, end_line_num)
    --
    -- Grab lines until a line doesn't have the token
    -- Get the column that will allow all tokens to align
    --
    local align_col = 0
    local line_num = start_line_num
    local lines_in_file = vim.api.nvim_buf_line_count(0)
    local looping = true
    while looping do
        local line = vim.fn.getline(line_num)

        -- Check if this line has the token
        local find_start = line:find(util.esc(token))
        if nil ~= find_start then
            -- Get the alignment position for this line
            local pre_token = line:sub(0, find_start-1)
            pre_token = pre_token:gsub("%s+$", "")
            align_col = math.max(align_col, pre_token:len())
        else
            -- If we hit the end of the file, we are done looking.
            -- If we don't have a hard end line number, we are done looping when
            -- we hit a line that doesn't have the token. Set the end line number
            -- for later.
            if line == lines_in_file or nil == end_line_num then
                looping = false
                end_line_num = line_num
            end
        end

        -- Check if there is a cap
        if nil ~= end_line_num and line_num >= end_line_num then
            looping = false
        end

        line_num = line_num + 1
    end

    -- Put the proper padding on each line
    for line_num=start_line_num,end_line_num do
        local line = vim.fn.getline(line_num)
        local find_start = line:find(util.esc(token))
        if nil ~= find_start then
            -- Get the alignment position for this line
            local post_token = line:sub(find_start)
            local pre_token = line:sub(0, find_start-1)
            pre_token = pre_token:gsub("%s+$", "")

            -- Insert spaces as needed
            pre_token = pre_token .. string.rep(" ", align_col - pre_token:len() + 1)
            local new_line = pre_token .. post_token

            vim.fn.setline(line_num, new_line)
        end
    end
end

return M

