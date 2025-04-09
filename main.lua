-- [yue]: ./libs/steamodded_test/main.yue
local _module_0 = { } -- 1
local logger = { -- 3
	log = print, -- 3
	debug = print, -- 4
	info = print, -- 5
	warn = print, -- 6
	error = print -- 7
} -- 2
local n_tabs -- 12
n_tabs = function(indentation) -- 12
	return string.rep("\t", indentation) -- 13
end -- 12
local Test -- 15
do -- 15
	local _class_0 -- 15
	local _base_0 = { -- 15
		run = function(self, indentation) -- 20
			if indentation == nil then -- 20
				indentation = 0 -- 20
			end -- 20
			local result = self:func() -- 21
			if result == false then -- 22
				logger.warn(n_tabs(indentation) .. "\tTest \"" .. tostring(self.name) .. "\" failed! :(") -- 23
			end -- 22
			return result -- 24
		end -- 15
	} -- 15
	if _base_0.__index == nil then -- 15
		_base_0.__index = _base_0 -- 15
	end -- 24
	_class_0 = setmetatable({ -- 15
		__init = function(self, name, func) -- 16
			self.name = name -- 17
			self.func = func -- 18
		end, -- 15
		__base = _base_0, -- 15
		__name = "Test" -- 15
	}, { -- 15
		__index = _base_0, -- 15
		__call = function(cls, ...) -- 15
			local _self_0 = setmetatable({ }, _base_0) -- 15
			cls.__init(_self_0, ...) -- 15
			return _self_0 -- 15
		end -- 15
	}) -- 15
	_base_0.__class = _class_0 -- 15
	Test = _class_0 -- 15
end -- 24
_module_0["Test"] = Test -- 15
local TestBundle -- 27
do -- 27
	local _class_0 -- 27
	local _base_0 = { -- 27
		run = function(self, indentation) -- 32
			if indentation == nil then -- 32
				indentation = 0 -- 32
			end -- 32
			local tally = { -- 33
				passed = 0, -- 33
				failed = 0 -- 33
			} -- 33
			logger.info(n_tabs(indentation) .. "Running test bundle \"" .. tostring(self.name) .. "\"...") -- 34
			for _, test in ipairs(self.tests) do -- 35
				local result = test:run(indentation + 1) -- 36
				local _update_0 = result and "passed" or "failed" -- 37
				tally[_update_0] = tally[_update_0] + 1 -- 37
			end -- 37
			local all_passed = tally.failed == 0 -- 38
			local via = all_passed and logger.info or logger.error -- 39
			via(n_tabs(indentation) .. "Ran " .. tostring(#self.tests) .. " test(s). " .. tostring(tally.passed) .. " passed, " .. tostring(tally.failed) .. " failed.") -- 40
			return all_passed -- 41
		end -- 27
	} -- 27
	if _base_0.__index == nil then -- 27
		_base_0.__index = _base_0 -- 27
	end -- 41
	_class_0 = setmetatable({ -- 27
		__init = function(self, name, tests) -- 28
			self.name = name -- 29
			self.tests = tests -- 30
		end, -- 27
		__base = _base_0, -- 27
		__name = "TestBundle" -- 27
	}, { -- 27
		__index = _base_0, -- 27
		__call = function(cls, ...) -- 27
			local _self_0 = setmetatable({ }, _base_0) -- 27
			cls.__init(_self_0, ...) -- 27
			return _self_0 -- 27
		end -- 27
	}) -- 27
	_base_0.__class = _class_0 -- 27
	TestBundle = _class_0 -- 27
end -- 41
_module_0["TestBundle"] = TestBundle -- 27
local run_all_tests -- 44
run_all_tests = function() -- 44
	return G.steamodded_tests:run() -- 45
end -- 44
_module_0["run_all_tests"] = run_all_tests -- 46
local init -- 47
init = function() -- 47
	if G.steamodded_tests == nil then -- 48
		G.steamodded_tests = TestBundle("All tests", { }) -- 48
	end -- 48
end -- 47
init() -- 49
local create_state -- 52
create_state = function(kwargs) -- 52
	return G.FUNCS.start_run(nil, { -- 54
		stake = 1 -- 54
	}) -- 55
end -- 52
_module_0["create_state"] = create_state -- 55
local success, dpAPI = pcall(require, "debugplus-api") -- 59
if success and dpAPI.isVersionCompatible(1) then -- 60
	local debugplus = dpAPI.registerID("steamodded_debug") -- 61
	logger = debugplus.logger -- 62
	debugplus.addCommand({ -- 65
		name = "test", -- 65
		shortDesc = "Testing command", -- 66
		desc = "This command is an example to get you familar with how commands work", -- 67
		exec = function(args, rawArgs, dp) -- 68
			run_all_tests() -- 69
			return "ok done ig" -- 70
		end -- 68
	}) -- 64
end -- 60
return _module_0 -- 71
