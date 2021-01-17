--[[ Globals ]]
require("globals")

--[[ Libs ]]
local event = require("__flib__.event")

--[[ Scripts ]]
local entity = require("scripts.entity-events")
local gui = require("scripts.gui-events")
local runtime = require("scripts.runtime-events")

--[[ Scripts: Multiple handlers ]]
event.on_tick(function(ev)
  entity.tick(ev)
  runtime.tick(ev)
end)


--[[ Scripts: Building ]]
local filter = { { filter = "name", name = SC_ENTITY_NAME } }
-- Creation
event.on_built_entity(entity.create, filter)
event.on_robot_built_entity(entity.create, filter)
event.on_entity_cloned(entity.create, filter)
event.script_raised_built(entity.create, filter)
event.script_raised_revive(entity.create, filter)
-- Removal
event.on_player_mined_entity(entity.destroy, filter)
event.on_robot_mined_entity(entity.destroy, filter)
event.script_raised_destroy(entity.destroy, filter)
event.on_entity_died(entity.destroy, filter)
-- Chunk/surface removal
event.on_chunk_deleted(entity.purge_missing)
event.on_surface_cleared(entity.purge_missing)
event.on_surface_deleted(entity.purge_missing)


--[[ Scripts: GUI]]
event.on_gui_opened(gui.open)
event.on_gui_closed(gui.close)
event.on_gui_click(gui.clicked)
event.on_gui_checked_state_changed(gui.config)