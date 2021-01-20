--------------------------------------------------------------------------------
--- # SC entity construction, destruction etc.
--------------------------------------------------------------------------------

local sc_config = require("entity-config")
local mod_config = require("mod-config")

local this = {}

--- Log a debug message related to a specific stack combinator
function this.dlog(sc, text)
  dlog("[SC:" .. sc.unit_number .."] " .. text)
end

--- Build the hidden output combinator for a new stack combinator
-- @param sc The stack combinator entity
-- @param config Starting configuration or default
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

  this.add_to_list(sc, out)  
  this.dlog(sc, "Output combinator built and connected.")
end


--- Find all stack combinators
function this.find_all()
  dlog("Finding all existing stack combinators...")
  local start = game.ticks_played
  global.all_combinators = {}
  
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
      this.add_to_list(sc, out)
    end
  end

  local delta = game.ticks_played - start
  dlog("(Re-)registered " .. table_size(global.all_combinators) .. " stack combinator(s) in " .. delta .. " tick(s).")

  combinators_listed = true
end


--- Add a fully-built stack combinator to the global list of combinators.
-- @param sc The stack combiantor entity
-- @param out The output combinator entity
function this.add_to_list(sc, out)
  if not (global.all_combinators) then global.all_combinators = {} end

  if not (sc_config.from_combinator(sc)) then
    local defaults = mod_config.sc_defaults()
    this.dlog(sc, "Applying defaults: " .. serpent.line(defaults))
    sc_config.to_combinator(sc, defaults)
  end

  global.all_combinators[sc.unit_number] = { sc = sc, out = out }

  this.dlog(sc, "Added to global list.")
end



--- Rotate the output along with the main SC
function this.rotate(sc, player)
  global.all_combinators[sc.unit_number].out.direction = sc.direction
end

--- Remove a stack combinator
function this.remove(sc)
  -- Remove output
  global.all_combinators[sc.unit_number].out.destroy({raise_destroy = false})
  -- Remove from list
  global.all_combinators[sc.unit_number] = nil
  this.dlog(sc, "Combinator removed, output destroyed and configuration deleted.")
end


return this