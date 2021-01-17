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




return this