--------------------------------------------------------------------------------
--- # Mod runtime settings
-- @type ModSettings
--------------------------------------------------------------------------------

--- Default inversion setting name
local DEFAULTS_INVERT = Mod.NAME .. "-defaults-invert"
local DEBUG_MODE = Mod.NAME .. "-debug-mode"

--- Have settings been loaded from game's configuration into mod runtime?
local loaded = false

local ModSettings = {
  --- Is debug mode enabled?
  is_debug = false,

  --- Default configuration for new stack combinators
  default_config = { invert_red = false, invert_green = false }
}

--- Load settings from the game
-- @tparam Boolean force Reload settings if they've been loaded before?
function ModSettings:load(force)
  if (loaded and not force) then return end

  self.is_debug = Settings.global[DEBUG_MODE].value == true
  local invert = Settings.global[DEFAULTS_INVERT].value
  local prefix = (loaded and force) and "re" or ""
  self.default_config = { 
    invert_red = invert == "red" or invert == "both",
    invert_green = invert == "green" or invert == "both"
  }
  loaded = true
  Mod.debug:log("Settings "..prefix.."loaded.")

  return self
end


--------------------------------------------------------------------------------
return ModSettings