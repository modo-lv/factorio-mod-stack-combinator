--------------------------------------------------------------------------------
--- # Main combinator running events
--------------------------------------------------------------------------------

local _event = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------

local RuntimeEvents = {}


local initialized = false
--- Initialize runtime
local function init()
  if (not initialized) then
    Mod.runtime:register_combinators()
  end
  initialized = true
  _event.remove(defines.events.on_tick, init)
end

--- Register all runtime event handlers
function RuntimeEvents.register_all()
  _event.on_init(init)
  -- Since `game` is not available on load, forward the init to the first tick.
  _event.on_load(function()
    _event.register(defines.events.on_tick, init)
  end)
  -- Not strictly necessary, but let's cover all the bases
  _event.on_configuration_changed(init)
end


--------------------------------------------------------------------------------

return RuntimeEvents