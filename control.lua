--[[ Libs ]]
local event = require("__flib__.event")

--[[ List of all Stack Combinators placed on the map ]]
all_placed = nil

--[[ Scripts ]]
local builder = require("scripts.builder")
local runner = require("scripts.runner")
local gui = require("scripts.gui")

--[[ Wiring ]]

event.on_tick(function(event) 
  builder.tick(event)
  runner.tick(event)
end)

event.on_gui_opened(gui.show)
event.on_gui_closed(gui.hide)
event.on_gui_click(gui.click)
event.on_gui_checked_state_changed(gui.checked)

local filter = { { filter = "name", name = "stack-combinator" } }
event.on_built_entity(builder.place, filter)
event.on_robot_built_entity(builder.place, filter)
event.script_raised_built(builder.place, filter)

event.on_player_mined_entity(builder.remove, filter)
event.on_robot_mined_entity(builder.remove, filter)
event.script_raised_destroy(builder.remove, filter)
event.on_entity_died(builder.remove, filter)