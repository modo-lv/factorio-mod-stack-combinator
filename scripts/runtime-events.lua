--------------------------------------------------------------------------------
--- # Main combinator running events
--------------------------------------------------------------------------------

local runtime = require("runtime")

local this = {}

--- Run on every tick
function this.tick(ev) 
  if not (all_combinators) then return end
  for _, entity in pairs(all_combinators) do
    local sc, out = entity.sc, entity.out
    if not (sc and sc.valid) then goto next end
    if not (out and out.valid) then 
      error("Stack combinator " .. sc.unit_number .. " (at {" .. sc.position.x .. ", " .. sc.position.y .. "} on " .. sc.surface.name  .. ") has no output!") 
    end

    local input = sc.get_control_behavior()
    local output = out.get_control_behavior()
    local config = global.config[sc.unit_number]
    if not (config) then
      dlog("⚠️ Stack combinator " .. sc.unit_number .. " has no configuration despite being in the combinator list! Setting to defaults.")
      -- TODO: Use mod settings
      global.config[sc.unit_number] = { invert_red = false, invert_green = false }
    end

    runtime.process(config, input, output)
    
    ::next::
  end
end

return this