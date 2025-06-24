local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()
local TestBundle = testing.TestBundle
local Test = testing.Test
local _anon_func_0 = function()
	local _accum_0 = { }
	local _len_0 = 1
	for _ = 1, 6 do
		_accum_0[_len_0] = "j_joker"
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local _anon_func_1 = function(G)
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = G.jokers.cards
	for _index_0 = 1, #_list_0 do
		local joker = _list_0[_index_0]
		if joker.config.center.key == "j_joker" then
			_accum_0[_len_0] = joker
			_len_0 = _len_0 + 1
		end
	end
	return _accum_0
end
local _obj_0 = G.steamodded_tests.tests
_obj_0[#_obj_0 + 1] = TestBundle("test_tests", {
	TestBundle("assertions", {
		TestBundle("assert_type", {
			Test("number", function()
				return testing.assert_type(5, "number")
			end),
			Test("metatable", function()
				return testing.assert_type(testing.playing_card_from_string(""), "Card")
			end),
			Test("fancy", {
				function()
					return testing.assert_type(5, "number|string")
				end,
				function()
					return testing.assert_type("hey", "number|string")
				end
			}),
			Test("balatro_subtype", function()
				return testing.assert_type(testing.playing_card_from_string(""), "Node")
			end)
		}),
		Test("assert_eq", function()
			return testing.assert_eq(5, 5)
		end),
		Test("assert_ne", function()
			return testing.assert_ne(5, 4)
		end),
		Test("assert_lt", function()
			return testing.assert_lt(4, 5)
		end),
		Test("assert_gt", function()
			return testing.assert_gt(5, 4)
		end),
		Test("assert_le", function()
			return testing.assert_le(4, 5)
		end),
		Test("assert_ge", function()
			return testing.assert_ge(5, 4)
		end),
		Test("assert_le", function()
			return testing.assert_le(5, 5)
		end),
		Test("assert_ge", function()
			return testing.assert_ge(5, 5)
		end)
	}),
	TestBundle("add_centers", {
		Test("1", {
			testing.create_state_steps(),
			function()
				return testing.add_centers({
					"j_joker"
				})
			end,
			function()
				return testing.assert_eq(G.jokers.cards[1].config.center.key, "j_joker")
			end
		}),
		Test("2", {
			testing.create_state_steps(),
			function()
				return testing.add_centers({
					"j_joker",
					"j_joker"
				})
			end,
			function()
				return testing.assert_eq(G.jokers.cards[1].config.center.key, "j_joker")
			end,
			function()
				return testing.assert_eq(G.jokers.cards[2].config.center.key, "j_joker")
			end
		}),
		Test("6_sequential", {
			testing.create_state_steps(),
			function()
				return testing.add_centers(_anon_func_0())
			end,
			function()
				return testing.assert_eq(#_anon_func_1(G), 6)
			end,
			function()
				return testing.assert_eq(#SMODS.find_card("j_joker"), 6)
			end
		})
	}),
	TestBundle("new_run", {
		Test("default", {
			function()
				return testing.new_run()
			end,
			function()
				return testing.assert_eq(G.GAME.selected_back.name, "Red Deck")
			end
		}),
		Test("by_name", {
			function()
				return testing.new_run({
					back = "Blue Deck"
				})
			end,
			function()
				return testing.assert_eq(G.GAME.selected_back.name, "Blue Deck")
			end
		}),
		Test("by_id", {
			function()
				return testing.new_run({
					back = "b_green"
				})
			end,
			function()
				return testing.assert_eq(G.GAME.selected_back.name, "Green Deck")
			end
		}),
		Test("by_object", {
			function()
				return testing.new_run({
					back = G.P_CENTERS.b_yellow
				})
			end,
			function()
				return testing.assert_eq(G.GAME.selected_back.name, "Yellow Deck")
			end
		})
	})
})
