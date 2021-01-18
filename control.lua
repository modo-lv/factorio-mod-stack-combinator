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

--[[ Scripts: Building ]]
local filter = { { filter = "name", name = SC_ENTITY_NAME } }
-- Creation
event.on_built_entity(entity.create, filter)
event.on_robot_built_entity(entity.create, filter)
event.on_entity_cloned(entity.create, filter)
event.script_raised_built(entity.create, filter)
event.script_raised_revive(entity.create, filter)
-- Rotation
event.on_player_rotated_entity(entity.rotate)
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