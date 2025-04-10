local _module_0 = { }
local logger = {
	log = print,
	debug = print,
	info = print,
	warn = print,
	error = print
}
local concat_lists
concat_lists = function(list_of_lists)
	local output = { }
	for _, list in ipairs(list_of_lists) do
		for _, item in ipairs(list) do
			output[#output + 1] = item
		end
	end
	return output
end
local run_ordered_events
run_ordered_events = function(funcs, previous_result, retry_count)
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
		funcs = concat_lists({
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
				run_ordered_events(funcs, previous_result, retry_count + 1)
			else
				local result = first_func(previous_result)
				run_ordered_events(remaining_funcs, result)
			end
			return true
		end
	}))
end
local n_tabs
n_tabs = function(indentation)
	return string.rep("\t", indentation)
end
local Test
do
	local _class_0
	local _base_0 = {
		gather_events = function(self, indentation)
			if indentation == nil then
				indentation = 0
			end
			local output = nil
			print(type(self.funcs))
			if type(self.funcs) == "function" then
				print(tostring(self.name) .. ": singlet")
				output = {
					self.funcs
				}
			else
				print(tostring(self.name) .. ": plural")
				output = self.funcs
			end
			output[#output + 1] = function(result)
				if result == false then
					logger.warn(n_tabs(indentation) .. "\tTest \"" .. tostring(self.name) .. "\" failed! :(")
				else
					logger.info(n_tabs(indentation) .. "\tTest \"" .. tostring(self.name) .. "\" passed! :)")
				end
				return result
			end
			return output
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, name, funcs, prep)
			if prep == nil then
				prep = function() end
			end
			self.name = name
			self.funcs = funcs
		end,
		__base = _base_0,
		__name = "Test"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Test = _class_0
end
_module_0["Test"] = Test
local TestBundle
do
	local _class_0
	local _base_0 = {
		run = function(self)
			return run_ordered_events(self:gather_events())
		end,
		gather_events = function(self, indentation)
			if indentation == nil then
				indentation = 0
			end
			local output = { }
			local tally = {
				passed = 0,
				failed = 0
			}
			output[#output + 1] = function()
				return logger.info(n_tabs(indentation) .. "Running test bundle \"" .. tostring(self.name) .. "\" (contains " .. tostring(#self.tests) .. " subtest(s))...")
			end
			for _, test in ipairs(self.tests) do
				local events = test:gather_events(indentation + 1)
				for _, event in ipairs(events) do
					output[#output + 1] = event
				end
				output[#output + 1] = function(result)
					local _update_0 = result and "passed" or "failed"
					tally[_update_0] = tally[_update_0] + 1
				end
			end
			output[#output + 1] = function()
				local all_passed = tally.failed == 0
				local via = all_passed and logger.info or logger.error
				via(n_tabs(indentation) .. "...done. Ran " .. tostring(#self.tests) .. " test(s). " .. tostring(tally.passed) .. " passed, " .. tostring(tally.failed) .. " failed.")
				return all_passed
			end
			print("output of", self.name, output)
			return output
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, name, tests)
			self.name = name
			self.tests = tests
		end,
		__base = _base_0,
		__name = "TestBundle"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	TestBundle = _class_0
end
_module_0["TestBundle"] = TestBundle
local run_all_tests
run_all_tests = function()
	G.E_MANAGER:clear_queue()
	return G.steamodded_tests:run()
end
_module_0["run_all_tests"] = run_all_tests
local init
init = function()
	if G.steamodded_tests == nil then
		G.steamodded_tests = TestBundle("All tests", { })
	end
end
init()
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
local play_hand
play_hand = function()
	local _obj_0 = G.deck.config
	_obj_0.card_limit = _obj_0.card_limit + 1
	local card
	do
		local _with_0 = playing_card_from_string("A")
		_with_0:add_to_deck()
		card = _with_0
	end
	local _obj_1 = G.deck.config
	_obj_1.card_limit = _obj_1.card_limit + 1
	table.insert(G.playing_cards, card)
	G.hand:emplace(card)
	return print(card)
end
_module_0["play_hand"] = play_hand
local success, dpAPI = pcall(require, "debugplus-api")
if success and dpAPI.isVersionCompatible(1) then
	local debugplus = dpAPI.registerID("steamodded_test")
	logger = debugplus.logger
	debugplus.addCommand({
		name = "test",
		shortDesc = "Runs all tests.",
		desc = "IDK man!!! It runs your tests and tells you the results!!",
		exec = function(args, rawArgs, dp)
			run_all_tests()
			return "here we go :)"
		end
	})
end
return _module_0
