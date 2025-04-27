local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()
local _obj_0 = G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = testing.TestBundle("examples", {
	testing.TestBundle("basic", {
		testing.Test("Always passes", function()
			return true
		end),
		testing.Test("Always fails", function()
			return false
		end),
		testing.Test("Always confuses the tester", function()
			return nil
		end),
		testing.Test("Always errors", function()
			return assert(false)
		end)
	}),
	testing.TestBundle("main game", {
		testing.Test("Scoring an Ace", {
			testing.create_state_steps(),
			function()
				return testing.play_hand({
					"A"
				})
			end,
			function()
				return testing.assert_hand_scored(16)
			end
		}),
		testing.Test("Scoring an Ace (overzealous)", {
			testing.create_state_steps(),
			function()
				return testing.play_hand({
					"A"
				})
			end,
			function()
				return testing.assert_hand_scored(99999)
			end
		})
	})
})
