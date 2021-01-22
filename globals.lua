-- Avoid DebugAdapter warnings in VS Code Factorio Mod Debug.
if (__DebugAdapter and __DebugAdapter.defineGlobal) then __DebugAdapter.defineGlobal("Mod") end

Mod = require("framework/mod")
Mod.NAME = "stack-combinator"

Mod.settings = require("framework/settings"):define_all {
  startup = require("scripts/settings-startup"),
  runtime = require("scripts/settings-runtime")
}

Mod.logger = require("framework/logger")
