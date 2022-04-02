-- Copyright © Zach Nielsen 2021

local M = {}

local local_comment_table = {}
local_comment_table['javascript'] = '//'
local_comment_table['dockerfile'] = '#'
local_comment_table['python'] = '#'
local_comment_table['rust'] = '//'
local_comment_table['ruby'] = '#'
local_comment_table['bash'] = '#'
local_comment_table['conf'] = '#' -- For unlabeld bash
local_comment_table['yaml'] = '#'
local_comment_table['toml'] = '#'
local_comment_table['lua'] = '--'
local_comment_table['cpp'] = '//'
local_comment_table['zig'] = '//'
local_comment_table['vim'] = '"'
local_comment_table['sh'] = '#'
local_comment_table['c'] = '//'

local wrapping_comment_table = {}
wrapping_comment_table['html'] = {}
wrapping_comment_table['html']['open'] = '<!--'
wrapping_comment_table['html']['close'] = '-->'
wrapping_comment_table['cpp'] = {}
wrapping_comment_table['cpp']['open'] = '/*'
wrapping_comment_table['cpp']['close'] = '*/'
wrapping_comment_table['c'] = {}
wrapping_comment_table['c']['open'] = '/*'
wrapping_comment_table['c']['close'] = '*/'


function M.comment_table(filetype)
    return local_comment_table[filetype]
end

function M.wrapping_comment_table(filetype)
    return wrapping_comment_table[filetype]
end

function M.leads_with(string, lead_query)
    if lead_query == nil and string == nil then
        return true
    end
    if lead_query == nil or string == nil then
        return false
    end

    for idx=1,lead_query:len(),1 do
        if string:sub(idx,idx) ~= lead_query:sub(idx,idx) then
            return false
        end
    end
    return true
end

function M.ends_with(string, end_query)
    if end_query == nil and string == nil then
        return true
    end
    if end_query == nil or string == nil then
        return false
    end

    for idx=1,end_query:len() do
        local query_idx = end_query:len() + 1 - idx
        local str_idx = string:len() + 1 - idx
        if string:sub(str_idx,str_idx) ~= end_query:sub(query_idx,query_idx) then
            return false
        end
    end
    return true
end

-- Escape lua's "pattern" characters
function M.esc(x)
   return (x:gsub('%%', '%%%%')
            :gsub('^%^', '%%^')
            :gsub('%$$', '%%$')
            :gsub('%(', '%%(')
            :gsub('%)', '%%)')
            :gsub('%.', '%%.')
            :gsub('%[', '%%[')
            :gsub('%]', '%%]')
            :gsub('%*', '%%*')
            :gsub('%+', '%%+')
            :gsub('%-', '%%-')
            :gsub('%?', '%%?'))
end

return M

