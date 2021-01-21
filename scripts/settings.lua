--------------------------------------------------------------------------------
--- # Mod runtime settings
-- @type ModSettings
--------------------------------------------------------------------------------

-- Global imports
local _settings = settings

---
local ModSettings = {
  DEFAULTS_INVERT = Mod.NAME .. "-defaults-invert",

  loaded = false,

  --- Is debug mode enabled?
  is_debug = false,

  --- Default configuration for new stack combinators
  default_config = { invert_red = false, invert_green = false }
}

--- Load settings from the game
function ModSettings:load(force)
  if (loaded and not force) then return end
  self.is_debug = _settings.global[Mod.NAME .. "-debug-mode"].value == true
  local invert = _settings.global[self.DEFAULTS_INVERT].value
  self.default_config = { 
    invert_red = invert == "red" or invert == "both",
    invert_green = invert == "green" or invert == "both"
  }
  self.loaded = true
  Mod.debug:log("Settings loaded.")
  return self
end


--------------------------------------------------------------------------------
return ModSettings