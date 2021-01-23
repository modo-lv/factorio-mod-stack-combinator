local events = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------
--- # Events related to the stack combinator entity lifecycle
-- Creation, destruction, etc.
--------------------------------------------------------------------------------

local StackCombinatorEvents = {}

--- Creation
local function create(ev)
  local input = (ev.created_entity or ev.destination or ev.entity)
  local sc = This.StaCo.created(input)
  This.runtime:register_sc(sc)
end

--- Rotation
local function rotate(ev)
  This.runtime:sc(ev.entity):rotated()
end

--- Individual removal.
local function remove(ev)
  local sc = This.runtime:sc(ev.entity)
  sc:destroyed()
  This.runtime:unregister_sc(sc)
end

--- Batch removal (chunk or surface).
-- In case of removed chunks or surfaces, SCs get removed fully (including
-- the output), so all that's left to do is to update the registry.
local function purge()
  This.runtime:register_combinators()
end

--- Main StaCo signal processing.
local function run()
  This.runtime:run_combinators()
end

--------------------------------------------------------------------------------

-- Filter events for stack combinator
local function event_filter(ev, entity_field)
  entity_field = entity_field or "entity"
  return ev[entity_field] and ev[entity_field].name == This.StaCo.NAME
end

function StackCombinatorEvents.register_all()
  -- Run
  events.register(defines.events.on_tick, run)
  -- Creation
  events.register(defines.events.on_built_entity, create, event_filter, "created_entity")
  events.register(defines.events.on_robot_built_entity, create, event_filter, "created_entity")
  events.register(defines.events.on_entity_cloned, create, event_filter, "destination")
  events.register(defines.events.script_raised_built, create, event_filter)
  events.register(defines.events.script_raised_revive, create, event_filter)
  -- Rotation
  events.register(defines.events.on_player_rotated_entity, rotate, event_filter)
  -- Removal
  events.register(defines.events.on_player_mined_entity, remove, event_filter)
  events.register(defines.events.on_robot_mined_entity, remove, event_filter)
  events.register(defines.events.script_raised_destroy, remove, event_filter)
  events.register(defines.events.on_entity_died, remove, event_filter)
  -- Batch removal
  events.register(defines.events.on_chunk_deleted, purge, event_filter)
  events.register(defines.events.on_surface_cleared, purge, event_filter)
  events.register(defines.events.on_surface_deleted, purge, event_filter)
end

--------------------------------------------------------------------------------
return StackCombinatorEvents