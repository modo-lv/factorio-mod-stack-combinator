--[[ Globals ]]
require("globals")

--[[ Libs ]]
local event = require("__flib__.event")

--[[ Scripts ]]
local entity = require("scripts.entity-events")
local gui = require("scripts.gui-events")
local runtime = require("scripts.runtime-events")
local mod_picker_dollies = require("scripts.mods.picker-dollies")

--[[ Scripts: Multiple handlers ]]
event.on_init(function(ev)
  mod_picker_dollies.init()
  entity.tick()
end)

event.on_load(function(ev)
  mod_picker_dollies.init()
end)

event.on_configuration_changed(function(ev) 
  entity.tick()
end)

event.on_tick(function(ev)
  entity.tick()
  runtime.tick(ev)
  gui.tick(ev)
end)

--[[ Scripts: GUI]]
event.on_gui_opened(gui.open)
event.on_gui_closed(gui.close)
event.on_gui_click(gui.clicked)
event.on_gui_checked_state_changed(gui.config)