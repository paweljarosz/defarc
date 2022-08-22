-- All credits goes to Subsoap
-- This is just a slightly extended version of DefString
-- https://github.com/subsoap/defstring
-- A module with a set of extra string functions for Defold

local M = {}

-- Trims text to remove whitespace before and after
function M.trim(s)
	return s:match('^%s*(.-)%s*$')
end

-- Only remove whitespace on left side of string
function M.trim_left(s)
	return s:match('^%s*(.-)$')
end

-- Only remove whitespace on right side of string
function M.trim_right(s)
	return s:match('^(.-)%s*$')
end

-- Replaces extra spaces (2 or more) with single spaces
function M.trim_extraspace(s)
	return s:gsub('%s+', ' ') 
end

-- Capitalizes the first character of a string
function M.capitalize(s)
	return s:sub(1,1):upper()..s:sub(2)
end

-- Capitalizes each word in a string
function M.capitalize_every_word(s)
	return (s:gsub('(%w[%w]*)', function (match) return M.capitalize(match) end))	
end

-- Splits a string into a table based on a delimiter
-- split('a,b,c', ',') returns {'a', 'b', 'c'}
function M.split(s,delimiter)
	delimiter = delimiter or '%s'
	local t={}
	local i=1
	for str in string.gmatch(s, '([^'..delimiter..']+)') do
		t[i] = str
		i = i + 1
	end
	return t
end

-- This version of split will include empty values (useful for parsing CSV files with empty cells properly)
function M.split_include_empty(s,delimiter)
	delimiter = delimiter or '%s'
	local t={}
	local i=1
	for str in string.gmatch(s .. delimiter, '([^' .. delimiter .. ']*)' .. delimiter) do
		t[i] = str
		i = i + 1
	end
	return t
end

-- Joins a table into a single string seperated by a delimiter
function M.join(t,delimiter)
	delimiter = delimiter or ' '
	return table.concat(t, delimiter)	
end

-- Replaces a set string within a string with another string
function M.replace(s,replace_this,replace_with)
	replace_with = M.escape(replace_with)
	return string.gsub(s,replace_this,replace_with)
end

-- Returns true if a target string contains another string
function M.contains(s, target)
	return s:find(target, nil, true) ~= nil
end

-- Returns the number of times a target string is within another string
function M.count(s, target)
	target = M.escape(target)
	local _, count = string.gsub(s, target, '')
	return count
end

-- Returns where the first copy of a target string begins and ends within another string or returns nil
function M.where(s, target)
	string.find(s, target)
end


-- http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/6-b14/java/lang/String.java#String.compareTo%28java.lang.String%29
-- Compares two strings char by char until a difference is found
-- used in sorting based on char value
-- returns 0 if the two strings are equal
-- returns -1 if s1 is greater than s2
-- returns 1 if s2 is greater than s1
function M.compare(s1, s2)
	-- todo, might do add basic sorting too
end

-- Compares two strings like above but doesn't care about case
function M.compare_ignore_case(s1, s2)
end

-- Returns an iterator which will give one character of a string out at a time when called
function M.iterator(s)
	return s:gmatch('.')
end

-- Returns length of a string, here for completeness but you should probably use # directly instead
function M.length(s)
	return #s
end

-- Returns if a string is empty or not
function M.is_empty(s)
	return s == ''
end

-- Returns if a string begins with another target string
function M.is_beginning(s, target)
	return s:sub(1, #target) == target
end

-- Returns if a string ends with another target string
function M.is_ending(s, target)
	return s:sub(-#target) == target
end

-- Returns if a string is contained with a specific beginning and ending
-- leave ending blank to use beginning for both sides
function M.is_contained(s, beginning, ending)
	ending = ending or beginning
	return M.is_beginning(s, beginning) and M.is_ending(s, ending)

end

-- Inserts one string into another at a given position
function M.insert_into(s, position, target)
	local string_head = s:sub(0, position)
	local string_tail = s:sub(position+1)
	return string_head .. target .. string_tail	
end

-- Escapses Lua pattern characters for use in gsub
function M.escape(s)
	return (s:gsub('[[%]%%^$*()%.%+?-]', '%%%1'))
end

-- Returns string with listed chars within removed
function M.strip(s, remove_these_chars)
	return (s:gsub('['..M.escape(remove_these_chars)..']', ''))
end

-- Pads a character to the left until string is as long as length
function M.pad_left(s, pad, length)
	return (pad:rep(length) .. s):sub(-(length > #s and length or #s))
end

-- Pads a character to the right until string is as long as length
function M.pad_right(s, pad, length)
	return (s .. pad:rep(length)):sub(1, length > #s and length or #s)
end

-- Zero pads a string with leading zeroes until it is as long as length
function M.pad_zero(s, length)
	return M.pad_left(s, '0', length)
end

-- Adds commas between every third character from right to left
-- 10000000 becomes 10,000,000
function M.comma(s)
	s = tostring(s)
	while true do
		s, k = string.gsub(s, '^(-?%d+)(%d%d%d)', '%1,%2')
		if (k == 0) then
			break
		end
	end
	return s
end

-- List of javascript escape replacements
local javascript_escape_replacements = {
	['\\'] = '\\\\',
	['\0'] = '\\x00',
	['\b'] = '\\b',
	['\t'] = '\\t',
	['\n'] = '\\n',
	['\v'] = '\\v',
	['\f'] = '\\f',
	['\r'] = '\\r',
	['\''] = '\\\'',
	['\''] = '\\\''
}

-- Makes a string safe for use with Javascript
function M.make_javascript_safe(s)
	s = s:gsub('.', javascript_escape_replacements)
	s = s:gsub( '\226\128\168', '\\\226\128\168' ) -- U+2028
	s = s:gsub( '\226\128\169', '\\\226\128\169' ) -- U+2029
	return s
end

-- Returns characters from a string starting at left until number
function M.get_from_left(s, number)
	return string.sub(s, 1, number)
end

-- Returns characters from a starting starting at right until number
function M.get_from_right(s, number)
	return string.sub(s, -number)
end

-- Replaces the character of a position within a string with character(s)
function M.set_char(s, position, target)
	local string_head = s:sub(0, position-1)
	local string_tail = s:sub(position+1)
	return string_head .. target .. string_tail
end

-- Returns the character at a position from a string
function M.get_char(s, position)
	return s:sub(position,position)
end

-- Returns first word of a string
function M.get_first_word(s)
	return s:gmatch('%w+')()
end

-- Returns last word of a string
function M.get_last_word(s)
	return s:gmatch('(%w+)$')()
end

-- Removes last word of a string
function M.remove_last_word(s, number)
	number = number or 1
	for i=1, number, 1 do
		if s:find(' ') then
			s = string.match(s, '(.-)%s(%S+)$')
		else
			s = ''
		end
	end
	return s
end

-- Validates an e-mail address
function M.validate_email_address(s)
	if (s:match('[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?')) then
		return true
	else
		return false
	end
end

-- Checks if string contains only a-z, A-Z
function M.is_alphabetic(s)
	return not s:find('%A')
end

-- Checks if a string contains only 0-9
function M.is_numeric(s)
	return tonumber(s) and true or false
end

-- Removes any final newline character or space
function M.remove_final_newline(s)
	return M.trim_right(s)
end

-- Returns ordinal suffix (1st 2nd 3rd 4th) for a number
function M.ordinal_suffix(number)
	number = math.abs(number) % 100
	local d = number % 10
	if d == 1 and number ~= 11 then return 'st'
elseif d == 2 and number ~= 12 then return 'nd'
elseif d == 3 and number ~= 13 then return 'rd'
else return 'th' end
end

-- Returns a string which is a concatenated number of copies of a string
function M.duplicate(s, number)
local concatenation = ''
for i=1,number, 1 do
concatenation = concatenation .. s
end
return concatenation
end

-- Wraps a string to a table of strings without cutting off words
function M.wrap_to_table(s, limit)
limit = limit or 72
local here = 1
local buffer = ''
local t = {}
s:gsub('(%s*)()(%S+)()',
function(sp, st, word, fi)
if fi-here > limit then
here = st
table.insert(t, buffer)
buffer = word
else
buffer = buffer..sp..word
end
end)
if(buffer ~= '') then
table.insert(t, buffer)
end
return (t)	
end

-- Wraps a string to a character limit width paragraph
function M.wrap(s, limit)
return table.concat(M.wrap_to_table(s, limit), '\n')
end

-- Shortens a string to a max length and adds a tail if you want (such as ...)
-- set reversed to true to start from line end to left
function M.shorten(s,length,tail,reversed)
tail = tail or '...'
if length < #tail then return tail:sub(1,w) end
if #s > length then
if reversed then
local i = #s - length + 1 + #tail
return tail .. s:sub(i)
else
return s:sub(1,length-#tail) .. tail
end
end
return s
end

-- Removes line breaks
function M.remove_line_breaks(s)
s, _ = string.gsub(s, '\n', ' ')
return s
end

-- Removes all tabs
function M.remove_tabs(s)
s, _ = string.gsub(s, '\t', '')
return s
end

-- Executes arbitrary Lua code based on a string (can be dangerous!!)
-- useful for executing scripts based on loaded level data
-- if you have user levels you don't want to allow this without good filters
-- todo write a filter for this to optionally remove dangerous os functions?
-- or to whitelist certain list of functions only
function M.eval(s)
	return assert((loadstring or load)(s))()
end

-- Replace a table of variables within a string
-- s = "Hello, {player_name}!"
-- variable_list = {player_name = "Defold Master"}
function M.replace_variables(s, variable_list)
	if not variable_list then return s end
	local f = function(x)
		return tostring(variable_list[x] or variable_list[tonumber(x)] or "{" .. x .. "}")
	end
	return (s:gsub("{(.-)}", f))
end

-- Keeps all chars but those on the blacklist
function M.blacklist(s, blacklist, escapeflag)
	if escapeflag then
		return (s:gsub('['..M.escape(blacklist)..']', ''))
	else
		return (s:gsub('['..blacklist..']', ''))
	end
end

-- Removes all chars but those on the whitelist
function M.whitelist(s, whitelist, escapeflag)
	if escapeflag then
		return (s:gsub('[^'..M.escape(whitelist)..']', ''))
	else
		return (s:gsub('[^'..whitelist..']', ''))
	end
end


return M