local M = {}

-- DefArc - is an asset that allows Defold and Lua users to easily game narrative, that utilizes ArcWeave.
-- ArcWeave is an enhanced, free, online tool helping design games narratives, linear or non-linear, branching, interactive conversations.
-- DefArc is an incarnation or inheritance from original module I made - DeFork - a tool that parses Twine created JSONs.
-- Below code is written by Pawel Jarosz. Feel free to use it any way you want it as long as you include the original copyright
-- and license notice in any copy of the software/source. (MIT full license: https://opensource.org/licenses/MIT)

-------------------------------------------  [ DefArc ] -----------------------------------------------

--localise globals
local require, sys, json, pairs, type, load = require, sys, json, pairs, type, load
local tonumber, tostring, string, table = tonumber, tostring, string, table
local setmetatable, print = setmetatable, print
local string_gmatch, string_find, string_len, string_sub = string.gmatch, string.find, string.len, string.sub
local table_insert = table.insert

local parser = require "defarc.parser"

M.verbose = false
M.dialogue_data = {}
local VARIABLE_SAVED = "variable_saved"

local function verbose_print(text, arg)
	if M.verbose then
		print("DefArc: "..text, arg)
	end
end

function M.load(resource)
	if not resource then
		local data = sys.load_resource(resource)
		M.dialogue_data = json.decode(data)
		if not M.dialogue_data then
			verbose_print("Could not load data from resource: ", resource)
			return nil
		end
		return M.dialogue_data
	end
	verbose_print("No resource given.")
	return false
end

function M.create(resource)
	local instance = {}
	instance.dialogue_data = M.load(resource)
	return setmetatable(instance, { __index = M })
end

function M.get_project_name()
	return M.dialogue_data and M.dialogue_data.name
end

function M.get_project_cover()
	return M.dialogue_data and M.dialogue_data.cover
end

----------- BOARDS -------------

function M.get_boards()
	local boards = M.dialogue_data and M.dialogue_data.boards
	if not boards then
		verbose_print("No boards in the project")
	end
	return boards
end

function M.get_boards_names()
	local names = nil
	local boards = M.get_boards()
	if boards then
		names = {}
		for id,board in pairs(boards) do
			names[id] = board.name
		end
	end
	return names
end

function M.get_board_by_id(board_id)
	local boards = M.get_boards()
	return boards and boards[board_id]
end

function M.get_board_by_name(name)
	local boards = M.get_boards()
	if boards then
		for _,board in pairs(boards) do
			if board.name == name then
				return board
			end
		end
	end
	verbose_print("No board with given name: ", name)
	return nil
end

function M.get_board(board)
	if board then
		if type(board) == "string" then
			local board_by_id = M.get_board_by_id(board)
			if board_by_id then
				return board_by_id
			else
				return M.get_board_by_name(board) or M.board_selected
			end
		else
			return board or M.board_selected
		end
	else
		return M.board_selected
	end
end

function M.select_board_by_id(board_id)
	M.board_selected = M.get_board_by_id(board_id)
end

function M.select_board_by_name(name)
	M.board_selected = M.get_board_by_name(name)
end

function M.select_board(board)
	M.board_selected = M.get_board(board)
end

function M.get_board_name(board)
	board = M.get_board(board)
	return board and board.name
end

----------- BOARD CONTENTS -------------

function M.get_board_notes(board)
	board = M.get_board(board)
	local data = M.dialogue_data.notes
	if data then
		local notes = {}
		for id, note in pairs(data) do
			notes[id] = note
		end
		return notes
	else
		verbose_print("No notes in the board")
		return nil
	end
end

function M.get_board_jumpers(board)
	local jumpers = {}
	board = M.get_board(board)
	local data = M.dialogue_data.jumpers
	if data then
		for id,jumper in pairs(data) do
			jumpers[id] = jumper.elementId
		end
		return jumpers
	else
		verbose_print("No jumpers in the board")
		return nil
	end
end

function M.get_board_branches(board)
	local branches = {}
	board = M.get_board(board)
	local data = M.dialogue_data.branches
	if data then
		for id,branch in pairs(data) do
			branches[id] = branch
		end
		return branches
	else
		verbose_print("No branches in the board")
		return nil
	end
end

function M.get_board_elements(board)
	local elements = {}
	board = M.get_board(board)
	local data = M.dialogue_data.elements
	if data then
		for id,element in pairs(data) do
			elements[id] = element
		end
		return elements
	else
		verbose_print("No elements in the board")
		return nil
	end
end

function M.get_board_connections(board)
	local connections = {}
	board = M.get_board(board)
	local data = M.dialogue_data.connections
	if data then
		for id,connection in pairs(data) do
			connections[id] = connection
		end
		return connections
	else
		verbose_print("No connections in the board")
		return nil
	end
end

----------- COMPONENTS -------------

function M.get_components()
	local components = M.dialogue_data and M.dialogue_data.components
	if not components then
		verbose_print("No components in the project")
	end
	return components
end

function M.get_components_names()
	local data = M.dialogue_data.components
	if data then
		local components = {}
		for id,component in pairs(data) do
			components[id] = component.name
		end
		return components
	else
		verbose_print("No components in the project")
		return nil
	end
end

function M.get_component_by_id(id)
	local components = M.get_components()
	return components and components[id]
end

function M.get_component_by_name(name)
	local data = M.dialogue_data.components
	for id,component in pairs(data) do
		if component.name == name then
			return component
		end
	end
	return nil
end

function M.get_component(component)
	if component then
		if type(component) == "string" then
			local component_by_id = M.get_component_by_id(component)
			if component_by_id then
				return component_by_id
			else
				return M.get_component_by_name(component)
			end
		else
			return component
		end
	else
		return M.component_selected
	end
end

function M.select_component_by_id(id)
	M.component_selected = M.get_component_by_id(id)
end

function M.select_component_by_name(name)
	M.component_selected = M.get_component_by_name(name)
end

function M.select_component(component)
	M.component_selected = M.get_component(component)
end

----------- COMPONENT CONTENTS -------------

function M.get_component_name(component)
	component = M.get_component(component)
	return component and component.name
end

function M.get_component_attributes(component)
	component = M.get_component(component)
	return component and component.attributes
end

function M.get_component_assets(component)
	component = M.get_component(component)
	return component and component.assets
end

----------- ATTRIBUTES -------------

function M.get_attributes()
	local attributes = M.dialogue_data and M.dialogue_data.attributes
	if not attributes then
		verbose_print("No attributes in the project")
	end
	return attributes
end

function M.get_attributes_names()
	local attributes = {}
	local data = M.get_attributes()
	for id, attribute in pairs(data) do
		attributes[id] = attribute.name
	end
	return attributes
end

function M.get_attribute_by_id(id)
	local attr = M.get_attributes()
	return attr and attr[id]
end

function M.get_attribute_by_name(name)
	for id,attribute in pairs(M.dialogue_data.attributes) do
		if attribute.name == name then
			return attribute
		end
	end
	return nil
end

function M.get_attribute(attribute)
	if attribute then
		if type(attribute) == "string" then
			local attribute_by_name = M.get_attribute_by_name(attribute)
			if attribute_by_name then
				return attribute_by_name
			else
				return M.get_attribute_by_id(attribute)
			end
		else
			return attribute
		end
	else
		return M.attribute_selected
	end
end

function M.select_attribute_by_id(id)
	M.attribute_selected = M.get_attribute_by_id(id)
end

function M.select_attribute_by_name(name)
	M.attribute_selected = M.get_attribute_by_name(name)
end

function M.select_attribute(attribute)
	M.attribute_selected = M.get_attribute(attribute)
end

----------- ATTRIBUTES CONTENTS -------------

function M.get_attribute_name(attribute)
	local attribute = M.get_attribute(attribute)
	return attribute and attribute.name
end

function M.get_attribute_value(attribute)
	local attribute = M.get_attribute(attribute)
	return attribute and attribute.value
end

function M.get_attribute_data(attribute)
	local attribute = M.get_attribute(attribute)
	return attribute and attribute.value and attribute.value.data
end

function M.get_attribute_type(attribute)
	local attribute = M.get_attribute(attribute)
	return attribute and attribute.value and attribute.value.type
end

----------- GLOBAL ASSETS -------------

function M.get_assets()
	local assets = M.dialogue_data and M.dialogue_data.assets
	if not assets then
		verbose_print("No assets in the project")
	end
	return assets
end

function M.get_assets_names()
	local assets = {}
	local data = M.get_assets()
	for id, asset in pairs(data) do
		assets[id] = asset.name
	end
	return assets
end

function M.get_asset_by_id(id)
	local asset = M.get_assets()
	return asset and asset[id]
end

function M.get_asset_by_name(name)
	local data = M.dialogue_data.assets
	for _, asset in pairs(data) do
		if asset.name == name then
			return asset
		end
	end
	return nil
end

function M.get_asset(asset)
	if asset then
		if type(asset) == "string" then
			local asset_by_id = M.get_asset_by_id(asset)
			if asset_by_id then
				return asset_by_id
			else
				return M.get_asset_by_name(asset)
			end
		else
			return asset
		end
	else
		return M.asset_selected
	end
end

function M.select_asset_by_id(id)
	M.asset_selected = M.get_asset_by_id(id)
end

function M.select_asset_by_name(name)
	M.asset_selected = M.get_asset_by_name(name)
end

function M.select_asset(asset)
	M.asset_selected = M.get_asset(asset)
end

function M.get_asset_name(asset)
	local asset = M.get_asset(asset)
	return asset and asset.name
end

function M.get_asset_type(asset)
	local asset = M.get_asset(asset)
	return asset and asset.type
end

function M.get_asset_children(asset)
	local asset = M.get_asset(asset)
	return asset and asset.children
end

----------- GLOBAL VARIABLES -------------

M.global_variables = {}

function M.get_variables()
	local variables = M.dialogue_data and M.dialogue_data.variables
	if not variables then
		verbose_print("No variables in the project")
	end
	return variables
end

function M.get_variables_names()
	local variables = {}
	local data = M.get_variables()
	for id,variable in pairs(data) do
		variables[id] = variable.name
	end
	return variables
end

function M.get_variable_by_id(id)
	local var = M.get_variables()
	return var and var[id]
end

function M.get_variable_by_name(name)
	for id,variable in pairs(M.dialogue_data.variables) do
		if variable.name == name then
			return variable
		end
	end
	return nil
end

function M.get_variable(variable)
	if variable then
		if type(variable) == "string" then
			local variable_by_id = M.get_variable_by_id(variable)
			if variable_by_id then
				return variable_by_id
			else
				return M.get_variable_by_name(variable)
			end
		else
			return variable
		end
	else
		return M.variable_selected
	end
end

function M.select_variable_by_id(id)
	M.variable_selected = M.get_variable_by_id(id)
end

function M.select_variable_by_name(name)
	M.variable_selected = M.get_variable_by_name(name)
end

function M.select_variable(variable)
	M.variable_selected = M.get_variable(variable)
end

function M.get_variable_name(variable)
	local variable = M.get_variable(variable)
	return variable and variable.name
end

function M.get_variable_type(variable)
	local variable = M.get_variable(variable)
	return variable and variable.type
end

function M.get_variable_value(variable)
	local variable = M.get_variable(variable)
	return variable and variable.value
end

function M.save_variable(variable_name, new_value)
	local variable_table = M.get_variable(variable_name)
	if variable_table then
		local variable_table_name = variable_table.name
		local variable_table_value = variable_table.value
		local variable_table_type = variable_table.type
		local type_new_value = type(new_value)
		if variable_table_type == "boolean" then
			if new_value then
				if type_new_value == "string" then
					M.global_variables[variable_table_name] = (new_value == "true")
				elseif type_new_value == "number" then
					M.global_variables[variable_table_name] = (new_value == 1)
				elseif type_new_value == "boolean" then
					M.global_variables[variable_table_name] = new_value
				else
					verbose_print("Error assigning unsupported type value to a boolean variable.")
					return false
				end
			else
				M.global_variables[variable_table_name] = (variable_table_value == "true")
			end
		elseif variable_table_type == "string" then
			if new_value then
				if type_new_value == "boolean" then
					M.global_variables[variable_table_name] = new_value and "true" or "false"
				elseif type_new_value == "number" then
					M.global_variables[variable_table_name] = tostring(new_value)
				elseif type_new_value == "string" then
					M.global_variables[variable_table_name] = new_value
				else
					verbose_print("Error assigning unsupported type value to a string variable.")
					return false
				end
			else
				M.global_variables[variable_table_name] = tostring(variable_table_value)
			end
		elseif (variable_table_type == "integer") or (variable_table_type == "float") then
			if new_value then
				if type_new_value == "boolean" then
					M.global_variables[variable_table_name] = (new_value == 1)
				elseif type_new_value == "number" then
					M.global_variables[variable_table_name] = new_value
				elseif type_new_value == "string" then
					local tonumber_string = tonumber(new_value)
					if tonumber_string then
						M.global_variables[variable_table_name] = tonumber_string
					else
						verbose_print("Error converting string type value to a number variable.")
						return false
					end
				else
					verbose_print("Error assigning unsupported type value to a number variable.")
					return false
				end
			else
				M.global_variables[variable_table_name] = tonumber(variable_table_value)
			end
		else
			verbose_print("New, unsupported ArcWeave variable type. Please, report it.")
			return false
		end
		return true
	end
	verbose_print("Error saving value. No variables table in the project.")
	return false
end

function M.load_variable(variable_name)
	local vars = M.global_variables
	return vars and vars[variable_name]
end

----------- JUMPERS ------------------

function M.get_jumpers()
	local jumpers = M.dialogue_data and M.dialogue_data.jumpers
	if not jumpers then
		verbose_print("No jumpers in the project")
	end
	return jumpers
end

function M.get_jumpers_elements_id()
	local jumpers = {}
	local data = M.get_jumpers()
	for id,jumper in pairs(data) do
		jumpers[id] = jumper.elementId
	end
	return jumpers
end

function M.get_jumper_by_id(id)
	local jumpers = M.get_jumpers()
	return jumpers and jumpers[id]
end

function M.get_jumper_by_element_id(element_id)
	local data = M.dialogue_data.jumpers
	for _,jumper in pairs(data) do
		if jumper.elementId == element_id then
			return jumper
		end
	end
	return nil
end

function M.get_jumper(jumper)
	if jumper then
		if type(jumper) == "string" then
			local jumper_by_element_id = M.get_jumper_by_element_id(jumper)
			if jumper_by_element_id then
				return jumper_by_element_id
			else
				return M.get_jumper_by_id(jumper)
			end
		else
			return jumper
		end
	else
		return M.jumper_selected
	end
end

function M.select_jumper_by_id(id)
	M.jumper_selected = M.get_jumper_by_id(id)
end

function M.select_jumper_by_element_id(element_id)
	M.jumper_selected = M.get_jumper_by_element_id(element_id)
end

function M.select_jumper(jumper)
	M.jumper_selected = M.get_jumper(jumper)
end

function M.get_jumper_element_id(jumper)
	local jumper = M.get_jumper(jumper)
	return jumper and jumper.elementId or (M.jumper_selected and M.jumper_selected.elementId)
end

----------- GLOBAL BRANCHES -------------

function M.get_branches()
	local branches = M.dialogue_data and M.dialogue_data.branches
	if not branches then
		verbose_print("No branches in the project")
	end
	return branches
end

function M.get_branch_by_id(id)
	local branches = M.get_branches()
	return branches and branches[id]
end

function M.get_branch(id)
	local branches = M.get_branches()
	return (id and branches) and branches[id] or M.branch_selected
end

function M.select_branch_by_id(id)
	M.branch_selected = M.get_branch_by_id(id)
end

function M.select_branch(id)
	M.branch_selected = M.get_branch_by_id(id)
end

function M.get_branch_theme(id)
	local branch = M.get_branch(id)
	return branch and branch.theme
end

function M.get_branch_conditions(id)
	local branch = M.get_branch(id)
	return branch and branch.conditions
end

function M.get_branch_if_condition(id)
	local branch_conditions = M.get_branch_conditions(id)
	return branch_conditions and branch_conditions.ifCondition
end

function M.get_branch_elseif_conditions(id)
	local branch_conditions = M.get_branch_conditions(id)
	return branch_conditions and branch_conditions.elseIfConditions
end

function M.get_branch_else_condition(id)
	local branch_conditions = M.get_branch_conditions(id)
	return branch_conditions and branch_conditions.elseCondition
end

----------- STRING HELPER FUNCTIONS -------------

function M.split(inputstr, sep, alt_sep)
	local t = {}
	local i = 1
	if inputstr and sep then
		for str in string_gmatch(inputstr, "([^"..sep.."]+)") do
			if alt_sep then
				for alt_str in string_gmatch(str, "([^"..alt_sep.."]+)") do
					t[i] = alt_str
					i = i + 1
				end
			else
				t[i] = str
				i = i + 1
			end
		end
	end
	return t
end

function M.substr_start_end(inputstr, start_offset, end_offset)
	start_offset = start_offset or 0
	end_offset = end_offset or 0
	return inputstr and string_sub(inputstr, 1 + start_offset, string_len(inputstr)-end_offset) or nil
end

function M.strip_p_tags(word)
	local result = {}
	local found_index = 0
	local start_index = 0
	while true do
		found_index = string_find(word, "<?p*>", found_index + 1)    -- find 'next' newline
		if found_index == nil then
			break
			--else
			--	found_index = found_index + 1
		end
		table_insert(result, string_sub(word, start_index, found_index))
		start_index = found_index
	end
	return result
end

local function trim_p_tags(word)					-- TODO: this is a really basic function and should be more smart
	if word == "" then return "" end
	local left_trim = string_find(word, ">")
	if not left_trim then return word end
	return M.substr_start_end(word, left_trim or 3, 4)
end

function M.replace_marks(word, marks, replacement)
	return word:gsub(marks, replacement)
end

local function string_is_operator(str)
	return string_find(str, "=") or string_find(str, "<") or string_find(str, ">")
end


----------- GLOBAL CONDITIONS -------------

function M.get_conditions()
	local conditions = M.dialogue_data and M.dialogue_data.conditions
	if not conditions then
		verbose_print("No conditions in the project")
	end
	return conditions
end

function M.get_condition_by_id(condition_id)
	local conditions = M.get_conditions()
	return conditions and conditions[condition_id]
end

function M.get_condition(condition)
	if type(condition) == "string" then
		return condition and M.get_condition_by_id(condition) or M.condition_selected
	else
		return condition or M.condition_selected
	end
end

function M.select_condition_by_id(condition_id)
	M.condition_selected = M.get_condition_by_id(condition_id)
end

function M.select_condition(condition)
	M.condition_selected = M.get_condition(condition)
end

function M.get_condition_output(condition_id)
	local condition = M.get_condition(condition_id)
	return condition and condition.output
end

function M.get_condition_script(condition_id)
	local condition = M.get_condition(condition_id)
	return condition and condition.script
end

function M.parse_variable_value(variable)
	if variable then
		local variable_name = variable.name
		if variable_name then
			local saved_variable = M.load_variable(variable_name)
			if not saved_variable then
				M.save_variable(variable)
				saved_variable = M.load_variable(variable_name)
			end
			return tostring(saved_variable)
		end
		verbose_print("Could not parse variable. Variable has no name.")
		return false
	end
	verbose_print("Could not parse variable. No variable given.")
	return false
end

local function divide_code_condition_into_elements(condition)
	-- divide code condition into separate elements, e.g. variable == 1, will be splitted into table {2, "==", 1} (variable is parsed and its value is loaded (2)
	local elements = M.split(condition, "%s")
	condition = ""
	local length = #elements


	-- check for assignments - if there is an assignment, just save variable and quit with such info
	if elements[2] == "=" then
		M.save_variable(elements[1], elements[3])	-- TODO add parsing advanced RHS operations e.g. 1+2, rand(1), etc
		return VARIABLE_SAVED
	end

	-- parse variable names to their real value assigned / saved
	for i = 1, length do
		local element = elements[i]
		local variable = M.get_variable_by_name(element)
		if variable then
			elements[i] = M.parse_variable_value(variable)
		else
			condition = condition .. element
			elements[i] = tostring(element)
		end
	end

	local elseifs_count = 1

	-- check for if,elseifs,else
	for i = 1, length do
		local curr_el = elements[i]
		if (curr_el == "if")
		or (curr_el == "elseif")
		or (curr_el == "else") then
			local if_elseif_or_else = curr_el .. "_" -- add "_" at the end to distinguish from key words if, elseif, else (will be if_, elseif_, else_)
			local the_condition = ""

			for j = i+1, length do
				the_condition = the_condition .. elements[j]	-- parse everything after if, elseif or else
			end

			the_condition = string.gsub(the_condition, "(&gt;)", ">")	-- replace HTML tags for comparison operators
			the_condition = string.gsub(the_condition, "(&lt;)", "<")
			the_condition = string.gsub(the_condition, "(&le;)", "<=")
			the_condition = string.gsub(the_condition, "(&ge;)", ">=")

			if the_condition == "" then
				the_condition = "true"
			end

			the_condition = parse_test_string(the_condition or "true")	-- parse condition to its actual resulting value (e.g. 1 > 2 will result false)

			if the_condition then
				elements = {}
				if if_elseif_or_else == "elseif_" then
					if_elseif_or_else = if_elseif_or_else .. tostring(elseifs_count)	-- fill resulting table with elements
					elements["elseifs_count"] = elseifs_count							-- if there are elseifs add aditional field with elseifs counts, as there could be multiple
					elseifs_count = elseifs_count + 1
				end
				elements[if_elseif_or_else] = the_condition
				break;
			end
		end
	end

	-- Check if there is string comparison, if so, add quotes to values being compared
	if type(elements) ~= "boolean" then
		for i = 1, length do
			local element = elements[i]
			if type(element) == "string" and string_find(element,'"') then
				for j = 1, length do
					if (not string_is_operator(elements[j])) and (not string_find(elements[j],'"')) then
						elements[j] = '"'..tostring(elements[j])..'"'
					end
				end
				break
			end
		end
	end

	return elements
end

local function join_code_condition_elements(elements)
	local length = #elements
	local test_string = ""

	for i = 1, length do
		if type(elements[i]) == "boolean" then							-- check for booleans in elements - parsed if,elseif,else conditions
			test_string = test_string .. (elements[i] and elements[i+1] or "") -- add next element if previous element was true
			i = i + 1
		else
			test_string = test_string .. elements[i]
		end
	end
	return test_string
end

local function parse_test_string(test_string)
	test_string = "return ( true == (" .. test_string .. ") )"

	if ( load(test_string)() ) then
		return true
	else
		return false
	end
end

function M.check_condition(condition_id)
	local condition = M.get_condition_script(condition_id)
	local elements = divide_code_condition_into_elements(condition)
	local test_string = join_code_condition_elements(elements)
	return parse_test_string(test_string)
end

----------- GLOBAL STARTING ELEMENT -------------

function M.get_starting_element_id()
	return M.dialogue_data and M.dialogue_data.startingElement
end

function M.get_starting_element()
	local elements = M.dialogue_data and M.dialogue_data.elements
	return elements and elements[M.get_starting_element_id()]
end

----------- ELEMENTS -------------

function M.get_elements()
	local elements = M.dialogue_data and M.dialogue_data.elements
	if not elements then
		verbose_print("No elements in the project")
	end
	return elements
end

function M.get_elements_titles()
	local elements = {}
	local data = M.get_elements()
	if data then
		for id,element in pairs(data) do
			elements[id] = M.substr_start_end(element.title, 3, 4) -- cut off <p> and </p>
		end
	end
	return elements
end

function M.get_element_by_id(id)
	local elements = M.get_elements()
	return elements and elements[id]
end

function M.get_element_by_title(title)
	local data = M.get_elements()
	if data then
		for _,element in pairs(data) do
			if element.title and (trim_p_tags(element.title) == title) then
				return element
			end
		end
	end
	return nil
end

function M.get_element(element)
	if element then
		if type(element) == "string" then
			local element_by_id = M.get_element_by_id(element)
			if element_by_id then
				return element_by_id
			else
				return M.get_element_by_title(element)
			end
		else
			return element
		end
	else
		return M.element_selected
	end
end

function M.select_element_by_id(id)
	M.element_selected = M.get_element_by_id(id)
end

function M.select_element_by_title(title)
	M.element_selected = M.get_element_by_title(title)
end

function M.select_element(element)
	M.element_selected = M.get_element(element)
end

----------- ELEMENT CONTENTS -------------

function M.get_element_title(element)
	element = M.get_element(element)
	return trim_p_tags(element and element.title or "") -- cut off <p> and </p>
end

function M.get_element_theme(element)
	element = M.get_element(element)
	return element and element.theme
end

function M.get_element_content(element)
	element = M.get_element(element)
	return trim_p_tags(element and element.content or "") -- cut off <p> and </p>
end

function M.get_element_outputs(element)
	element = M.get_element(element)
	return element and element.outputs
end

function M.get_element_assets(element)
	element = M.get_element(element)
	return element and element.assets
end

function M.get_element_components(element)
	element = M.get_element(element)
	return element and element.components
end

function M.get_element_linked_board(element)
	element = M.get_element(element)
	return element and element.linked_board
end

----------- CONNECTIONS -------------

function M.get_connections()
	local connections = M.dialogue_data and M.dialogue_data.connections
	if not connections then
		verbose_print("No connections in the project")
	end
	return connections
end

function M.get_connections_for_source_id(source_id)
	local connections = {}
	local data = M.get_connections()
	for id,connection in pairs(data) do
		if connection.sourceid == source_id then
			connections[id] = connection
		end
	end
	return connections
end

function M.get_connection_by_id(connection_id)
	local connections = M.get_connections()
	return connections and connections[connection_id]
end

function M.get_connection(connection_id)
	local connections = M.get_connections()
	return connection_id and (connections and connections[connection_id]) or M.connection_selected
end

function M.select_connection_by_id(connection_id)
	M.connection_selected = M.get_connection(connection_id)
end

function M.select_connection(connection_id)
	M.connection_selected = M.get_connection(connection_id)
end

----------- CONNECTION CONTENTS -------------

function M.get_connection_type(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.type
end

function M.get_connection_label(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.label and trim_p_tags(connection.label) or ""-- cut off <p> and </p>
end

function M.get_connection_theme(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.theme
end

function M.get_connection_source_id(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.sourceid
end

function M.get_connection_target_id(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.targetid
end

function M.get_connection_source_type(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.sourceType
end

function M.get_connection_target_type(connection_id)
	local connection = M.get_connection(connection_id)
	return connection and connection.targetType
end

----------- CODE BITS -------------

local function get_passing_code_option(lines)	-- todo:remove if not needed
	local branch_id = M.get_connection_target_id()
	--local conditions = M.get_branch_conditions(branch_id)

	-- IF
	local checking_condition = M.get_branch_if_condition(branch_id)
	if checking_condition and M.check_condition(checking_condition) then
		return M.get_condition_output(checking_condition)
	end

	-- ELSEIFs
	checking_condition = M.get_branch_elseif_conditions(branch_id)
	if checking_condition then
		for i,condition in pairs(checking_condition) do
			if M.check_condition(condition) then
				return M.get_condition_output(condition)
			end
		end
	end

	-- ELSE
	return M.get_condition_output(M.get_branch_else_condition(branch_id))
end

local function arcscript_if_parser(splitted, start_at)
	-- first line is a <code> tag, next is the actual if_statement
	local if_statement = splitted[start_at + 1]
	local if_statement_len = string_len(if_statement)

	-- cut "if " out from the beginning, to operate only on statement's variable
	local statement_var = string_sub(if_statement, 3, if_statement_len)

	-- save a negation flag, if there is a "!" arcscript operator used
	local negation = false
	if string_find(statement_var, "!") then
		-- then cut "!" out of the string to get only name of variable
		statement_var = string_sub(statement_var, 3, if_statement_len)
		negation = true
	end

	-- save the variable in global Lua variables, if it was not already saved
	if M.load_variable(statement_var) == nil then
		M.save_variable(statement_var, M.get_variable_value(statement_var))
	end

	-- load the value of the variable and apply negation flag back to he result
	local result = M.load_variable(statement_var)
	if result == nil then result = false end
	if negation then
		result = not result
	end

	-- clear the tags
	splitted[start_at] = ""			-- remove code opening tag <code>
	splitted[start_at + 1] = ""		-- remove if tag and line  "if ..."
	splitted[start_at + 2] = ""		-- remove code closing tag </code>

	-- if if-condition is not met, remove the lines until next "code" tag, otherwise leave it
	local k = 0
	if not result then
		while (splitted[start_at + k] ~= "code") do
			splitted[start_at + k] = ""
			k = k + 1
		end
	end

	-- clear the closing tags
	if splitted[start_at + 3] == "/code" then
		splitted[start_at + 3] = ""
	end
end

local function arcscript_assingment_parser(splitted, start_at)
	-- split the assingment line
	local splitted_assingment = M.split(splitted[start_at + 1], " = ")
	local var = splitted_assingment[1]
	local val = splitted_assingment[2]

	-- save the variable's value to internal global Lua variables
	M.save_variable(var, val)

	-- clear the tags
	splitted[start_at] = ""			-- remove code opening tag
	splitted[start_at + 1] = ""		-- remove assignment line
	splitted[start_at + 2] = ""		-- remove code closing tag
end

function M.arcscript_code_parser(splitted, start_at)
	local next = splitted[start_at + 1]
	local next_len = string_len(next)

	if string_find(next, "elseif") then
		next = string_sub(next, 7, next_len)

	elseif string_find(next, "endif") then
		splitted[start_at] = ""			-- remove code opening tag
		splitted[start_at + 1] = ""		-- remove endif tag
		splitted[start_at + 2] = ""		-- remove code closing tag

	elseif string_find(next, "if") then	arcscript_if_parser(splitted, start_at)
	elseif string_find(next, "= ") then	arcscript_assingment_parser(splitted, start_at)
	end
end

----------- CONVERSATION FLOW -------------

function M.get_text(element)
	local content = M.get_element(element).content
	local result = parser.parse_element_content(content, M)
	return result
end

local function get_passing_branching_option(connection_id)
	local branch_id = M.get_connection_target_id(connection_id)

	-- IF
	local checking_condition = M.get_branch_if_condition(branch_id)
	if checking_condition and M.check_condition(checking_condition) then
		return M.get_condition_output(checking_condition)
	end

	-- ELSEIFs
	checking_condition = M.get_branch_elseif_conditions(branch_id)
	if checking_condition then
		for i,condition in pairs(checking_condition) do
			if M.check_condition(condition) then
				return M.get_condition_output(condition)
			end
		end
	end

	-- ELSE
	return M.get_condition_output(M.get_branch_else_condition(branch_id))
end

function M.get_options_table(element)
	local options = {}
	for i,output_connection in pairs(M.get_element_outputs(element)) do
		local target_id = M.get_connection_target_id(output_connection)
		if M.get_connection_target_type(output_connection) == "branches" then
			output_connection = get_passing_branching_option(output_connection)
			target_id = M.get_connection_target_id(output_connection)
		end
		local label_unparsed = M.get_connection_label(output_connection)
		local label_parsed = parser.parse_element_content(label_unparsed, M)
		options[i] = { target_id = target_id,
			label = label_parsed,
			theme = M.get_connection_theme(output_connection),
			target_type = M.get_connection_target_type(output_connection)}
	end
	return options
end

M.displaying_image_component_cb = function(image_name)
end

return M



