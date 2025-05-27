local testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()
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
_obj_0[#_obj_0 + 1] = testing.TestBundle("test tests", {
	testing.TestBundle("assertions", {
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
	}),
	testing.TestBundle("add_centers", {
		testing.Test("1", (function()
			local _tab_0 = { }
			local _obj_1 = testing.create_state_steps()
			local _idx_0 = 1
			for _key_0, _value_0 in pairs(_obj_1) do
				if _idx_0 == _key_0 then
					_tab_0[#_tab_0 + 1] = _value_0
					_idx_0 = _idx_0 + 1
				else
					_tab_0[_key_0] = _value_0
				end
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.add_centers({
					"j_joker"
				})
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.assert_eq(G.jokers.cards[1].config.center.key, "j_joker")
			end
			return _tab_0
		end)()),
		testing.Test("2", (function()
			local _tab_0 = { }
			local _obj_1 = testing.create_state_steps()
			local _idx_0 = 1
			for _key_0, _value_0 in pairs(_obj_1) do
				if _idx_0 == _key_0 then
					_tab_0[#_tab_0 + 1] = _value_0
					_idx_0 = _idx_0 + 1
				else
					_tab_0[_key_0] = _value_0
				end
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.add_centers({
					"j_joker",
					"j_joker"
				})
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.assert_eq(G.jokers.cards[1].config.center.key, "j_joker")
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.assert_eq(G.jokers.cards[2].config.center.key, "j_joker")
			end
			return _tab_0
		end)()),
		testing.Test("6, sequential", (function()
			local _tab_0 = { }
			local _obj_1 = testing.create_state_steps()
			local _idx_0 = 1
			for _key_0, _value_0 in pairs(_obj_1) do
				if _idx_0 == _key_0 then
					_tab_0[#_tab_0 + 1] = _value_0
					_idx_0 = _idx_0 + 1
				else
					_tab_0[_key_0] = _value_0
				end
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.add_centers(_anon_func_0())
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.assert_eq(#_anon_func_1(G), 6)
			end
			_tab_0[#_tab_0 + 1] = function()
				return testing.assert_eq(#SMODS.find_card("j_joker"), 6)
			end
			return _tab_0
		end)())
	})
})
