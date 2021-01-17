--------------------------------------------------------------------------------
--- # GUI events: showing, hiding, interactions, etc.
--------------------------------------------------------------------------------

local entity = require("entity")
local gui = require("gui")

local this = {
  --- The open GUI
  window = nil
}

--- Show the GUI when user opens the combinator
function this.open(ev)
  local sc = ev.entity
  if not (sc and sc.name == SC_ENTITY_NAME) then return end
  
  local player = game.get_player(ev.player_index)
  this.window = gui.create(sc, player)
end

--- Update combinator's settings when user has changed them
function this.config(ev)
  local el = ev.element
  if not (global.open_sc and el and (el.name == gui.INVERT_RED_NAME or gui.INVERT_GREEN_NAME)) 
    then return end
  local id = global.open_sc.unit_number
  if (el.name == gui.INVERT_RED_NAME) then 
    global.config[id].invert_red = el.state 
  elseif (el.name == gui.INVERT_GREEN_NAME) then 
    global.config[id].invert_green = el.state 
  end
  entity.dlog(global.open_sc, "Combinator's settings are now: " .. serpent.line(global.config[id]))
end

--- Close GUI if user clicks the `X` button
function this.clicked(ev)
  local e = ev.element
  if not (e and e.name == gui.CLOSE_BUTTON_NAME) then return end

  ev.element = this.window
  this.close(ev)
end

--- Remove the GUI when its closed
function this.close(ev)
  local el = ev.element
  if not (el and el.name == gui.NAME) then return end

  local player = game.get_player(ev.player_index)
  gui.destroy(player)
end

return this