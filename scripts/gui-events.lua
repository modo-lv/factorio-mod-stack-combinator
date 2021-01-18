--------------------------------------------------------------------------------
--- # GUI events: showing, hiding, interactions, etc.
--------------------------------------------------------------------------------

local entity = require("entity")
local sc_config = require("entity-config")
local table = require("__flib__.table")

local this = {
  --- The open GUI
  window = nil,
  status_names = {},

  gui = require("gui")
}

function this.tick(ev)
  local sc = global.open_sc
  if not (sc) then return end

  this.gui.elements.status.tick(sc)
  this.gui.elements.output.tick(sc)
end

--- Show the GUI when user opens the combinator
function this.open(ev)
  local sc = ev.entity
  if not (sc and sc.name == SC_ENTITY_NAME) then return end
  
  local player = game.get_player(ev.player_index)
  this.window = this.gui.create(sc, player)
end

--- Update combinator's settings when user has changed them
function this.config(ev)
  local el = ev.element
  if not (global.open_sc and el and (el.name == this.gui.INVERT_RED_NAME or this.gui.INVERT_GREEN_NAME)) 
    then return end
  local sc = global.open_sc

  local cfg = sc_config.from_combinator(sc)
  if (el.name == this.gui.INVERT_RED_NAME) then 
    cfg.invert_red = el.state
  elseif (el.name == this.gui.INVERT_GREEN_NAME) then 
    cfg.invert_green = el.state 
  end

  sc_config.to_combinator(sc, cfg)
  entity.dlog(sc, "Combinator's settings are now: " .. serpent.line(sc_config.from_combinator(sc)))
end

--- Close GUI if user clicks the `X` button
function this.clicked(ev)
  local e = ev.element
  if not (e and e.name == this.gui.CLOSE_BUTTON_NAME) then return end

  ev.element = this.window
  this.close(ev)
end

--- Remove the GUI when its closed
function this.close(ev)
  local el = ev.element
  if not (el and el.name == this.gui.NAME) then return end

  local player = game.get_player(ev.player_index)
  this.gui.destroy(player)
end

return this