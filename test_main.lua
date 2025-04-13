local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()
local _obj_0 = G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = testing.TestBundle("Test tests", {
	testing.TestBundle("Assertion function tests", {
		testing.Test("assert_eq", function()
			return testing.assert_eq(5, 5)
		end),
		testing.Test("assert_ne", function()
			return testing.assert_ne(5, 4)
		end),
		testing.Test("assert_lt", function()
			return testing.assert_lt(4, 5)
		end),
		testing.Test("assert_gt", function()
			return testing.assert_gt(5, 4)
		end),
		testing.Test("assert_le", function()
			return testing.assert_le(4, 5)
		end),
		testing.Test("assert_ge", function()
			return testing.assert_ge(5, 4)
		end),
		testing.Test("assert_le", function()
			return testing.assert_le(5, 5)
		end),
		testing.Test("assert_ge", function()
			return testing.assert_ge(5, 5)
		end)
	})
})
