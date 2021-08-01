--------------------------------------------------------------------------------
--- Runtime event setup
--------------------------------------------------------------------------------

local events = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------

local RuntimeEvents = {}

--- Initialize runtime
local function init()
  This.runtime:register_combinators()
  This.runtime:register_run()
end

local function cfg_update(ev)
  if (ev.setting == Mod.NAME .. "-update-delay") then
    This.runtime:register_run()
  end
end

--- Register all runtime event handlers
function RuntimeEvents.register_all()
  events.register(defines.events.on_player_joined_game, init)
  events.register(defines.events.on_runtime_mod_setting_changed, cfg_update)
end

--------------------------------------------------------------------------------

return RuntimeEvents