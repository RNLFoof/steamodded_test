local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()
local _obj_0 = G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = testing.TestBundle("Example tests", {
	testing.Test("Always passes", function()
		return true
	end),
	testing.Test("Always fails", function()
		return false
	end),
	testing.TestBundle("Main game tests", {
		testing.Test("Scoring an Ace", {
			testing.create_state_steps(),
			testing.play_hand
		})
	})
})
