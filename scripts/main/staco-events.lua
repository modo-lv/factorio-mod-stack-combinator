--------------------------------------------------------------------------------
--- # Events related to the stack combinator entity lifecycle
-- Creation, destruction, etc.
--------------------------------------------------------------------------------

-- Libraries
local _event = require('__stdlib__/stdlib/event/event')

-- Classes
local StaCo = require("staco")

--------------------------------------------------------------------------------

local StackCombinatorEvents = {}


--- Creation
local function create(ev)
  local input = (ev.created_entity or ev.destination or ev.entity)
  local sc = StaCo.created(input)
  Mod.runtime:register_sc(sc)
end

-- Filter events for stack combinator
local function event_filter(ev, entity_field)
  entity_field = entity_field or "entity"
  return ev[entity_field] and ev[entity_field].name == StaCo.NAME
end

--- Rotation
local function rotate(ev)
  Mod.runtime:sc(ev.entity).rotated()
end


--- Removal
local function remove(ev)
  local sc = Mod.runtime:sc(ev.entity)
  sc:destroyed()
  Mod.runtime:unregister_sc(sc)
end

--- Batch removal
-- In case of removed chunks or surfaces, SCs get removed fully (including
-- the output), so all that's left to do is to update the registry.
local function purge(ev)
  Mod.runtime:register_combinators()
end


--- Register all stack combinator lifecycle events
function StackCombinatorEvents:register_all()
  -- Creation
  _event.register(defines.events.on_built_entity, create, event_filter,
    "created_entity")
  _event.register(defines.events.on_robot_built_entity, create, event_filter,
    "created_entity")
  _event.register(defines.events.on_entity_cloned, create, event_filter,
    "destination")
  _event.register(defines.events.script_raised_built, create)
  _event.register(defines.events.script_raised_revive, create)
  -- Handling
  _event.register(defines.events.on_player_rotated_entity, rotate, event_filter)
  -- Removal
  _event.register(defines.events.on_player_mined_entity, remove, event_filter)
  _event.register(defines.events.on_robot_mined_entity, remove, event_filter)
  _event.register(defines.events.script_raised_destroy, remove, event_filter)
  _event.register(defines.events.on_entity_died, remove, event_filter)
  -- Batch removal
  _event.register(defines.events.on_chunk_deleted, purge, event_filter)
  _event.register(defines.events.on_surface_cleared, purge, event_filter)
  _event.register(defines.events.on_surface_deleted, purge, event_filter)
end


--------------------------------------------------------------------------------
return StackCombinatorEvents