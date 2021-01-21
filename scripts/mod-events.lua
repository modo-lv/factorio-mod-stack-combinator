--------------------------------------------------------------------------------
--- # Mod events
-- @type ModEvents
--------------------------------------------------------------------------------

local _event = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------

local ModEvents = {}

--- Initialize the mod runtime
local function init()
  Mod:init()
  _event.remove(defines.events.on_tick, init)
end

--- Reload mod settings
local function reload()
  Mod.settings:load(true)
end


--- Register mod-level runtime events
function ModEvents.register_all()
  _event.register(defines.events.on_runtime_mod_setting_changed, reload)
  -- Since our initialization needs the Game object, the only reliable way
  -- to do it on every load is to call in on the first tick 
  -- (and then immediately unregister)
  _event.register(defines.events.on_tick, init)    
  _event.on_configuration_changed(init)
end

--------------------------------------------------------------------------------
return ModEvents