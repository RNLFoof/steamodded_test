A simple library for testing Steamodded Balatro mods, which I'm now realizing unambigiously should have been a mod itself and not a library. Uh, oops. :)

It's written in [YueScript](https://yuescript.org/), because I think Lua is a bit verbose and stinky. But it compiles to Lua, so you don't have to switch.

It's integrated with DebugPlus. Use the command "test" to run all your tests. Here's some examples:

```lua
testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()

G.steamodded_tests.tests[] = testing.TestBundle("Example tests", {

        testing.TestBundle("Basic tests", {
            testing.Test("Always passes", -> true)
            testing.Test("Always fails", -> false)
            testing.Test("Always confuses the tester", -> nil)
            testing.Test("Always errors", -> assert(false))
        }),

        testing.TestBundle("Main game tests", {

                testing.Test("Scoring an Ace", {
                    testing.create_state_steps(),
                    -> testing.play_hand({"A"}),
                    -> testing.assert_hand_scored(16)
                }),

                testing.Test("Scoring an Ace (overzealous)", {
                    testing.create_state_steps(),
                    -> testing.play_hand({"A"}),
                    -> testing.assert_hand_scored(99999)
                })
            }
        )

    }
)
```
Then, with DebugPlus, you can do this:

```
> test
< here we go :)
[steamodded_test] Running test bundle "All tests" (contains 1 subtest(s))...
[steamodded_test]    Running test bundle "Example tests" (contains 2 subtest(s))...
[steamodded_test]            Running test bundle "Basic tests" (contains 4 subtest(s))...
[steamodded_test]                            Test "Always passes" passed! :)
[steamodded_test]                            Test "Always fails" failed! :(
[steamodded_test]                            Test "Always confuses the tester" returned neither true nor false, but instead nil? :S
[steamodded_test] assertion failed!
[steamodded_test]                            Test "Always errors" errored! See above...
[steamodded_test]            ...done with "Basic tests". Ran 4 test(s). 2 passed, 2 failed.
[steamodded_test]            Running test bundle "Main game tests" (contains 2 subtest(s))...
[steamodded_test]                            Test "Scoring an Ace" passed! :)
[steamodded_test] Expected 99999 chips, was 16
[steamodded_test]                            Test "Scoring an Ace (overzealous)" errored! See above...
[steamodded_test]            ...done with "Main game tests". Ran 2 test(s). 2 passed, 0 failed.
[steamodded_test]    ...done with "Example tests". Ran 2 test(s). 1 passed, 1 failed.
[steamodded_test] ...done with "All tests". Ran 1 test(s). 0 passed, 1 failed.
```
