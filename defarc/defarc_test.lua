-- Module for unit and functional tests for DefArc.

local M = {}

local defarc = require "defarc.defarc"

local test_board = "/dialogs/test_board.json"

local tests = {}
tests[1]  = { name = "001 Loading-----------------", result = function() assert(defarc.load(test_board)) end}
tests[2]  = { name = "002 Creating----------------", result = function() assert(defarc.create(test_board)) end}
tests[3]  = { name = "003 Get Project Name--------", result = function() assert(defarc.get_project_name() == "Sample Project") end}
tests[4]  = { name = "004 Get Project Cover-------", result = function() assert(defarc.get_project_cover() == nil) end}

tests[5]  = { name = "005 Get Boards--------------", result = function() assert(defarc.get_boards()) end}
tests[6]  = { name = "006 Get Boards Names--------", result = function() assert(defarc.get_boards_names()) end}
tests[7]  = { name = "007 Get Board By Id---------", result = function() assert(defarc.get_board_by_id("630fdb8a-48d6-473e-9974-2460f7eb2b41")) end}
tests[8]  = { name = "008 Get Board By Name-------", result = function() assert(defarc.get_board_by_name("Test Board")) end}
tests[9]  = { name = "009 Get Board---------------", result = function() assert(defarc.get_board("Test Board")) end}
tests[10] = { name = "010 Set Board By Id---------", result = function() defarc.select_board_by_id("630fdb8a-48d6-473e-9974-2460f7eb2b41") assert(defarc.board_selected) end}
tests[11] = { name = "011 Set Board By Name-------", result = function() defarc.select_board_by_name("Test Board") assert(defarc.board_selected) end}
tests[12] = { name = "012 Set Board---------------", result = function() defarc.select_board("Test Board") assert(defarc.board_selected) end}
tests[13] = { name = "013 Get Board Name----------", result = function() assert(defarc.get_board() and defarc.get_board_name() and defarc.get_board_name() == "Test Board") end}

tests[14] = { name = "014 Get Notes---------------", result = function() assert(defarc.get_notes()) end}
tests[15] = { name = "015 Get Board Jumpers-------", result = function() assert(defarc.get_board_jumpers()) end}
tests[16] = { name = "016 Get Board Branches------", result = function() assert(defarc.get_board_branches()) end}
tests[17] = { name = "017 Get Board Elements------", result = function() assert(defarc.get_board_elements()) end}
tests[18] = { name = "018 Get Board Connections---", result = function() assert(defarc.get_board_connections()) end}

tests[19] = { name = "019 Get Components----------", result = function() assert(defarc.get_components()) end}
tests[20] = { name = "020 Get Components Names----", result = function() assert(defarc.get_components_names()) end}
tests[21] = { name = "021 Get Component By Id-----", result = function() assert(defarc.get_component_by_id("651e10ef-a07a-48a3-ad5a-7d415f6c41ba")) end}
tests[22] = { name = "022 Get Component By Name---", result = function() assert(defarc.get_component_by_name("Other_Component")) end}
tests[23] = { name = "023 Get Component-----------", result = function() assert(defarc.get_component("Other_Component")) end}
tests[24] = { name = "024 Set Component By Id-----", result = function() defarc.select_component_by_id("651e10ef-a07a-48a3-ad5a-7d415f6c41ba") assert(defarc.component_selected) end}
tests[25] = { name = "025 Set Component By Name---", result = function() defarc.select_component_by_name("Other_Component") assert(defarc.component_selected) end}
tests[26] = { name = "026 Set Component-----------", result = function() defarc.select_component("Other_Component") assert(defarc.component_selected) end}
tests[27] = { name = "027 Get Component Name------", result = function() assert(defarc.get_component() and defarc.get_component_name() and defarc.get_component_name() == "Other_Component") end}

tests[28] = { name = "028 Get Component Attributes", result = function() assert(defarc.get_component_attributes()) end}
tests[29] = { name = "029 Get Component Assets----", result = function() assert(defarc.get_component_assets()) end}

tests[30] = { name = "030 Get Attributes ---------", result = function() assert(defarc.get_attributes()) end}
tests[31] = { name = "031 Get Attributes Names----", result = function() assert(defarc.get_attributes_names()) end}
tests[32] = { name = "032 Get Attribute By Id-----", result = function() assert(defarc.get_attribute_by_id("c3b460d8-66d3-43a0-9b04-e7208bf96f72")) end}
tests[33] = { name = "033 Get Attribute By Name---", result = function() assert(defarc.get_attribute_by_name("Component_Property_Name")) end}
tests[34] = { name = "034 Set Attribute By Id-----", result = function() defarc.select_attribute_by_id("c3b460d8-66d3-43a0-9b04-e7208bf96f72") assert(defarc.attribute_selected) end}
tests[35] = { name = "035 Set Attribute By Name---", result = function() defarc.select_attribute_by_name("Component_Property_Name") assert(defarc.attribute_selected) end}
tests[36] = { name = "036 Set Attribute-----------", result = function() defarc.select_attribute("Component_Property_Name") assert(defarc.attribute_selected) end}
tests[37] = { name = "037 Get Attribute Name------", result = function() assert(defarc.get_attribute() and defarc.get_attribute_name() and defarc.get_attribute_name() == "Component_Property_Name") end}

tests[38] = { name = "038 Get Attribute Value-----", result = function() assert(defarc.get_attribute_value()) end}
tests[39] = { name = "039 Get Attribute Data------", result = function() assert(defarc.get_attribute_data()) end}
tests[40] = { name = "040 Get Attribute Type------", result = function() assert(defarc.get_attribute_type()) end}

tests[41] = { name = "041 Get Assets--------------", result = function() assert(defarc.get_assets()) end}
tests[42] = { name = "042 Get Assets Names--------", result = function() assert(defarc.get_assets_names()) end}
tests[43] = { name = "043 Get Asset By Id---------", result = function() assert(defarc.get_asset_by_id("5be8b4b7-09cb-4c16-acc1-03650fed40c4")) end}
tests[44] = { name = "044 Get Asset By Name-------", result = function() assert(defarc.get_asset_by_name("icon_192.png")) end}
tests[45] = { name = "045 Get Asset---------------", result = function() assert(defarc.get_asset("icon_192.png")) end}
tests[46] = { name = "046 Set Asset By Id---------", result = function() defarc.select_asset_by_id("5be8b4b7-09cb-4c16-acc1-03650fed40c4") assert(defarc.asset_selected) end}
tests[47] = { name = "047 Set Asset By Name-------", result = function() defarc.select_asset_by_name("icon_192.png") assert(defarc.asset_selected) end}
tests[48] = { name = "048 Set Asset---------------", result = function() defarc.select_asset("icon_192.png") assert(defarc.asset_selected) end}
tests[49] = { name = "049 Get Asset Name----------", result = function() assert(defarc.get_asset_name() and defarc.get_asset_name() == "icon_192.png") end}

tests[50] = { name = "050 Get Asset Type----------", result = function() assert(defarc.get_asset_type() and defarc.get_asset_type() == "image") end}
tests[51] = { name = "051 Get Asset Children------", result = function() assert(defarc.get_asset_children("647d0495-341f-42b2-8788-b47dace22bf8")) end}

tests[52] = { name = "052 Get Variables-----------", result = function() assert(defarc.get_variables()) end}
tests[53] = { name = "053 Get Variables Names-----", result = function() assert(defarc.get_variables_names()) end}
tests[54] = { name = "054 Get Variable By Id------", result = function() assert(defarc.get_variable_by_id("adfd9319-4c6f-4a48-84c4-448bdb56d0de")) end}
tests[55] = { name = "055 Get Variable By Name----", result = function() assert(defarc.get_variable_by_name("variable_Integer")) end}
tests[56] = { name = "056 Set Variable By Id------", result = function() defarc.select_variable_by_id("adfd9319-4c6f-4a48-84c4-448bdb56d0de") assert(defarc.variable_selected) end}
tests[57] = { name = "057 Set Variable By Name----", result = function() defarc.select_variable_by_name("variable_Integer") assert(defarc.variable_selected) end}
tests[58] = { name = "058 Set Variable------------", result = function() defarc.select_variable("variable_Integer") assert(defarc.variable_selected) end}
tests[59] = { name = "059 Get Variable Name-------", result = function() assert(defarc.get_variable() and defarc.get_variable_name() == "variable_Integer") end}

tests[60] = { name = "060 Get Variable Type-------", result = function() assert(defarc.get_variable_type()) end}
tests[61] = { name = "061 Get Variable Value------", result = function() assert(defarc.get_variable_value()) end}

tests[62] = { name = "062 Get Jumpers-------------", result = function() assert(defarc.get_jumpers()) end}
tests[63] = { name = "063 Get Jumpers Elements Id-", result = function() assert(defarc.get_jumpers_elements_id()) end}
tests[64] = { name = "064 Get Jumper By Id--------", result = function() assert(defarc.get_jumper_by_id("b1ff472d-1e02-4ab4-8200-f84c4d8faba3")) end}
tests[65] = { name = "065 Get Jumper By Element Id", result = function() assert(defarc.get_jumper_by_element_id("dcd4defc-fd0a-43ed-9e0a-158588a269a7")) end}
tests[66] = { name = "066 Set Jumper By Id--------", result = function() defarc.select_jumper_by_id("b1ff472d-1e02-4ab4-8200-f84c4d8faba3") assert(defarc.jumper_selected) end}
tests[67] = { name = "067 Set Jumper By Name------", result = function() defarc.select_jumper_by_element_id("dcd4defc-fd0a-43ed-9e0a-158588a269a7") assert(defarc.jumper_selected) end}
tests[68] = { name = "068 Set Jumper--------------", result = function() defarc.select_jumper("b1ff472d-1e02-4ab4-8200-f84c4d8faba3") assert(defarc.jumper_selected) end}

tests[69] = { name = "069 Get Jumper Element Id---", result = function() assert(defarc.get_jumper() and defarc.get_jumper_element_id() == "dcd4defc-fd0a-43ed-9e0a-158588a269a7") end}

tests[70] = { name = "070 Get Branches------------", result = function() assert(defarc.get_branches()) end}
tests[71] = { name = "071 Get Branch By Id--------", result = function() assert(defarc.get_branch_by_id("21113030-8ecc-4d26-a07b-681205e6b8b5")) end}
tests[72] = { name = "072 Set Branch By Id--------", result = function() defarc.select_branch_by_id("21113030-8ecc-4d26-a07b-681205e6b8b5") assert(defarc.branch_selected) end}
tests[73] = { name = "073 Set Branch--------------", result = function() defarc.select_branch("21113030-8ecc-4d26-a07b-681205e6b8b5") assert(defarc.branch_selected) end}
tests[74] = { name = "074 Get Branch -------------", result = function() assert(defarc.get_branch()) end}

tests[75] = { name = "075 Get Branch Theme--------", result = function() assert(defarc.get_branch_theme() == "default") end}
tests[76] = { name = "076 Get Branch Conditions---", result = function() assert(defarc.get_branch_conditions()) end}
tests[77] = { name = "077 Get Branch If Condition-", result = function() assert(defarc.get_branch_if_condition() == "6eacd8aa-d4eb-4238-b845-2bef7b7bf381") end}
tests[78] = { name = "078 Get Branch Else If------", result = function() assert(defarc.get_branch_elseif_conditions()) end}
tests[79] = { name = "079 Get Branch Else---------", result = function() assert(defarc.get_branch_else_condition() == "c0dcb553-2924-466f-bb5a-e9d21078c08f") end}

tests[80] = { name = "080 Get Conditions----------", result = function() assert(defarc.get_conditions()) end}
tests[81] = { name = "081 Get Condition By Id-----", result = function() assert(defarc.get_condition_by_id("6eacd8aa-d4eb-4238-b845-2bef7b7bf381")) end}
tests[82] = { name = "082 Set Condition By Id-----", result = function() defarc.select_condition_by_id("6eacd8aa-d4eb-4238-b845-2bef7b7bf381") assert(defarc.condition_selected) end}
tests[83] = { name = "083 Set Condition-----------", result = function() defarc.select_condition("6eacd8aa-d4eb-4238-b845-2bef7b7bf381") assert(defarc.condition_selected) end}
tests[84] = { name = "084 Get Condition ----------", result = function() assert(defarc.get_condition()) end}

tests[85] = { name = "085 Get Condition Output----", result = function() assert(defarc.get_condition_output() == "ba5339d7-e9e9-4007-895f-1970024fee8b") end}
tests[86] = { name = "086 Get Condition Script----", result = function() assert(defarc.get_condition_script() == "variable_Bool == true") end}

tests[87] = { name = "087 Save Variable Integer---", result = function() assert(defarc.save_variable("variable_Integer")) end}
tests[88] = { name = "088 Save Variable Float-----", result = function() assert(defarc.save_variable("variable_Float")) end}
tests[89] = { name = "089 Save Variable String----", result = function() assert(defarc.save_variable("variable_String")) end}
tests[90] = { name = "090 Save Variable Bool------", result = function() assert(defarc.save_variable("variable_Bool")) end}

tests[91] = { name = "091 Load Variable Integer---", result = function() assert(defarc.load_variable("variable_Integer") == 0) end}
tests[92] = { name = "092 Load Variable Float-----", result = function() assert(defarc.load_variable("variable_Float") == 0.0) end}
tests[93] = { name = "093 Load Variable String----", result = function() assert(defarc.load_variable("variable_String") == "test") end}
tests[94] = { name = "094 Load Variable Bool------", result = function() assert(defarc.load_variable("variable_Bool") == false) end}

tests[95] = { name = "095 Save New Var Integer----", result = function() assert(defarc.save_variable("variable_Integer", 1)) end}
tests[96] = { name = "096 Save New Var Float------", result = function() assert(defarc.save_variable("variable_Float", 1.0)) end}
tests[97] = { name = "097 Save New Var String-----", result = function() assert(defarc.save_variable("variable_String", "new_test")) end}
tests[98] = { name = "098 Save New Var Bool-------", result = function() assert(defarc.save_variable("variable_Bool", true)) end}

tests[99] = { name = "099 Load New Var Integer----", result = function() return defarc.load_variable("variable_Integer") == 1 end}
tests[100] = { name = "100 Load New Var Float------", result = function() assert(defarc.load_variable("variable_Float") == 1.0) end}
tests[101] = { name = "101 Load New Var String-----", result = function() assert(defarc.load_variable("variable_String") == "new_test") end}
tests[102] = { name = "102 Load New Var Bool-------", result = function() assert(defarc.load_variable("variable_Bool") == true) end}

tests[103] = { name = "103 Parse Bool True---------", result = function() assert(defarc.check_condition() and defarc.get_condition_output() == "ba5339d7-e9e9-4007-895f-1970024fee8b") end}
tests[104] = { name = "104 Overwrite Var Bool------", result = function() assert(defarc.save_variable("variable_Bool", false)) end}
tests[105] = { name = "105 Parse Bool False--------", result = function() assert(defarc.check_condition() == false) end}

tests[106] = { name = "106 Parse String False------", result = function() defarc.select_condition("8eb32d5f-18d6-4bf0-bfc7-2f0bfe957492") assert(defarc.check_condition() == false) end}
tests[107] = { name = "107 Overwrite Var String----", result = function() assert(defarc.save_variable("variable_String", "test")) end}
tests[108] = { name = "108 Parse String True-------", result = function() assert(defarc.check_condition() and defarc.get_condition_output() == "18420186-afab-4389-8525-3e0730cc6718") end}

tests[109] = { name = "109 Parse Integer False-----", result = function() defarc.select_condition("3dbab501-0ee3-43f1-8103-c7ea94635bf9") assert(defarc.check_condition() == false) end}
tests[110] = { name = "110 Overwrite Var Integer---", result = function() assert(defarc.save_variable("variable_Integer", 10)) end}
tests[111] = { name = "111 Parse Integer True------", result = function() assert(defarc.check_condition() and defarc.get_condition_output() == "d4f47133-8487-4563-82ea-82cb99c74a38") end}

tests[112] = { name = "112 Parse Float True--------", result = function() defarc.select_condition("bad7b408-1ba7-4eba-80a4-2f22df2528e3") assert(defarc.check_condition()) end}
tests[113] = { name = "113 Overwrite Var Float-----", result = function() assert(defarc.save_variable("variable_Float", 20.5)) end}
tests[114] = { name = "114 Parse Float False-------", result = function() assert(defarc.check_condition() == false) end}

tests[115] = { name = "115 Parse Bool Raw False----", result = function() defarc.select_condition("8bb3f5f2-cccc-4ecc-8e49-cfa3bea33d84") assert(defarc.check_condition() == false) end}
tests[116] = { name = "116 Overwrite Var Raw Bool--", result = function() assert(defarc.save_variable("variable_Bool", true)) end}
tests[117] = { name = "117 Parse Bool Raw True-----", result = function() assert(defarc.check_condition()) end}

tests[118] = { name = "118 Compare Two Vars--------", result = function() defarc.select_condition("aa25eefd-bbcf-4476-84a5-d6d9e2b340ef") assert(defarc.check_condition() == false) end}
tests[119] = { name = "119 Overwrite One Var-------", result = function() assert(defarc.save_variable("variable_Float", 0)) end}
tests[120] = { name = "120 Compare Two Vars Again--", result = function() assert(defarc.check_condition()) end}

tests[121] = { name = "121 Get Elements------------", result = function() assert(defarc.get_elements()) end}
tests[122] = { name = "122 Get Elements Titles-----", result = function() assert(defarc.get_elements_titles()) end}
tests[123] = { name = "123 Get Element By Id-------", result = function() assert(defarc.get_element_by_id("dcd4defc-fd0a-43ed-9e0a-158588a269a7")) end}
tests[124] = { name = "124 Get Element By Title----", result = function() assert(defarc.get_element_by_title("Adventurer")) end}
tests[125] = { name = "125 Get Element-------------", result = function() assert(defarc.get_element("Adventurer")) end}
tests[126] = { name = "126 Set Element By Id-------", result = function() defarc.select_element_by_id("dcd4defc-fd0a-43ed-9e0a-158588a269a7") assert(defarc.element_selected) end}
tests[127] = { name = "127 Set Element By Title----", result = function() defarc.select_element_by_title("Adventurer") assert(defarc.element_selected) end}
tests[128] = { name = "128 Set Element-------------", result = function() defarc.select_element("Adventurer") assert(defarc.element_selected) end}

tests[129] = { name = "129 Get Element Title-------", result = function() assert(defarc.get_element() and defarc.get_element_title() == "Adventurer") end}
tests[130] = { name = "130 Get Element Theme-------", result = function() assert(defarc.get_element_theme() and defarc.get_element_theme() == "cyan") end}
tests[131] = { name = "131 Get Element Content-----", result = function() assert(defarc.get_element_content() == "Hello! I have all the flowers you need.") end}
tests[132] = { name = "132 Get Element Outputs-----", result = function() assert(defarc.get_element_outputs()) end}
tests[133] = { name = "133 Get Element Components--", result = function() assert(defarc.get_element_components()) end}
tests[134] = { name = "134 Get Element Linked Board", result = function() assert(defarc.get_element_linked_board() == nil) end}

tests[135] = { name = "135 Get Connections---------", result = function() assert(defarc.get_connections()) end}
tests[136] = { name = "136 Get Connections SourceId", result = function() assert(defarc.get_connections_for_source_id("dcd4defc-fd0a-43ed-9e0a-158588a269a7")) end}
tests[137] = { name = "137 Get Connection By Id----", result = function() assert(defarc.get_connection_by_id("55555821-c8b9-425c-9ddb-a6bc4e4c43ec")) end}
tests[138] = { name = "138 Get Connection----------", result = function() assert(defarc.get_connection("55555821-c8b9-425c-9ddb-a6bc4e4c43ec")) end}
tests[139] = { name = "139 Set Connection By Id----", result = function() defarc.select_connection_by_id("55555821-c8b9-425c-9ddb-a6bc4e4c43ec") assert(defarc.connection_selected) end}
tests[140] = { name = "140 Set Connection----------", result = function() defarc.select_connection("55555821-c8b9-425c-9ddb-a6bc4e4c43ec") assert(defarc.connection_selected) end}

tests[141] = { name = "141 Get Connection Type-----", result = function() assert(defarc.get_connection() and defarc.get_connection_type() == "Flowchart") end}
tests[142] = { name = "142 Get Connection Label----", result = function() assert(defarc.get_connection_label() == "next") end}
tests[143] = { name = "143 Get Connection Theme----", result = function() assert(defarc.get_connection_theme() == "default") end}
tests[144] = { name = "144 Get Connection Source Id", result = function() assert(defarc.get_connection_source_id() == "8692fecc-2fbc-48e7-b008-4a3b8b44197c") end}
tests[145] = { name = "145 Get Connection Target Id", result = function() assert(defarc.get_connection_target_id() == "57c7fe5d-1df2-4927-bf9d-e61d0d1687a7") end}
tests[146] = { name = "146 Get Conn Source Type----", result = function() assert(defarc.get_connection_source_type() == "elements") end}
tests[147] = { name = "147 Get Conn Target Type----", result = function() assert(defarc.get_connection_target_type() == "elements") end}

function M.run()
	local OK = 0
	local FAILED = 0
	local test_result = false
	local error_text = false
	for i, test in ipairs(tests) do
		test_result, error_text = pcall(test.result)
		if test_result then
			OK = OK + 1
		else
			FAILED = FAILED + 1
		end
		print("DefArc Test:", test.name..":", (test_result) and "OK" or ("FAILED: " .. (tostring(error_text)) ) )
	end
	print("DefArc Test:", "Summary:", "| OK: ", OK, " | FAILED: ", FAILED, " | RUN: ", OK+FAILED, " | TOTAL: :", #tests, " |")

	--print("V", loadstring("return true"))
end

return M