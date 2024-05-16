-- Copyright © Zach Nielsen 2021

local M = {}

local line_comment_table = {}
line_comment_table['javascript'] = '//'
line_comment_table['dockerfile'] = '#'
line_comment_table['sshconfig'] = '#'
line_comment_table['mermaid'] = '%%'
line_comment_table['python'] = '#'
line_comment_table['rust'] = '//'
line_comment_table['ruby'] = '#'
line_comment_table['bash'] = '#'
line_comment_table['conf'] = '#' -- For unlabeld bash
line_comment_table['yaml'] = '#'
line_comment_table['toml'] = '#'
line_comment_table['cfg'] = '#'
line_comment_table['lua'] = '--'
line_comment_table['cpp'] = '//'
line_comment_table['zig'] = '//'
line_comment_table['vim'] = '"'
line_comment_table['go'] = '//'
line_comment_table['sh'] = '#'
line_comment_table['c'] = '//'
line_comment_table[''] = '#'

local wrapping_comment_table = {}
wrapping_comment_table['markdown'] = {}
wrapping_comment_table['markdown']['open'] = '<!--'
wrapping_comment_table['markdown']['close'] = '-->'
wrapping_comment_table['html'] = {}
wrapping_comment_table['html']['open'] = '<!--'
wrapping_comment_table['html']['close'] = '-->'
wrapping_comment_table['cpp'] = {}
wrapping_comment_table['cpp']['open'] = '/*'
wrapping_comment_table['cpp']['close'] = '*/'
wrapping_comment_table['css'] = {}
wrapping_comment_table['css']['open'] = '/*'
wrapping_comment_table['css']['close'] = '*/'
wrapping_comment_table['c'] = {}
wrapping_comment_table['c']['open'] = '/*'
wrapping_comment_table['c']['close'] = '*/'
wrapping_comment_table[''] = '#'


function M.line_comment_table(filetype)
    return line_comment_table[filetype]
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

