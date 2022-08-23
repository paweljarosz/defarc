local M = {}

local string, pairs, ipairs = string, pairs, ipairs
local string_gmatch = string.gmatch
local string_gsub = string.gsub
local string_sub = string.sub
local string_find = string.find

M.code_parser = {}
M.tag_parser = {}

M.default_tag_parser = {}
M.default_tag_parser["p style"] = 				function() return "" end
M.default_tag_parser["/p"] = 					function() return " " end
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
M.default_tag_parser["span class=\"mention"] = 	function(text, defarc)
	local c_id_start = string_find(text, "data%-id=")	-- escape - with %, because - is special
	local c_id_end = string_find(text, "data%-type=\"component\"")
	pprint("Mention", text, c_id_start, c_id_end)
	if c_id_start and c_id_end then
		c_id_start = c_id_start + 9
		c_id_end = c_id_end - 3
		local component_id = string_sub(text, c_id_start, c_id_end)
		pprint("CI", component_id)
		local c_asset = defarc.get_component_assets(component_id)
		local c_asset_id = c_asset and c_asset.cover and c_asset.cover.id
		local asset = defarc.get_asset_by_id(c_asset_id)

		if asset and asset.type and asset.type == "template-image" and asset.name then
			local splitted = defarc.split(asset.name, ".")
			pprint(defarc.displaying_image_component_cb)
			defarc.displaying_image_component_cb(splitted[1])
		end
		pprint("Get", c_asset, asset)
	end
	return "@"
end

local function overwrite_tag_parser(tag_parser)
	M.tag_parser = tag_parser or M.default_tag_parser
end

local function overwrite_code_parser(code_parser)
	M.code_parser = code_parser or M.default_code_parser
end

local function parse_html_tag(str, defarc)
	if str == "p" then	-- paragraph parsing
		return M.tag_parser["special-p-start"](str) or ""
	elseif str == "em" then	-- emphasized parsing
		return M.tag_parser["special-em-start"](str) or ""
	elseif str == "br" then	-- emphasized parsing
		return M.tag_parser["special-br-start"](str) or ""
	else
		for tag, tag_parser in pairs(M.tag_parser) do
			if string_find(str, tag) then
				return tag_parser(str, defarc)
			end
		end
	end
	return str
end

local function parse_splitted(splitted, defarc)
	for i, element in ipairs(splitted) do
		splitted[i] = parse_html_tag(element, defarc)
		while (splitted[i] ~= parse_html_tag(splitted[i])) do
			splitted[i] = parse_html_tag(splitted[i])
		end

		if element == "code" then
			M.code_parser(splitted, i)
		end
	end
	return splitted
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

function M.parse_element_content(content, defarc)
	overwrite_code_parser(defarc.arcscript_code_parser)
	overwrite_tag_parser(tag_parser)
	local tab = defarc.split(content, "<", ">")
	local parsed = parse_splitted(tab, defarc)
	local text = join_table_into_string(parsed)
	return text
end

return M