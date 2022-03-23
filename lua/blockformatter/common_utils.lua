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

function M.comment_table(filetype)
    return local_comment_table[filetype]
end

function M.leads_with(string, lead_query)
    if lead_query == nil and string == nil then
        return true
    end
    if lead_query == nil or string == nil then
        return false
    end
    for i=1,lead_query:len(),1 do
        if string:sub(i,i) ~= lead_query:sub(i,i) then
            return false
        end
    end
    return true
end

-- Escape lua's "pattern" characters
-- See https://stackoverflow.com/questions/9790688/escaping-strings-for-gsub
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

