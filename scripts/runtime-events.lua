--------------------------------------------------------------------------------
--- # Main combinator running events
--------------------------------------------------------------------------------

local sc_config = require("entity-config")
local mod_config = require("mod-config")
local runtime = require("runtime")

local this = {}

--- Run on every tick
function this.tick(ev)
  if not (global.all_combinators) then return end
  for _, entity in pairs(global.all_combinators) do
    local sc, out = entity.sc, entity.out
    if not (sc and sc.valid) then goto next end
    if not (out and out.valid) then 
      error("Stack combinator " .. sc.unit_number .. " (at {" .. sc.position.x .. ", " .. sc.position.y .. "} on " .. sc.surface.name  .. ") has no output!") 
    end

    local input = sc.get_control_behavior()
    local output = out.get_control_behavior()

    -- No power
    if (sc.status == defines.entity_status.no_power) then 
      output.parameters = {}
      goto next 
    end

    runtime.process(sc, input, output)
    
    ::next::
  end
end

return this