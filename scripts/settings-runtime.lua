----------------------------------------------------------------------------------------------------
--- Runtime settings
local RuntimeSettings = {
  invert_signals = "none",

  default_staco_config = nil,
}

--- Create a new runtime setting object
function RuntimeSettings.new(settings)
  local rs = {}
  setmetatable(rs, { __index = RuntimeSettings })
  rs.invert_signals = settings and settings.invert_signals
  rs.default_staco_config = {
    invert_red = rs.invert_signals == "red" or rs.invert_signals == "both",
    invert_green = rs.invert_signals == "green" or rs.invert_signals == "both"
  }
  return rs
end

----------------------------------------------------------------------------------------------------
return RuntimeSettings