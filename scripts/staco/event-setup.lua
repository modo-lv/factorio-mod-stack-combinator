local events = require('__stdlib__/stdlib/event/event')

--------------------------------------------------------------------------------
--- # Events related to the stack combinator entity lifecycle
-- Creation, destruction, etc.
--------------------------------------------------------------------------------

local StackCombinatorEvents = {
  run_delay = nil
}

--- Creation
local function create(ev)
  local input = (ev.created_entity or ev.destination or ev.entity)
  local sc = This.StaCo.created(input)
  This.runtime:register_sc(sc)
  table.insert(This.runtime.update_queue, sc.id)
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
-- In case of removed chunks or surfaces, SCs get removed fully (including the output), so all
-- that's left to do is to update the registry.
local function purge()
  This.runtime:combinators(true)
end

--- Ensure that all StaCos are connected to their output combinators.
-- Any tool that cuts circuit wires of entities will also cut the ones connecting StaCo to its output.
-- There is no clean way to check for wire removal; the best we can do is leave the StaCo disconnected until the player
-- picks up another wire (possibly intending to reconnect the StaCo to something), and then check if any need fixing.
local function ensure_internal_connections(ev)
  local player_index = ev.player_index
  local cursor_stack = game.players[player_index].cursor_stack
  if cursor_stack.valid_for_read then
    local name = cursor_stack.name
    if name == "red-wire" or name == "green-wire" then
      for _, sc in pairs(global.combinators) do
        for _, color in pairs({ "red", "green" }) do
          local control = sc.output.get_control_behavior(defines.wire_type[color])
          local network = control.get_circuit_network(defines.wire_type[color])
          if not network then
            sc:connect()
          end
        end
      end
    end
  end
end

local function run(ev)
  This.runtime:run_combinators(ev.tick)
end

local function cfg_update(ev)
  if (
    ev.setting == Mod.NAME .. "-update-delay"
      or ev.setting == Mod.NAME .. "-update-limit"
  ) then
    This.runtime:cfg_update()
  end
end

--------------------------------------------------------------------------------

-- Filter events for stack combinator
local function event_filter(ev, entity_field)
  entity_field = entity_field or "entity"
  return ev[entity_field] and ev[entity_field].name == This.StaCo.NAME
end

function StackCombinatorEvents.register_all()
  events.register(defines.events.on_tick, run)
  events.register(defines.events.on_player_cursor_stack_changed, ensure_internal_connections)
  -- Config change
  events.register(defines.events.on_runtime_mod_setting_changed, cfg_update)
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
  events.register(defines.events.on_chunk_deleted, purge)
  events.register(defines.events.on_surface_cleared, purge)
  events.register(defines.events.on_surface_deleted, purge)
end

--------------------------------------------------------------------------------
return StackCombinatorEvents