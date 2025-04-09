A simple library for testing Steamodded Balatro mods, which I'm now realizing unambigiously should have been a mod itself and not a library. Uh, oops. :)

It's written in [YueScript](https://yuescript.org/), because I think Lua is a bit verbose and stinky. But it compiles to Lua, so you don't have to switch.

It's integrated with DebugPlus. Use the command "test" to run all your tests. Here's an example:

```lua
testing = assert(SMODS.load_file("libs\\steamodded_test\\main.lua"))()

G.steamodded_tests.tests[] = testing.TestBundle(
    "Example tests", {
        testing.Test("Always passes", -> true)
        testing.Test("Always fails", -> false)
    }
)
```
Then, with DebugPlus, you can do this:

```
INFO - [G] > test
INFO - [G] [steamodded_debug] Running test bundle "All tests"...
INFO - [G] [steamodded_debug]   Running test bundle "Example tests"...
INFO - [G] [steamodded_debug]                   Test "Always fails" failed! :(
INFO - [G] [steamodded_debug]   Ran 2 test(s). 1 passed, 1 failed.
INFO - [G] [steamodded_debug] Ran 1 test(s). 0 passed, 1 failed.
INFO - [G] < ok done ig
```
