-- Mod globals
all_placed = all_placed or nil
signal_space_warning = signal_space_warning or nil

-- Main combinator logic
local runner = {}
local this = runner

function runner.tick(event)
  if (not all_placed) then return end
  for _, placed in pairs(all_placed) do
    local sc, out = placed.sc, placed.out
    if (not sc or not sc.valid) then goto next end

    local input = sc.get_control_behavior()
    local output = out.get_control_behavior()

    local red = input.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.combinator_input)
    local green = input.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.combinator_input)
   
    local result = {}
    this.stackify(red, result)
    this.stackify(green, result)
    
    -- If the result is bigger than the combinator output, warn the user
    if (#result > output.signals_count) then
      signal_space_warning = true
    end
    
    local i = 1
    for _, entry in pairs(result) do
      entry.index = i
      i = i + 1
    end
    
    output.parameters = result
    ::next::
  end
end

-- Stackify items in a set of signals and add them to the result list
function runner.stackify(circuit_network, result)
  if (not circuit_network or not circuit_network.signals) then return end
    
  for index, entry in ipairs(circuit_network.signals) do
    local type = entry.signal.type
    -- Non-item signals remain unchanged
    local stack = entry.count
    if (type == "item") then
      stack = stack * game.item_prototypes[entry.signal.name].stack_size
    end
    
    if (not result[type]) then
      result[type] = { signal = entry.signal, count = stack }
    end
    result[type].count = result[type].count + stack
  end
end

return runner