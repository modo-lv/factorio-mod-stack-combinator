--------------------------------------------------------------------------------
--- Runtime event setup
--------------------------------------------------------------------------------

local events = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------

local RuntimeEvents = {}

--- Initialize runtime
local function init()
  This.runtime:register_combinators()
end

--- Register all runtime event handlers
function RuntimeEvents.register_all()
  events.register(defines.events.on_player_joined_game, init)
end

--------------------------------------------------------------------------------

return RuntimeEvents