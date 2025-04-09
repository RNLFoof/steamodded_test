local _module_0 = { }
local logger = {
	log = print,
	debug = print,
	info = print,
	warn = print,
	error = print
}
local run_ordered_events
run_ordered_events = function(funcs, previous_result)
	if previous_result == nil then
		previous_result = nil
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
	return G.E_MANAGER:add_event(Event({
		no_delete = true,
		func = function()
			local result = first_func(previous_result)
			run_ordered_events(remaining_funcs, result)
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
			return {
				function()
					return self:prep()
				end,
				function(result)
					return self:func(result)
				end,
				function(result)
					if result == false then
						logger.warn(n_tabs(indentation) .. "\tTest \"" .. tostring(self.name) .. "\" failed! :(")
					else
						logger.info(n_tabs(indentation) .. "\tTest \"" .. tostring(self.name) .. "\" passed! :)")
					end
					return result
				end
			}
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, name, func, prep)
			if prep == nil then
				prep = function() end
			end
			self.name = name
			self.func = func
			self.prep = prep
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
local create_state
create_state = function(kwargs)
	G.FUNCS.start_run(nil, {
		stake = 1
	})
	return new_round()
end
_module_0["create_state"] = create_state
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
			return "ok done ig"
		end
	})
end
return _module_0
