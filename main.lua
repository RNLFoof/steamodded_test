local _module_0 = {  }local logger = { log = 

print, debug = 
print, info = 
print, warn = 
print, error = 
print }




local n_tabs;n_tabs = function(indentation)return 
string.rep("\t", indentation)end

local Test;do local _class_0;local _base_0 = { run = function(self, indentation)if 




indentation == nil then indentation = 0 end;local result = 
self:func()if 
result == false then
logger.warn(n_tabs(indentation) .. "\tTest \"" .. tostring(self.name) .. "\" failed! :(")end;return 
result end }if _base_0.__index == nil then _base_0.__index = _base_0 end;_class_0 = setmetatable({ __init = function(self, name, func)self.name = name;self.func = func end, __base = _base_0, __name = "Test" }, { __index = _base_0, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;Test = _class_0 end;_module_0["Test"] = Test


local TestBundle;do local _class_0;local _base_0 = { run = function(self, indentation)if 




indentation == nil then indentation = 0 end;local tally = { passed = 
0, failed = 0 }
logger.info(n_tabs(indentation) .. "Running test bundle \"" .. tostring(self.name) .. "\"...")for _, test in 
ipairs(self.tests) do local result = 
test:run(indentation + 1)local _update_0 = 
result and "passed" or "failed"tally[_update_0] = tally[_update_0] + 1 end;local all_passed = 
tally.failed == 0;local via = 
all_passed and logger.info or logger.error
via(n_tabs(indentation) .. "Ran " .. tostring(#self.tests) .. " test(s). " .. tostring(tally.passed) .. " passed, " .. tostring(tally.failed) .. " failed.")return 
all_passed end }if _base_0.__index == nil then _base_0.__index = _base_0 end;_class_0 = setmetatable({ __init = function(self, name, tests)self.name = name;self.tests = tests end, __base = _base_0, __name = "TestBundle" }, { __index = _base_0, __call = function(cls, ...)local _self_0 = setmetatable({  }, _base_0)cls.__init(_self_0, ...)return _self_0 end })_base_0.__class = _class_0;TestBundle = _class_0 end;_module_0["TestBundle"] = TestBundle


local run_all_tests;run_all_tests = function()return 
G.steamodded_tests:run()end
_module_0["run_all_tests"] = run_all_tests
local init;init = function()if 
G.steamodded_tests == nil then G.steamodded_tests = TestBundle("All tests", {  })end end
init()


local create_state;create_state = function(kwargs)return 

G.FUNCS.start_run(nil, { stake = 1 })end
_module_0["create_state"] = create_state;local success,dpAPI = 



pcall(require, "debugplus-api")if 
success and dpAPI.isVersionCompatible(1) then local debugplus = 
dpAPI.registerID("steamodded_debug")
logger = debugplus.logger


debugplus.addCommand({ name = "test", shortDesc = 
"Testing command", desc = 
"This command is an example to get you familar with how commands work", exec = function(args, rawArgs, dp)

run_all_tests()return 
"ok done ig"end })end;return 
_module_0;