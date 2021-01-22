-- Avoid DebugAdapter warnings in VS Code Factorio Mod Debug.
if (__DebugAdapter and __DebugAdapter.defineGlobal) then __DebugAdapter.defineGlobal("Mod") end
Mod = require("scripts/mod")
Mod.settings = require("scripts/settings")
Mod.logger = require("scripts/logger")

require("prototypes.entities")
require("prototypes.items")