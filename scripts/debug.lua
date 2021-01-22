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
--- @param message LocalisedString Test
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
  game.print({"debug.console-format", time, Mod.NAME, Mod:game_id(), message})

  local output = "[" .. time .. "] (" .. Mod:game_id() .. ") " .. message .. "\n"
  game.write_file(self.output_file, output, true)
end





--------------------------------------------------------------------------------
return Debug