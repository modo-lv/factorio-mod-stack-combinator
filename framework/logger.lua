----------------------------------------------------------------------------------------------------

--- Logging
local Logger = {
  --- Folder where runtime output logs are stored
  OUTPUT_FOLDER = Mod.NAME .. "/logs",

  --- What to use as the identifier for the mod in console logs. Rich text & localisation supported.
  MOD_TAG = { Mod.NAME },

  --- File to write
  output_file = nil
}

----------------------------------------------------------------------------------------------------

--- Log a message.
-- During game runtime, logs to the game console & script log file
-- Otherwise, logs to the game log.
-- @tparam String message Message to send to the game log.
function Logger:log(message)
  log(message)
end

--- Log a message only if debug mode is enabled in startup settings.
-- @tparam String message Message to send to the game log.
function Logger:debug(message)
  if (Mod.settings:startup().debug_mode) then self:log(message) end
end

----------------------------------------------------------------------------------------------------

return Logger