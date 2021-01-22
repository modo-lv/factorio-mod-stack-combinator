----------------------------------------------------------------------------------------------------

--- Logging
local Logging = {
  --- Folder where runtime output logs are stored
  OUTPUT_FOLDER = Mod.NAME .. "/logs",

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
-- Logs to the game console & script log file at runtime, and to the game log during startup.
-- @tparam LocalisedString message Message to send to the game log.
function Logging:log(message)
  if (Mod.runtime) then
    if not (self.output_file) then
      self.output_file = self.OUTPUT_FOLDER .. "/" .. Mod.runtime:game_id() .. ".log"
    end
    local time = ticks_to_timestring()
    game.print({"framework-logger.console-format", time, Mod.NAME, Mod.runtime:game_id(), message})
    local output = "[" .. time .. "] (" .. Mod.runtime:game_id() .. ") " .. message .. "\n"
    game.write_file(self.output_file, output, true)
  else
    log(message)
  end
end

--- Log a message only if debug mode is on.
-- @see Logging.log
function Logging:debug(message)
  if (Mod.settings:startup().debug_mode) then self:log(message) end
end

----------------------------------------------------------------------------------------------------

return Logging