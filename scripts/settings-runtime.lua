----------------------------------------------------------------------------------------------------
--- Runtime settings
local RuntimeSettings = {
  invert_signals = { Mod.NAME .. "-defaults-invert", "none" },
}

--- Default
function RuntimeSettings:staco_defaults()
  return {
    invert_red = self.invert_signals == "red" or self.invert_signals == "both",
    invert_green = self.invert_signals == "green" or self.invert_signals == "both"
  }
end

----------------------------------------------------------------------------------------------------
return RuntimeSettings