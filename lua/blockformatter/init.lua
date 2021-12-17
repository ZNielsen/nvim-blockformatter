-- Copyright © Zach Nielsen 2021

local modules = {}

table.insert(modules, require('blockformatter.block_normalize'))
table.insert(modules, require('blockformatter.block_comment'))

return modules

