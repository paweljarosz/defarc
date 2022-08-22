local M = {}
local string, pairs, ipairs = string, pairs, ipairs
local string_gmatch = string.gmatch
local string_gsub = string.gsub

M.code_parser = {}
M.tag_parser = {}

M.default_tag_parser = {}
M.default_tag_parser["p style"] = 				function() return "" end
M.default_tag_parser["/p"] = 					function() return " " end
M.default_tag_parser["span class=\"mention"] = 	function() return "@" end
M.default_tag_parser["/span"] = 				function() return "" end
M.default_tag_parser["strong"] = 				function() return "'" end
M.default_tag_parser["blockquote"] = 			function() return "" end
M.default_tag_parser["pre"] = 					function() return "" end
M.default_tag_parser["a href"] = 				function() return "" end
M.default_tag_parser["/a"] = 					function() return "" end
M.default_tag_parser["&lt;"] = 					function(text) return string_gsub(text, "&lt;", "") end
M.default_tag_parser["&gt;"] = 					function(text) return string_gsub(text, "&gt;", "") end
M.default_tag_parser["special-em-start"] = 		function() return "" end
M.default_tag_parser["/em"] = 					function() return "" end
M.default_tag_parser["special-p-start"] = 		function() return "" end
M.default_tag_parser["special-br-start"] = 		function() return "\n" end

local function overwrite_tag_parser(tag_parser)
	M.tag_parser = tag_parser or M.default_tag_parser
end

local function overwrite_code_parser(code_parser)
	M.code_parser = code_parser or M.default_code_parser
end

local function match(inputstr, sep)
	return string_gmatch(inputstr, "([^"..sep.."]+)")
end

local function parse_html_tag(str)
	if str == "p" then	-- paragraph parsing
		return M.tag_parser["special-p-start"](str) or ""
	elseif str == "em" then	-- emphasized parsing
		return M.tag_parser["special-em-start"](str) or ""
	elseif str == "br" then	-- emphasized parsing
		return M.tag_parser["special-br-start"](str) or ""
	else
		for tag, tag_parser in pairs(M.tag_parser) do
			if string.find(str, tag) then
				return tag_parser(str)
			end
		end
	end
	return str
end

local function parse_splitted(splitted)
	for i, element in ipairs(splitted) do
		splitted[i] = parse_html_tag(element)
		while (splitted[i] ~= parse_html_tag(splitted[i])) do
			splitted[i] = parse_html_tag(splitted[i])
		end

		if element == "code" then
			M.code_parser(splitted, i)
		end
	end
	return splitted
end

local function split(inputstr)
	local t = {}
	local i = 1
	for str in match(inputstr, "<") do		-- opening html tag
		for alt_str in match(str, ">") do	-- closing html tag
			t[i] = alt_str
			i = i + 1
		end
	end
	return t
end

local function join_table_into_string(tab)
	local text = ""
	for i,v in pairs(tab) do
		if v then
			text = text..v
		end
	end
	return text
end

-- tag_parser - a special table with behaviors when a given tag/key is find in the splitted string
-- code_parse - a special function that takes the splitted strings and an index at which the code parsing should start

-- DefArc comes with a default tag and code parsers - compatible with Arcweave html tags and ArcScript
-- Custom tag parser could be useful, for example if you want to use some extensions to display the text in Defold's GUI
-- like RichText or Defold Printer, as they utilize their own styling syntax

-- Example could be to overwrite default <strong> tag parameter for RichText, where e.g. <b> is available:
-- richtext_tag_parser["/strong"] = function() return "</b></color>" end	-- for closing tag
-- tichtext_tag_parser["strong"] = function() return "<color=red><b>" end	-- for opening tag

-- For Defold Printer a different styling syntax is used, so an example like this could be used:
-- dprinter_tag_parser["/strong"] = function() return "{/}" end	-			-- for closing tag
-- dprinter_tag_parser["strong"] = function() return "{strong_style}" end	-- for opening tag (if strong_style is known to Defold Printer)

function M.parse_element_content(content, code_parser, tag_parser)
	overwrite_code_parser(code_parser)
	overwrite_tag_parser(tag_parser)
	local tab = split(content)
	local parsed = parse_splitted(tab)
	local text = join_table_into_string(parsed)
	return text
end

return M