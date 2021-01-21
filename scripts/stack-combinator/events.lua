--------------------------------------------------------------------------------
--- # Events related to the stack combinator entity lifecycle
-- Creation, destruction, etc.
--------------------------------------------------------------------------------

-- Game globals
local _game = game

-- Libraries
local _event = require('__stdlib__/stdlib/event/event')

-- Classes
local StackCombinator = require("stack-combinator")

-- Singletons
local _runtime = Mod.runtime

-- Main object
local StackCombinatorEvents = {}


--- Creation
local function create(ev)
  local input = (ev.created_entity or ev.destination or ev.entity)
  local sc = StackCombinator.created(input)
  _runtime:register_sc(sc)
end

-- Filter events for stack combinator
local function event_filter(ev, entity_field)
  entity_field = entity_field or "entity"
  return ev[entity_field] and ev[entity_field].name == StackCombinator.INPUT_NAME
end

--- Rotation
function StackCombinatorEvents:rotate(ev)
  _runtime.sc(ev.entity).rotated()
end


--- Removal
function StackCombinatorEvents:remove(ev)
  local sc = _runtime.sc(ev.entity)
  sc.destroyed()
  _runtime.unregister_sc(sc)
end

--- Batch removal
-- In case of removed chunks or surfaces, SCs get removed fully (including
-- the output), so all that's left to do is to update the registry.
function StackCombinatorEvents:purge(ev)
  _runtime.register_combinators()
end


--- Register all stack combinator lifecycle events
function StackCombinatorEvents:register_all()
  _event
  -- Creation
    .register(defines.events.on_built_entity, create, event_filter, "created_entity")
    .register(defines.events.on_robot_built_entity, create, event_filter, "created_entity")
    .register(defines.events.on_entity_cloned, create, event_filter, "destination")
    .register(defines.events.script_raised_built, create)
    .register(defines.events.script_raised_revive, create)
  -- Handling
    .register(defines.events.on_player_rotated_entity, self.rotate, event_filter)
  -- Removal
    .register(defines.events.on_player_mined_entity, self.remove, event_filter)
    .register(defines.events.on_robot_mined_entity, self.remove, event_filter)
    .register(defines.events.script_raised_destroy, self.remove, event_filter)
    .register(defines.events.on_entity_died, self.remove, event_filter)
  -- Batch removal
    .register(defines.events.on_chunk_deleted, self.purge, event_filter)
    .register(defines.events.on_surface_cleared, self.purge, event_filter)
    .register(defines.events.on_surface_deleted, self.purge, event_filter)
end


--------------------------------------------------------------------------------
return StackCombinatorEvents