--------------------------------------------------------------------------------
--- # SC entity construction, destruction etc.
--------------------------------------------------------------------------------

local this = {}

--- Log a debug message related to a specific stack combinator
function this.dlog(sc, text)
  dlog("[SC:" .. sc.unit_number .."] " .. text, true)
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
  this.dlog(sc, "Adding to global list...")
  all_combinators[sc.unit_number] = { sc = sc, out = out }
  if not (global.config) then global.config = {} end
  if not (global.config[sc.unit_number]) then
    -- TODO: Use mod settings for default values
    cfg = { invert_red = false, invert_green = false }
    global.config[sc.unit_number] = cfg
    this.dlog(sc, "Combinator has no config, using defaults: " .. serpent.line(cfg))
  end
  this.dlog(sc, "Added to global list.")
end


return this