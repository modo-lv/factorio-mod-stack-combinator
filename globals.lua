----------------------------------------------------------------------------------------------------
--- Global definitions included in all phases
----------------------------------------------------------------------------------------------------

-- Explicitly define globals for VS Code Factorio Mod Debug.
if (__DebugAdapter and __DebugAdapter.defineGlobal) then
  for _, name in ipairs { "Mod", "This" } do
    __DebugAdapter.defineGlobal(name)
  end
end

----------------------------------------------------------------------------------------------------

-- Framework
Mod = require("framework/mod")
Mod:init("stack-combinator")
Mod.logger.MOD_TAG = "[img=item/stack-combinator]"

-- Mod
This = require("scripts/this")
This:init()

----------------------------------------------------------------------------------------------------
