--------------------------------------------------------------------------------
--- # Debugging features
--------------------------------------------------------------------------------
-- Global imports
local _event = require('__stdlib__/stdlib/event/event')

local Debug = {
  --- Where to write the debug logs (relative to ~/factorio/script-output)
  OUTPUT_FOLDER = Mod.NAME .. "/logs",

  --- File to write the debug log to
  output_file = nil,
}


--- Print to console and debug log file
-- @param [LocalisedString] message Text to output.
function Debug:log(message)
  if not (Mod.settings.is_debug) then return end

  -- Set the file name
  if not (self.output_file) then
    self.output_file = Mod.debug.OUTPUT_FOLDER .. "/" .. Mod.game_id() .. "_debug.log"
  end  

  -- Print
  -- local time = self.tiks_to_timestring()
  -- local name = Mod.NAME
  -- local game_id = Mod.game_id()
  -- local prefix = "[" .. Mod.game_id() .. " - " ..   .. "] "
  -- local output = prefix .. message
  local time = self:tiks_to_timestring()
  Game.print({"debug.log-format", time, Mod.NAME, Mod:game_id(), message})

  local output = "[" .. time .. "] (" .. Mod:game_id() .. ") " .. message .. "\n"
  Game.write_file(self.output_file, output, true)
end


--- Convert given tick or game.tick into "[hh:]mm:ss" format.
-- Copied from Factorio Library
-- (https://github.com/factoriolib/flib/blob/master/misc.lua),
-- because I'm not including a whole mod dependency for a single function.
-- @tparam[opt=game.ticks_played] number tick
-- @treturn string
function Debug:tiks_to_timestring(tick)
  local total_seconds = math.floor((tick or Game.ticks_played) / 60)
  local seconds = total_seconds % 60
  local minutes = math.floor(total_seconds / 60)
  if minutes > 59 then
    minutes = minutes % 60
    local hours = math.floor(total_seconds / 3600)
    return string.format("%d:%02d:%02d", hours, minutes, seconds)
  else
    return string.format("%d:%02d", minutes, seconds)
  end
end


--------------------------------------------------------------------------------
return Debug