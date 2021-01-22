---------------------------------------------------------------------------------------------------
--- Mod events
---------------------------------------------------------------------------------------------------
local ModEvents = {}

--- Initialize the mod runtime.
-- Since our initialization needs the Game object, we have to initialize
-- on the first available tick (and then immediately unregister)
local function init()
  Mod:init()
  Std.events.remove(defines.events.on_tick, init)
end

--- Read the new runtime settings when they've been changed during a game.
local function reload()
  Mod.settings:load(true)
end

---------------------------------------------------------------------------------------------------

--- Register all mod-level runtime event handlers.
function ModEvents.register_all()
  Std.events.register(defines.events.on_runtime_mod_setting_changed, reload)
  Std.events.register(defines.events.on_tick, init)
  Std.events.on_configuration_changed(init)
end

---------------------------------------------------------------------------------------------------
return ModEvents