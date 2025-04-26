local _module_0 = { }
local json = require("json")
assert(json)
local logger = {
	log = print,
	debug = print,
	info = print,
	warn = print,
	error = print
}
local _concat_lists
_concat_lists = function(list_of_lists)
	local output = { }
	for _, list in ipairs(list_of_lists) do
		for _, item in ipairs(list) do
			output[#output + 1] = item
		end
	end
	return output
end
local _put_in_array_if_alone
_put_in_array_if_alone = function(this_guy)
	local output = nil
	if type(this_guy) == "function" or type(this_guy) == "string" then
		output = {
			this_guy
		}
	else
		output = this_guy
	end
	return output
end
local _run_ordered_events
_run_ordered_events = function(funcs, previous_result, retry_count)
	if previous_result == nil then
		previous_result = nil
	end
	if retry_count == nil then
		retry_count = 0
	end
	if #funcs == 0 then
		return
	end
	local first_func = funcs[1]
	local remaining_funcs
	do
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = 2, #funcs do
			local func = funcs[_index_0]
			_accum_0[_len_0] = func
			_len_0 = _len_0 + 1
		end
		remaining_funcs = _accum_0
	end
	if type(first_func) == "table" then
		funcs = _concat_lists({
			first_func,
			remaining_funcs
		})
		first_func = funcs[1]
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = 2, #funcs do
			local func = funcs[_index_0]
			_accum_0[_len_0] = func
			_len_0 = _len_0 + 1
		end
		remaining_funcs = _accum_0
	end
	return G.E_MANAGER:add_event(Event({
		no_delete = true,
		func = function()
			local retry_danger_threshold = 100
			local event_count = #G.E_MANAGER.queues.base
			local event_tolerance = (retry_count - 1) / retry_danger_threshold + 2
			if event_count > event_tolerance then
				if retry_count > 0 and retry_count % retry_danger_threshold == 0 then
					logger.warn("Hit " .. tostring(retry_count) .. " retries, there's probably something stuck in the queue? (The queue has " .. tostring(#G.E_MANAGER.queues.base) .. " entries) (raising the remaining event tolerance to " .. tostring(math.ceil(event_tolerance)) .. ")")
				end
				_run_ordered_events(funcs, previous_result, retry_count + 1)
			else
				local result = nil
				local success
				success, result = pcall(function()
					return first_func(previous_result)
				end)
				if not success then
					logger.error(result)
					result = "FUCK!!!"
				end
				_run_ordered_events(remaining_funcs, result)
			end
			return true
		end
	}))
end
local _n_tabs
_n_tabs = function(indentation)
	return string.rep("\t", indentation)
end
local PREVIOUS_RESULTS_PATH = "steamodded_test_previous_results.json"
local context_defaults = {
	indentation = 0,
	path = { },
	previous_results = { },
	test_index = 1,
	test_count = 1
}
if love.filesystem.getInfo(PREVIOUS_RESULTS_PATH) ~= nil then
	local contents = love.filesystem.read(PREVIOUS_RESULTS_PATH)
	if contents ~= "" then
		context_defaults.previous_results = json.decode(contents)
	end
end
local _anon_func_0 = function(pairs, path, self)
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(path) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0[#_tab_0 + 1] = self.name
	return _tab_0
end
local TestBase
do
	local _class_0
	local _base_0 = {
		path_string = function(path)
			return table.concat(path, "/")
		end,
		path_string_tag_yourself = function(self, path)
			return self.path_string(_anon_func_0(pairs, path, self))
		end,
		gather_events_config_with_defaults = function(config)
			local defaults = {
				whitelist = ".*",
				failed_only = false
			}
			local _tab_0 = { }
			local _idx_0 = 1
			for _key_0, _value_0 in pairs(defaults) do
				if _idx_0 == _key_0 then
					_tab_0[#_tab_0 + 1] = _value_0
					_idx_0 = _idx_0 + 1
				else
					_tab_0[_key_0] = _value_0
				end
			end
			local _idx_1 = 1
			for _key_0, _value_0 in pairs(config) do
				if _idx_1 == _key_0 then
					_tab_0[#_tab_0 + 1] = _value_0
					_idx_1 = _idx_1 + 1
				else
					_tab_0[_key_0] = _value_0
				end
			end
			return _tab_0
		end,
		should_skip = function(self, config, context)
			return false
		end,
		gather_events_context_with_defaults = function(self, context)
			local defaults = context_defaults
			local output
			do
				local _tab_0 = { }
				local _idx_0 = 1
				for _key_0, _value_0 in pairs(defaults) do
					if _idx_0 == _key_0 then
						_tab_0[#_tab_0 + 1] = _value_0
						_idx_0 = _idx_0 + 1
					else
						_tab_0[_key_0] = _value_0
					end
				end
				local _idx_1 = 1
				for _key_0, _value_0 in pairs(context) do
					if _idx_1 == _key_0 then
						_tab_0[#_tab_0 + 1] = _value_0
						_idx_1 = _idx_1 + 1
					else
						_tab_0[_key_0] = _value_0
					end
				end
				output = _tab_0
			end
			return output
		end,
		extrapolate_subcontext = function(self, context)
			local subcontext
			do
				local _tab_0 = { }
				local _idx_0 = 1
				for _key_0, _value_0 in pairs(context) do
					if _idx_0 == _key_0 then
						_tab_0[#_tab_0 + 1] = _value_0
						_idx_0 = _idx_0 + 1
					else
						_tab_0[_key_0] = _value_0
					end
				end
				subcontext = _tab_0
			end
			subcontext.indentation = subcontext.indentation + 1
			do
				local _tab_0 = { }
				local _obj_0 = subcontext.path
				local _idx_0 = 1
				for _key_0, _value_0 in pairs(_obj_0) do
					if _idx_0 == _key_0 then
						_tab_0[#_tab_0 + 1] = _value_0
						_idx_0 = _idx_0 + 1
					else
						_tab_0[_key_0] = _value_0
					end
				end
				_tab_0[#_tab_0 + 1] = self.name
				subcontext.path = _tab_0
			end
			return subcontext
		end,
		line_text = function(self, context, start_text, end_text)
			if start_text == nil then
				start_text = ""
			end
			if end_text == nil then
				end_text = ""
			end
			return _n_tabs(context.indentation + 1) .. "[" .. tostring(context.test_index) .. "/" .. tostring(context.test_count) .. "] " .. start_text .. (start_text ~= "" and " " or "") .. self.__class.__name .. " \"" .. tostring(self.path_string(context.path)) .. "\" " .. end_text
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "TestBase"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	TestBase = _class_0
end
_module_0["TestBase"] = TestBase
local Test
do
	local _class_0
	local _parent_0 = TestBase
	local _base_0 = {
		should_skip = function(self, config, context)
			if config.failed_only and context.previous_results[self.path_string(context.path)] then
				return "Succeeded last time"
			end
			return _class_0.__parent.__base.should_skip(self, config, context)
		end,
		gather_events = function(self, config, _context)
			if config == nil then
				config = { }
			end
			if _context == nil then
				_context = { }
			end
			config = self.gather_events_config_with_defaults(config)
			local context = self:gather_events_context_with_defaults(_context)
			context = self:extrapolate_subcontext(context)
			local output = _put_in_array_if_alone(self.funcs)
			output[#output + 1] = function(result)
				if result == "FUCK!!!" then
					logger.warn(self:line_text(context, nil, "errored! See above..."))
					result = false
				elseif result == false then
					logger.warn(self:line_text(context, nil, "failed! :("))
				elseif result == true then
					logger.info(self:line_text(context, nil, "passed! :)"))
				else
					logger.warn(self:line_text(context, nil, "returned neither true nor false, but instead " .. tostring(result) .. "? :S"))
				end
				return result
			end
			return output
		end
	}
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, name, funcs, prep)
			if prep == nil then
				prep = function() end
			end
			self.name = name
			self.funcs = funcs
		end,
		__base = _base_0,
		__name = "Test",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	Test = _class_0
end
_module_0["Test"] = Test
local TestBundle
do
	local _class_0
	local _parent_0 = TestBase
	local _base_0 = {
		run = function(self, config)
			if config == nil then
				config = { }
			end
			return _run_ordered_events(self:gather_events(config))
		end,
		gather_events = function(self, config, _context)
			if config == nil then
				config = { }
			end
			if _context == nil then
				_context = { }
			end
			config = self.gather_events_config_with_defaults(config)
			local context = self:gather_events_context_with_defaults(_context)
			context = self:extrapolate_subcontext(context)
			local output = { }
			local tally = {
				passed = 0,
				failed = 0,
				skipped = 0
			}
			output[#output + 1] = function()
				return logger.info(_n_tabs(context.indentation) .. "Running test bundle \"" .. tostring(self.path_string(context.path)) .. "\" (contains " .. tostring(#self.tests) .. " subtest(s))...")
			end
			context.test_count = #self.tests
			for test_index, test in ipairs(self.tests) do
				context.test_index = test_index
				local subcontext = test:extrapolate_subcontext(context)
				local events = { }
				local skippy = test:should_skip(config, subcontext)
				if skippy then
					output[#output + 1] = function(result)
						tally.skipped = tally.skipped + 1
						return logger.warn(_n_tabs(subcontext.indentation) .. "Skipped \"" .. tostring(self.path_string(subcontext.path)) .. "\"! Reason: " .. tostring(skippy))
					end
				else
					events = test:gather_events(config, context)
					output[#output + 1] = function()
						return G.E_MANAGER:clear_queue()
					end
					for _, event in ipairs(events) do
						output[#output + 1] = event
					end
					output[#output + 1] = function(result)
						local _update_0 = result and "passed" or "failed"
						tally[_update_0] = tally[_update_0] + 1
						context.previous_results[self.path_string(subcontext.path)] = result
					end
				end
			end
			output[#output + 1] = function()
				local all_passed = tally.failed == 0
				local via = all_passed and logger.info or logger.error
				if tally.skipped > 0 then
					via(_n_tabs(context.indentation) .. "...done with \"" .. tostring(self.path_string(context.path)) .. "\". Ran " .. tostring(#self.tests - tally.skipped) .. "/" .. tostring(#self.tests) .. " test(s). " .. tostring(tally.passed) .. " passed, " .. tostring(tally.failed) .. " failed, " .. tostring(tally.skipped) .. " skipped.")
				else
					via(_n_tabs(context.indentation) .. "...done with \"" .. tostring(self.path_string(context.path)) .. "\". Ran " .. tostring(#self.tests) .. " test(s). " .. tostring(tally.passed) .. " passed, " .. tostring(tally.failed) .. " failed.")
				end
				if true or context.indentation == 0 then
					love.filesystem.write(PREVIOUS_RESULTS_PATH, json.encode(context.previous_results))
				end
				return all_passed
			end
			return output
		end
	}
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, name, tests)
			self.name = name
			self.tests = tests
		end,
		__base = _base_0,
		__name = "TestBundle",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	TestBundle = _class_0
end
_module_0["TestBundle"] = TestBundle
local run_all_tests
run_all_tests = function(config)
	if config == nil then
		config = { }
	end
	G.E_MANAGER:clear_queue()
	if config.failed_only then
		print("Running only tests that didn't succeed on their last run...")
	end
	return G.steamodded_tests:run(config)
end
_module_0["run_all_tests"] = run_all_tests
local _init
_init = function()
	if G.steamodded_tests == nil then
		G.steamodded_tests = TestBundle("All tests", { })
	end
end
_init()
local _prepend_space_if_populated
_prepend_space_if_populated = function(label)
	if label ~= "" then
		label = " " .. label
	end
	return label
end
local _abstract_comparison_assertion
_abstract_comparison_assertion = function(actual, comparison, expectation, explanation, label)
	if explanation == nil then
		explanation = ""
	end
	if label == nil then
		label = ""
	end
	explanation = _prepend_space_if_populated(explanation)
	label = _prepend_space_if_populated(label)
	local error_message = "Got " .. tostring(actual) .. tostring(label) .. ", but expected" .. tostring(explanation) .. " " .. tostring(expectation) .. tostring(label) .. "."
	return assert(comparison(actual, expectation), error_message)
end
local assert_eq
assert_eq = function(actual, expectation, label)
	if label == nil then
		label = ""
	end
	return _abstract_comparison_assertion(actual, (function(a, b)
		return a == b
	end), expectation, "", label)
end
_module_0["assert_eq"] = assert_eq
local assert_ne
assert_ne = function(actual, expectation, label)
	if label == nil then
		label = ""
	end
	return _abstract_comparison_assertion(actual, (function(a, b)
		return a ~= b
	end), expectation, "anything but", label)
end
_module_0["assert_ne"] = assert_ne
local assert_lt
assert_lt = function(actual, expectation, label)
	if label == nil then
		label = ""
	end
	return _abstract_comparison_assertion(actual, (function(a, b)
		return a < b
	end), expectation, "a value less than", label)
end
_module_0["assert_lt"] = assert_lt
local assert_gt
assert_gt = function(actual, expectation, label)
	if label == nil then
		label = ""
	end
	return _abstract_comparison_assertion(actual, (function(a, b)
		return a > b
	end), expectation, "a value greater than", label)
end
_module_0["assert_gt"] = assert_gt
local assert_le
assert_le = function(actual, expectation, label)
	if label == nil then
		label = ""
	end
	return _abstract_comparison_assertion(actual, (function(a, b)
		return a <= b
	end), expectation, "a value less than or equal to", label)
end
_module_0["assert_le"] = assert_le
local assert_ge
assert_ge = function(actual, expectation, label)
	if label == nil then
		label = ""
	end
	return _abstract_comparison_assertion(actual, (function(a, b)
		return a >= b
	end), expectation, "a value greater than or equal to", label)
end
_module_0["assert_ge"] = assert_ge
local playing_card_from_string
playing_card_from_string = function(input)
	local suit = "S"
	local rank = "T"
	input = string.lower(input)
	local if_contains_then
	if_contains_then = function(searching_for, func)
		local count
		input, count = string.gsub(input, searching_for, "")
		if count > 0 then
			return func()
		end
	end
	if_contains_then("spades", function()
		suit = "S"
	end)
	if_contains_then("s", function()
		suit = "S"
	end)
	if_contains_then("♠", function()
		suit = "S"
	end)
	if_contains_then("♤", function()
		suit = "S"
	end)
	if_contains_then("hearts", function()
		suit = "H"
	end)
	if_contains_then("h", function()
		suit = "H"
	end)
	if_contains_then("♥", function()
		suit = "H"
	end)
	if_contains_then("♡", function()
		suit = "H"
	end)
	if_contains_then("clubs", function()
		suit = "C"
	end)
	if_contains_then("c", function()
		suit = "C"
	end)
	if_contains_then("♣", function()
		suit = "C"
	end)
	if_contains_then("♧", function()
		suit = "C"
	end)
	if_contains_then("diamonds", function()
		suit = "D"
	end)
	if_contains_then("d", function()
		suit = "D"
	end)
	if_contains_then("♦", function()
		suit = "D"
	end)
	if_contains_then("♢", function()
		suit = "D"
	end)
	if_contains_then("ace", function()
		rank = "A"
	end)
	if_contains_then("a", function()
		rank = "A"
	end)
	if_contains_then("king", function()
		rank = "K"
	end)
	if_contains_then("k", function()
		rank = "K"
	end)
	if_contains_then("queen", function()
		rank = "Q"
	end)
	if_contains_then("q", function()
		rank = "Q"
	end)
	if_contains_then("jack", function()
		rank = "J"
	end)
	if_contains_then("j", function()
		rank = "J"
	end)
	if_contains_then("ten", function()
		rank = "T"
	end)
	if_contains_then("10", function()
		rank = "T"
	end)
	if_contains_then("t", function()
		rank = "T"
	end)
	local a, b = string.find(input, "%d")
	if a ~= nil then
		rank = string.sub(input, a, b)
	end
	local card = Card(G.play.T.x + G.play.T.w / 2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.c_base, {
		playing_card = G.playing_card
	})
	card:set_base(G.P_CARDS[tostring(suit) .. "_" .. tostring(rank)])
	return card
end
_module_0["playing_card_from_string"] = playing_card_from_string
local waiting_steps
waiting_steps = function(how_many)
	if how_many == nil then
		how_many = 1
	end
	local output = { }
	for _ = 1, how_many do
		output[#output + 1] = function()
			return nil
		end
	end
	return output
end
_module_0["waiting_steps"] = waiting_steps
local create_state_steps
create_state_steps = function(kwargs)
	if kwargs == nil then
		kwargs = { }
	end
	kwargs.stake = kwargs.stake or 1
	kwargs.seed = kwargs.seed or "TUTORIAL"
	return {
		function()
			return G.FUNCS.start_run(nil, {
				stake = kwargs.stake,
				seed = kwargs.seed
			})
		end,
		function()
			return new_round()
		end
	}
end
_module_0["create_state_steps"] = create_state_steps
local empty_hand
empty_hand = function()
	G.hand.cards = { }
end
_module_0["empty_hand"] = empty_hand
local empty_centers
empty_centers = function()
	G.jokers.cards = { }
	G.consumeables.cards = { }
end
_module_0["empty_centers"] = empty_centers
local add_cards_to_hand
add_cards_to_hand = function(playing_cards, select_them)
	if select_them == nil then
		select_them = false
	end
	for _, card in ipairs(playing_cards) do
		if type(card) == "string" then
			card = playing_card_from_string(card)
		end
		card:add_to_deck()
		local _obj_0 = G.deck.config
		_obj_0.card_limit = _obj_0.card_limit + 1
		table.insert(G.playing_cards, card)
		G.hand:emplace(card)
		if select_them then
			card:click()
		end
	end
end
_module_0["add_cards_to_hand"] = add_cards_to_hand
local add_centers
add_centers = function(center_keys)
	center_keys = _put_in_array_if_alone(center_keys)
	for _, center_key in ipairs(center_keys) do
		SMODS.add_card({
			key = center_key,
			soulable = false,
			no_edition = true
		})
	end
end
_module_0["add_centers"] = add_centers
local play_hand
play_hand = function(playing_cards, kwargs)
	if kwargs == nil then
		kwargs = { }
	end
	kwargs.hold = kwargs.hold or { }
	kwargs.centers = kwargs.centers or { }
	empty_hand()
	empty_centers()
	add_cards_to_hand(playing_cards, true)
	add_cards_to_hand(kwargs.hold)
	add_centers(kwargs.centers)
	return G.FUNCS.play_cards_from_highlighted()
end
_module_0["play_hand"] = play_hand
do
	_module_0["assert_hand_scored"] = function(compare_chips_to)
		return assert_eq(G.GAME.chips, compare_chips_to, 'chips')
	end
	_module_0["assert_hand_scored_ne"] = function(compare_chips_to)
		return assert_ne(G.GAME.chips, compare_chips_to, 'chips')
	end
	_module_0["assert_hand_scored_lt"] = function(compare_chips_to)
		return assert_lt(G.GAME.chips, compare_chips_to, 'chips')
	end
	_module_0["assert_hand_scored_gt"] = function(compare_chips_to)
		return assert_gt(G.GAME.chips, compare_chips_to, 'chips')
	end
	_module_0["assert_hand_scored_le"] = function(compare_chips_to)
		return assert_le(G.GAME.chips, compare_chips_to, 'chips')
	end
	_module_0["assert_hand_scored_ge"] = function(compare_chips_to)
		return assert_ge(G.GAME.chips, compare_chips_to, 'chips')
	end
	_module_0["assert_dollars"] = function(compare_dollars_to)
		return assert_eq(G.GAME.dollars, compare_dollars_to, 'dollars')
	end
	_module_0["assert_dollars_ne"] = function(compare_dollars_to)
		return assert_ne(G.GAME.dollars, compare_dollars_to, 'dollars')
	end
	_module_0["assert_dollars_lt"] = function(compare_dollars_to)
		return assert_lt(G.GAME.dollars, compare_dollars_to, 'dollars')
	end
	_module_0["assert_dollars_gt"] = function(compare_dollars_to)
		return assert_gt(G.GAME.dollars, compare_dollars_to, 'dollars')
	end
	_module_0["assert_dollars_le"] = function(compare_dollars_to)
		return assert_le(G.GAME.dollars, compare_dollars_to, 'dollars')
	end
	_module_0["assert_dollars_ge"] = function(compare_dollars_to)
		return assert_ge(G.GAME.dollars, compare_dollars_to, 'dollars')
	end
end
local subcommands = {
	failed = {
		["function"] = function(context)
			context.config.failed_only = true
		end,
		description = "Runs only tests that didn't succeed the last time they were ran (this includes new tests that didn't succeed last time because there wasn't a last time)"
	}
}
for subcommand_name, subcommand in pairs(subcommands) do
	subcommand.aliases = {
		"-" .. string.sub(subcommand_name, 1, 1),
		"--" .. subcommand_name
	}
end
local _anon_func_1 = function(input_string, string)
	local _accum_0 = { }
	local _len_0 = 1
	for x in string.gmatch(input_string, "[^%s]+") do
		_accum_0[_len_0] = x
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local config_from_string
config_from_string = function(input_string)
	local context = {
		tokens = _anon_func_1(input_string, string),
		token_index = 1,
		config = { }
	}
	while context.token_index <= #context.tokens do
		local token = context.tokens[context.token_index]
		local found = false
		for subcommand_name, subcommand in pairs(subcommands) do
			local _list_0 = subcommand.aliases
			for _index_0 = 1, #_list_0 do
				local alias = _list_0[_index_0]
				local _continue_0 = false
				repeat
					if token ~= alias then
						_continue_0 = true
						break
					end
					print(context)
					subcommand["function"](context)
					found = true
					_continue_0 = true
				until true
				if not _continue_0 then
					break
				end
			end
		end
		if not found then
			error("Unknown token: " .. tostring(token))
		end
		context.token_index = context.token_index + 1
	end
	return context.config
end
local success, dpAPI = pcall(require, "debugplus-api")
if success and dpAPI.isVersionCompatible(1) then
	local debugplus = dpAPI.registerID("steamodded_test")
	logger = debugplus.logger
	local desc_lines = { }
	for subcommand_name, subcommand in pairs(subcommands) do
		desc_lines[#desc_lines + 1] = {
			table.concat(subcommand.aliases, ', '),
			subcommand.description
		}
	end
	local aliases_max_width = math.max(unpack((function()
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = 1, #desc_lines do
			local desc_line = desc_lines[_index_0]
			_accum_0[_len_0] = #desc_line[1]
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)()))
	local desc = "IDK man!!! It runs your tests and tells you the results!! has subcommand(s) tho :)\n"
	desc = desc .. table.concat((function()
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = 1, #desc_lines do
			local desc_line = desc_lines[_index_0]
			_accum_0[_len_0] = "\t" .. desc_line[1] .. string.rep(" ", aliases_max_width + 3 - #desc_line[1]) .. desc_line[2]
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)(), "\n")
	local result
	success, result = pcall(debugplus.addCommand, {
		name = "test",
		shortDesc = "Runs all tests.",
		desc = desc,
		exec = function(args, raw_args, dp)
			local config = config_from_string(raw_args)
			run_all_tests(config)
			return "here we go :)"
		end
	})
	if (not success) and (not string.match(result, "This command already exists$")) then
		error(result)
	end
end
return _module_0
