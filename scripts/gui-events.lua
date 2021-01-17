--------------------------------------------------------------------------------
--- # GUI events: showing, hiding, interactions, etc.
--------------------------------------------------------------------------------

local event = require("__flib__.event")

local entity = require("entity-layout")
local gui = require("gui-layout")

local this = {}

--- Show the GUI when user opens the combinator
function this.open(ev)
  local sc = ev.entity
  if not (sc and sc.name == SC_ENTITY_NAME) then return end
  
  local player = game.get_player(ev.player_index)
  local window = gui.create(sc, player)

  -- Checkboxes
  event.on_gui_checked_state_changed(this.config)

  -- Closing by clicking on some other entity with a GUI, or pressing
  -- `Escape` or confirm button
  event.on_gui_closed(function(ev)
    if (not (e and e.name == gui.NAME)) then return end
    this.close(ev)
  end)

  -- Closing by clicking the `X` button
  event.on_gui_click(function(ev)
    local e = ev.element
    if (not (e and e.name == gui.CLOSE_BUTTON_NAME)) then return end
    this.close(ev)
  end)
end

--- Update combinator's settings when user has changed them
function this.config(ev)
  local el = ev.element
  if not (el and (el.name == gui.INVERT_RED_NAME or gui.INVERT_GREEN_NAME)) 
    then return end
  local id = global.open_sc.unit_number
  if (el.name == gui.INVERT_RED_NAME) then 
    global.config[id].invert_red = el.state 
  elseif (el.name == gui.INVERT_GREEN_NAME) then 
    global.config[id].invert_green = el.state 
  end
  entity.dlog(global.open_sc, "Combinator's settings are now: " .. serpent.line(global.config[id]))
end

--- Hide the GUI when its closed
function this.close(ev)
  local player = game.get_player(ev.player_index)
  gui.destroy(player)
  event.on_gui_checked_state_changed(nil)
  event.on_gui_closed(nil)
  event.on_gui_click(nil)
end

return this