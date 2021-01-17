--------------------------------------------------------------------------------
--- # Mod settings
--------------------------------------------------------------------------------

local this = {}

--- Is debug mode enabled?
function this.debug_mode()
  return settings.global[MOD_NAME .. "-debug-mode"].value == true
end

--- Is an input set to be inverted by default?
function this.invert(color)
  local setting = settings.global[MOD_NAME .. "-defaults-invert"].value
  return setting == color or setting == "both"
end

return this