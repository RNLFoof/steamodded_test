-- [yue]: ./libs/steamodded_test/example.yue
local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))() -- 1
local _obj_0 = G.steamodded_tests.tests -- 3
_obj_0[#_obj_0 + 1] = testing.TestBundle("Example tests", { -- 5
	testing.Test("Always passes", function() -- 5
		return true -- 5
	end), -- 5
	testing.Test("Always fails", function() -- 6
		return false -- 6
	end) -- 6
}) -- 3
