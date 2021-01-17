--[[ Globals ]]
require("globals")

--[[ Libs ]]
local event = require("__flib__.event")

--[[ Scripts: Building ]]
local entity_events = require("scripts.entity-events")
local filter = { { filter = "name", name = "stack-combinator" } }
event.on_built_entity(entity_events.create, filter)
event.on_robot_built_entity(entity_events.create, filter)
event.on_entity_cloned(entity_events.create, filter)
event.script_raised_built(entity_events.create, filter)
event.script_raised_revive(entity_events.create, filter)

--[[ Scripts: GUI]]
local gui_events = require("scripts.gui-events")
event.on_gui_opened(gui_events.open)

--local runtime_events = require("runtime-events")

--[[ Wiring ]]
-- event.on_tick(function(event) 
--   builder.tick(event)
--   runner.tick(event)
-- end)

-- 
-- event.on_gui_closed(gui.hide)
-- event.on_gui_click(gui.click)
-- event.on_gui_checked_state_changed(gui.checked)


-- event.on_player_mined_entity(builder.remove, filter)
-- event.on_robot_mined_entity(builder.remove, filter)
-- event.script_raised_destroy(builder.remove, filter)
-- event.on_entity_died(builder.remove, filter)