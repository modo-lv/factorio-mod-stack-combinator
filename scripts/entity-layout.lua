--------------------------------------------------------------------------------
--- # SC entity construction, destruction etc.
--------------------------------------------------------------------------------

local this = {}

--- Log a debug message related to a specific stack combinator
function this.dlog(sc, text)
  dlog("[SC:" .. sc.unit_number .."] " .. text)
end

--- Build the hidden output combinator for a new stack combinator
-- @param sc The stack combinator entity
function this.build(sc)
  this.dlog(sc, "Building output combinator...")
  -- Create the hidden output combinator
  local out = sc.surface.create_entity {
    name = OUT_ENTITY_NAME,
    position = sc.position,
    force = sc.force,
    direction = sc.direction,
    raise_built = false,
    create_built_effect_smoke = false
  }
  out.destructible = false
  out.rotatable = false
  out.operable = false
  
  -- Connect the output combinator to the stack combinator's output
  -- so that when player connects to the SC's output (which outputs nothing),
  -- the OC's signals are on the same wires.
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

  this.dlog(sc, "Output combinator built and connected.")
  this.add_to_list(sc)  
end


--- Add a fully-built stack combinator to the global list of combinators.
-- @param sc The stack combiantor entity
function this.add_to_list(sc)
  all_combinators[sc.unit_number] = { sc = sc, out = out }
  if not (global.config) then global.config = {} end
  if not (global.config[sc.unit_number]) then
    -- TODO: Use mod settings for default values
    cfg = { invert_red = false, invert_green = false }
    global.config[sc.unit_number] = cfg
    this.dlog(sc, "Combinator config: " .. serpent.line(cfg))
  end
  this.dlog(sc, "Added to global list.")
end

--- Find all stack size combinators
function this.find_all()
  dlog("Finding all existing stack combinators...")
  local start = game.ticks_played
  all_combinators = {}
  
  for _, surface in pairs(game.surfaces) do
    -- Find all combinator entities
    local scs = surface.find_entities_filtered({
      name = SC_ENTITY_NAME
    })    
    -- Find each SC's output and store both in the list
    for _, sc in pairs(scs) do
      local out = surface.find_entity(OUT_ENTITY_NAME, sc.position)
      if not out then 
        error("Stack Combinator " .. sc.unit_number .. " (at {" .. sc.position.x .. ", " .. sc.position.y .. "} on " .. surface.name  .. ") has no output!") 
      end
      all_combinators[sc.unit_number] = { sc = sc, out = out }
    end
  end

  local delta = game.ticks_played - start
  dlog("(Re-)registered " .. table_size(all_combinators) .. " stack combinator(s) in " .. delta .. " tick(s).")

  start = game.ticks_played

  -- Remove any orphaned configurations
  local orphans = 0
  for id, _ in pairs(global.config) do
    if not (all_combinators[id]) then
      global.config[id] = nil
      orphans = orphans + 1
    end
  end
  delta = game.ticks_played - start
  if (orphans > 0) then
    dlog("Removed " .. orphans .. " configuration(s) for combinators that "
      .. "no longer exist (this is normal on chunk/surface removals) "
      .. "in ".. delta .." tick(s)."
    )
  end
end

--- Remove a stack combinator
function this.remove(sc)
  -- Remove output
  all_combinators[sc.unit_number].out.destroy({raise_destroy = false})
  -- Remove config
  global.config[sc.unit_number] = nil  
  -- Remove from list
  all_combinators[sc.unit_number] = nil
  this.dlog(sc, "Combinator removed, output destroyed and configuration deleted.")
end


return this