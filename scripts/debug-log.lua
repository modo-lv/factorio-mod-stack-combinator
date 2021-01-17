--------------------------------------------------------------------------------
--- # Debug logging
--------------------------------------------------------------------------------

local misc = require("__flib__.misc")
local event = require("__flib__.event")
local config = require("settings")

local this = {
  OUTPUT_FOLDER = MOD_NAME .. "/logs",
}
this.output_file = this.OUTPUT_FOLDER .. "/debug.log"

--- Print to console and debug log file
function this.print(text, without_space)
  if not (config.debug_mode()) then return end

  -- Set an ID if we don't have one
  if not (global.dlog_id and global.dlog_id > 0) then
    global.dlog_id = event.generate_id()
    this.output_file = this.OUTPUT_FOLDER .. "/" .. global.dlog_id .. "_debug.log"
  end

  local id = "[" .. global.dlog_id .. "]"
  local time = "[" .. game.ticks_played .. " (" .. misc.ticks_to_timestring() .. ")]"
  if not (without_space) then
    text = " " .. text
  end
  local output = id .. time .. text
  game.print({"debug.print", {"main.mod-name"}, output})
  game.write_file(this.output_file, output .. "\n", true)
end


return this