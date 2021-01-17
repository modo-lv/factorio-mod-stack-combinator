--------------------------------------------------------------------------------
--- # Mod settings
--------------------------------------------------------------------------------

local this = {}

function this.debug_mode()
  return settings.global[MOD_NAME .. "-debug-mode"].value == true
end

return this