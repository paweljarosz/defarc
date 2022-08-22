local M = {}

-- DefArc - is an asset that allows Defold and Lua users to easily game narrative, that utilizes ArcWeave.
-- ArcWeave is an enhanced, free, online tool helping design games narratives, linear or non-linear, branching, interactive conversations.
-- DefArc is an incarnation or inheritance from original module I made - DeFork - a tool that parses Twine created JSONs.
-- Below code is written by Pawel Jarosz. Feel free to use it any way you want it as long as you include the original copyright
-- and license notice in any copy of the software/source. (MIT full license: https://opensource.org/licenses/MIT)

-------------------------------------------  [ DefArc ] -----------------------------------------------

--localise globals
local require, assert, sys, json, pairs, type = require, assert, sys, json, pairs, type
local tonumber, tostring, string, table, load = tonumber, tostring, string, table, load
local string_gmatch, string_find, string_len, string_sub = string.gmatch, string.find, string.len, string.sub
local table_insert = table.insert

local parser = require "defarc.parser"

M.dialog_data = {}
local VARIABLE_SAVED = "variable_saved"

function M.load(resource)
	assert(resource, "DefArc: Error: No resource given")
	local data = sys.load_resource(resource)
	M.dialog_data = json.decode(data)
	if not M.dialog_data then
		print("DefArc:","Error: Could not load data")
	end
	return M.dialog_data
end

function M.create(resource)
	local instance = {}
	instance.dialog_data = M.load(resource)
	return setmetatable(instance, { __index = M })
end

function M.get_project_name()
	return M.dialog_data.name
end

function M.get_project_cover()
	return M.dialog_data.cover
end

----------- BOARDS -------------

function M.get_boards()
	assert(M.dialog_data.boards, "DefArc: No boards in the project")
	return M.dialog_data.boards
end

function M.get_boards_names()
	local names = {}
	for id,board in pairs(M.get_boards()) do
		names[id] = board.name
	end
	return names
end

function M.get_board_by_id(board_id)
	return M.get_boards()[board_id]
end

function M.get_board_by_name(name)
	for id,board in pairs(M.dialog_data.boards) do
		if board.name == name then
			return board
		end
	end
	return nil
end

function M.get_board(board)
	if board then
		if type(board) == "string" then
			local board_by_name = M.get_board_by_name(board)
			if board_by_name then
				return board_by_name
			else
				return M.get_board_by_id(board)
			end
		else
			return board
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
	assert(board, "DefArc: No such board")
	return board.name
end

----------- BOARD CONTENTS -------------

function M.get_notes(board)
	local notes = {}
	board = M.get_board(board)
	assert(M.dialog_data.notes, "DefArc: No notes in the board")
	for id,note in pairs(M.dialog_data.notes) do
		notes[id] = note
	end
	return notes
end

function M.get_board_jumpers(board)
	local jumpers = {}
	board = M.get_board(board)
	assert(M.dialog_data.jumpers, "DefArc: No jumpers in the board")
	for id,jumper in pairs(M.dialog_data.jumpers) do
		jumpers[id] = jumper.elementId
	end
	return jumpers
end

function M.get_board_branches(board)
	local branches = {}
	board = M.get_board(board)
	assert(M.dialog_data.branches, "DefArc: No branches in the board")
	for id,branch in pairs(M.dialog_data.branches) do
		branches[id] = branch
	end
	return branches
end

function M.get_board_elements(board)
	local elements = {}
	board = M.get_board(board)
	assert(M.dialog_data.elements, "DefArc: No elements in the board")
	for id,element in pairs(M.dialog_data.elements) do
		elements[id] = element
	end
	return elements
end

function M.get_board_connections(board)
	local connections = {}
	board = M.get_board(board)
	assert(M.dialog_data.connections, "DefArc: No connections in the board")
	for id,connection in pairs(M.dialog_data.connections) do
		connections[id] = connection
	end
	return connections
end

----------- COMPONENTS -------------

function M.get_components()
	assert(M.dialog_data.components, "DefArc: No components in the project")
	return M.dialog_data.components
end

function M.get_components_names()
	assert(M.dialog_data.components, "DefArc: No components in the project")
	local components = {}
	for id,component in pairs(M.get_components()) do
		components[id] = component.name
	end
	return components
end

function M.get_component_by_id(id)
	return M.get_components()[id]
end

function M.get_component_by_name(name)
	for id,component in pairs(M.dialog_data.components) do
		if component.name == name then
			return component
		end
	end
	return nil
end

function M.get_component(component)
	if component then
		if type(component) == "string" then
			local component_by_name = M.get_component_by_name(component)
			if component_by_name then
				return component_by_name
			else
				return M.get_component_by_id(component)
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
	assert(component and component.attributes, "DefArc: No attributes for given component")
	return component and component.attributes
end

function M.get_component_assets(component)
	component = M.get_component(component)
	assert(component and component.assets, "DefArc: No assets for given component")
	return component and component.assets
end

----------- ATTRIBUTES -------------

function M.get_attributes()
	assert(M.dialog_data.attributes, "DefArc: No attributes in the project")
	return M.dialog_data.attributes
end

function M.get_attributes_names()
	local attributes = {}
	for id,attribute in pairs(M.get_attributes()) do
		attributes[id] = attribute.name
	end
	return attributes
end

function M.get_attribute_by_id(id)
	return M.get_attributes()[id]
end

function M.get_attribute_by_name(name)
	for id,attribute in pairs(M.dialog_data.attributes) do
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
	return M.get_attribute(attribute).name
end

function M.get_attribute_value(attribute)
	return M.get_attribute(attribute).value
end

function M.get_attribute_data(attribute)
	return M.get_attribute(attribute).value.data
end

function M.get_attribute_type(attribute)
	return M.get_attribute(attribute).value.type
end

----------- GLOBAL ASSETS -------------

function M.get_assets()
	assert(M.dialog_data.assets, "DefArc: No assets in the project")
	return M.dialog_data.assets
end

function M.get_assets_names()
	local assets = {}
	for id,asset in pairs(M.get_assets()) do
		assets[id] = asset.name
	end
	return assets
end

function M.get_asset_by_id(id)
	return M.get_assets()[id]
end

function M.get_asset_by_name(name)
	for id,asset in pairs(M.dialog_data.assets) do
		if asset.name == name then
			return asset
		end
	end
	return nil
end

function M.get_asset(asset)
	if asset then
		if type(asset) == "string" then
			local asset_by_name = M.get_asset_by_name(asset)
			if asset_by_name then
				return asset_by_name
			else
				return M.get_asset_by_id(asset)
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
	return M.get_asset(asset).name
end

function M.get_asset_type(asset)
	return M.get_asset(asset).type
end

function M.get_asset_children(asset)
	return M.get_asset(asset).children
end

----------- GLOBAL VARIABLES -------------

M.global_variables = {}

function M.get_variables()
	assert(M.dialog_data.variables, "DefArc: No variables in the project")
	return M.dialog_data.variables
end

function M.get_variables_names()
	local variables = {}
	for id,variable in pairs(M.get_variables()) do
		variables[id] = variable.name
	end
	return variables
end

function M.get_variable_by_id(id)
	return M.get_variables()[id]
end

function M.get_variable_by_name(name)
	for id,variable in pairs(M.dialog_data.variables) do
		if variable.name == name then
			return variable
		end
	end
	return nil
end

function M.get_variable(variable)
	if variable then
		if type(variable) == "string" then
			local variable_by_name = M.get_variable_by_name(variable)
			if variable_by_name then
				return variable_by_name
			else
				return M.get_variable_by_id(variable)
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
	return M.get_variable(variable).name
end

function M.get_variable_type(variable)
	return M.get_variable(variable).type
end

function M.get_variable_value(variable)
	return M.get_variable(variable).value
end

function M.save_variable(variable_name, new_value)
	local variable_table = M.get_variable(variable_name)
	if variable_table then
		if variable_table.type == "boolean" then
			if new_value then
				if type(new_value) == "string" then
					M.global_variables[variable_table.name] = (new_value == "true")
				elseif type(new_value) == "number" then
					M.global_variables[variable_table.name] = (new_value == 1)
				else
					M.global_variables[variable_table.name] = new_value
				end
			else
				M.global_variables[variable_table.name] = (variable_table.value == "true")
			end
		elseif variable_table.type == "string" then
			if new_value then
				if type(new_value) == "boolean" then
					M.global_variables[variable_table.name] = new_value and "true" or "false"
				else
					M.global_variables[variable_table.name] = tostring(new_value)
				end
			else
				M.global_variables[variable_table.name] = variable_table.value
			end
		else
			if new_value then
				if type(new_value) == "boolean" then
					M.global_variables[variable_table.name] = (new_value == 1)
				else
					M.global_variables[variable_table.name] = tonumber(new_value)
				end
			else
				M.global_variables[variable_table.name] = tonumber(variable_table.value)
			end
		end
		return true
	end
	return false
end

function M.load_variable(variable_name)
	return M.global_variables[variable_name]
end

----------- JUMPERS ------------------

function M.get_jumpers()
	assert(M.dialog_data.jumpers, "DefArc: No jumpers in the project")
	return M.dialog_data.jumpers
end

function M.get_jumpers_elements_id()
	local jumpers = {}
	for id,jumper in pairs(M.get_jumpers()) do
		jumpers[id] = jumper.elementId
	end
	return jumpers
end

function M.get_jumper_by_id(id)
	return M.get_jumpers()[id]
end

function M.get_jumper_by_element_id(element_id)
	for id,jumper in pairs(M.dialog_data.jumpers) do
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
	return M.get_jumper(jumper).elementId
end

----------- GLOBAL BRANCHES -------------

function M.get_branches()
	assert(M.dialog_data.branches, "DefArc: No branches in the project")
	return M.dialog_data.branches
end

function M.get_branch_by_id(id)
	return M.get_branches()[id]
end

function M.get_branch(id)
	return id and M.get_branches()[id] or M.branch_selected
end

function M.select_branch_by_id(id)
	M.branch_selected = M.get_branch_by_id(id)
end

function M.select_branch(id)
	M.branch_selected = M.get_branch_by_id(id)
end

function M.get_branch_theme(id)
	return M.get_branch(id).theme
end

function M.get_branch_conditions(id)
	return M.get_branch(id).conditions
end

function M.get_branch_if_condition(id)
	return M.get_branch_conditions(id).ifCondition
end

function M.get_branch_elseif_conditions(id)
	return M.get_branch_conditions(id).elseIfConditions
end

function M.get_branch_else_condition(id)
	return M.get_branch_conditions(id).elseCondition
end

----------- STRING HELPER FUNCTIONS -------------

function M.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local i = 1
	for str in string_gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function M.substr_start_end(inputstr, start_offset, end_offset)
	return string_sub(inputstr, 1+start_offset, string_len(inputstr)-end_offset)
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
	assert(M.dialog_data.conditions, "DefArc: No conditions in the project")
	return M.dialog_data.conditions
end

function M.get_condition_by_id(condition_id)
	return M.get_conditions()[condition_id]
end

function M.get_condition(condition_id)
	return condition_id and M.get_conditions()[condition_id] or M.condition_selected
end

function M.select_condition_by_id(condition_id)
	M.condition_selected = M.get_condition_by_id(condition_id)
end

function M.select_condition(condition_id)
	M.condition_selected = M.get_condition_by_id(condition_id)
end

function M.get_condition_output(condition_id)
	return M.get_condition(condition_id).output
end

function M.get_condition_script(condition_id)
	return M.get_condition(condition_id).script
end

function M.parse_variable_value(variable)
	local saved_variable = M.load_variable(variable.name)
	if not saved_variable then
		M.save_variable(variable)
		saved_variable = M.load_variable(variable.name)
	end
	return tostring(saved_variable)
end

local function divide_code_condition_into_elements(condition)
	-- divide code condition into separate elements, e.g. variable == 1, will be splitted into table {2, "==", 1} (variable is parsed and its value is loaded (2)
	local elements = M.split(condition)
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
	return M.dialog_data.startingElement
end

function M.get_starting_element()
	return M.dialog_data.elements[M.dialog_data.startingElement]
end

----------- ELEMENTS -------------

function M.get_elements()
	assert(M.dialog_data.elements, "DefArc: No elements in the project")
	return M.dialog_data.elements
end

function M.get_elements_titles()
	assert(M.dialog_data.elements, "DefArc: No elements in the project")
	local elements = {}
	for id,element in pairs(M.get_elements()) do
		elements[id] = M.substr_start_end(element.title, 3, 4) -- cut off <p> and </p>
	end
	return elements
end

function M.get_element_by_id(id)
	return M.get_elements()[id]
end

function M.get_element_by_title(title)
	for id,element in pairs(M.dialog_data.elements) do
		if trim_p_tags(element.title) == title then
			return element
		end
	end
	return nil
end

function M.get_element(element)
	if element then
		if type(element) == "string" then
			local element_by_name = M.get_element_by_title(element)
			if element_by_name then
				return element_by_name
			else
				return M.get_element_by_id(element)
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
	return trim_p_tags(element and element.content) -- cut off <p> and </p>
end

function M.get_element_outputs(element)
	element = M.get_element(element)
	return element and element.outputs
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
	assert(M.dialog_data.connections, "DefArc: No connections in the project")
	return M.dialog_data.connections
end

function M.get_connections_for_source_id(source_id)
	local connections = {}
	for id,connection in pairs(M.get_connections()) do
		if connection.sourceid == source_id then
			connections[id] = connection
		end
	end
	return connections
end

function M.get_connection_by_id(connection_id)
	return M.get_connections()[connection_id]
end

function M.get_connection(connection_id)
	return connection_id and M.get_connections()[connection_id] or M.connection_selected
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
	return connection.type
end

function M.get_connection_label(connection_id)
	local connection = M.get_connection(connection_id)
	return connection.label and trim_p_tags(connection.label) or ""-- cut off <p> and </p>
end

function M.get_connection_theme(connection_id)
	local connection = M.get_connection(connection_id)
	return connection.theme
end

function M.get_connection_source_id(connection_id)
	local connection = M.get_connection(connection_id)
	return connection.sourceid
end

function M.get_connection_target_id(connection_id)
	local connection = M.get_connection(connection_id)
	return connection.targetid
end

function M.get_connection_source_type(connection_id)
	local connection = M.get_connection(connection_id)
	return connection.sourceType
end

function M.get_connection_target_type(connection_id)
	local connection = M.get_connection(connection_id)
	return connection.targetType
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
	local result = parser.parse_element_content(content, M.arcscript_code_parser)
	return result
end

local function get_passing_branching_option(connection_id)
	local branch_id = M.get_connection_target_id(connection_id)
	local conditions = M.get_branch_conditions(branch_id)

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
		local label_parsed = parser.parse_element_content(label_unparsed, M.arcscript_code_parser)
		options[i] = { target_id = target_id,
			label = label_parsed,
			theme = M.get_connection_theme(output_connection),
			target_type = M.get_connection_target_type(output_connection)}
	end
	return options
end

return M



