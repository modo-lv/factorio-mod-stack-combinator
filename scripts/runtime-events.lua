--------------------------------------------------------------------------------
--- # Main combinator running events
--------------------------------------------------------------------------------

local _event = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------

local RuntimeEvents = {}

--- Register all runtime event handlers
function RuntimeEvents.register_all()
  _event.on_init(RuntimeEvents.init)
  -- Since `game` is not available on load, forward the init to the first tick.
  _event.on_load(function()
    _event.register(defines.events.on_tick, RuntimeEvents.init)
  end)
  -- Not strictly necessary, but let's cover all the bases
  _event.on_configuration_changed(RuntimeEvents.init)
end


local initialized = false
--- Initialize runtime
function RuntimeEvents.init()
  if (not initialized) then
    Mod.runtime:register_combinators()
  end
  initialized = true
  _event.remove(defines.events.on_tick, RuntimeEvents.init)
end

--------------------------------------------------------------------------------

return RuntimeEvents