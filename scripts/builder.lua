--[[ Mod globals ]]
all_placed = all_placed or nil

--[[ Persistent globals ]]
global.configs = global.configs or {}

--[[ BUILDER: Entity placement, movement and removal. ]]
local this = {
  placed = {}
}

-- Run every tick
function this.tick(event)
  if all_placed == nil then all_placed = this.find_placed() end
end

-- Find all placed Stack Combinators and put them in the list.
function this.find_placed()
  result = {}
  
  for _, surface in pairs(game.surfaces) do
    -- Find all combinators
    local scs = surface.find_entities_filtered({
      name = "stack-combinator"
    })

    -- Find each combinator's output and store both in the list
    for _, sc in pairs(scs) do
      local out = surface.find_entity("stack-combinator-output", sc.position)
      if not out then 
        error("Stack Combinator " .. sc.unit_number .. " (at {" .. sc.position.x .. ", " .. sc.position.y .. "} on " .. surface.name  .. ") has no output!") 
      end
      result[sc.unit_number] = { sc = sc, out = out }
    end
  end
  
  game.print("Found " .. table_size(result) .. " Stack Combinators.")
  return result
end


--[[
  Remove a Stack Combinator from the map
]]
function this.remove(event)
  if not (event.entity and event.entity.name == "stack-combinator") then return end
  local sc = event.entity
  -- Remove output
  all_placed[sc.unit_number].out.destroy({raise_destroy = false})
  -- Remove from list
  table.remove(all_placed, sc.unit_number)
end


-- Place a Stack Combinator on the world map
function this.place(event)
  if (event.created_entity and event.created_entity.name == "stack-combinator") then
    local sc = event.created_entity
    -- Single-tile SC has a position of x.5 after placement, but create_entity works with round numbers
    local adjustment = { x = 0, y = 0}

    -- Create the output combinator
    local out = sc.surface.create_entity {
      name = "stack-combinator-output",
      position = sc.position,
      force = sc.force,
      direction = sc.direction,
      raise_built = false,
      create_built_effect_smoke = false
    }
    out.destructible = false
    out.minable = false
    out.rotatable = false
    out.operable = false
    
    -- Connect output combinator to main combinator
    sc.connect_neighbour({
        wire = defines.wire_type.red, 
        target_entity = out, 
        source_circuit_id = defines.circuit_connector_id.combinator_output,
        target_circuit_id = defines.circuit_connector_id.constant_combinator
    })
    sc.connect_neighbour({
        wire = defines.wire_type.green,
        target_entity = out,
        source_circuit_id = defines.circuit_connector_id.combinator_output,
        target_circuit_id = defines.circuit_connector_id.constant_combinator
    })
    
    -- Add to the list of stack combinators
    all_placed = all_placed or {}
    all_placed[sc.unit_number] = { sc = sc, out = out }
  end
end

return this