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

------ Convert given tick or game.tick into "[hh:]mm:ss" format.
-- Copied from Factorio Library
-- (https://github.com/factoriolib/flib/blob/master/misc.lua),
-- because I'm not including a whole mod dependency for a single function.
-- @tparam[opt=game.ticks_played] number tick
-- @treturn string
local function ticks_to_timestring(tick)
  local total_seconds = math.floor((tick or game.ticks_played) / 60)
  local seconds = total_seconds % 60
  local minutes = math.floor(total_seconds / 60)
  if minutes > 59 then
    minutes = minutes % 60
    local hours = math.floor(total_seconds / 3600)
    return string.format("%d:%02d:%02d", hours, minutes, seconds)
  else
    return string.format("%02d:%02d", minutes, seconds)
  end
end

--- Log a message.
-- During startup, logs to the game log.
-- During runtime, logs to the game console & script log file
-- @tparam String message Message to send to the game log.
function Logger:log(message)
  if (Mod.runtime) then
    if not (self.output_file) then
      self.output_file = self.OUTPUT_FOLDER .. "/" .. Mod.runtime:game_id() .. ".log"
    end
    local time = ticks_to_timestring()
    --game.print({"framework-logger.console-format", time, Mod.NAME, Mod.runtime:game_id(), message})
    game.print("[" .. time .."] " .. self.MOD_TAG .." (" .. Mod.runtime:game_id() .. ") " .. message)
    local output = "[" .. time .. "] (" .. Mod.runtime:game_id() .. ") " .. message .. "\n"
    game.write_file(self.output_file, output, true)
  else
    log(message)
  end
end

function Logger:debug(message)
  if (Mod.settings:startup().debug_mode) then self:log(message) end
end

----------------------------------------------------------------------------------------------------

return Logger