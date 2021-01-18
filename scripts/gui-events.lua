--------------------------------------------------------------------------------
--- # GUI events: showing, hiding, interactions, etc.
--------------------------------------------------------------------------------

local entity = require("entity")
local gui = require("gui")
local sc_config = require("entity-config")

local this = {
  --- The open GUI
  window = nil
}

function this.tick(ev)
  local sc = global.open_sc
  local table = global.open_sc_table
  if not (sc and table) then return end

  table.clear()
  local out = all_combinators[sc.unit_number].out
  local signals = out.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.constant_combinator).signals

  if not (signals) then return end

  for _, entry in pairs(signals) do
		table.add({
			type = "sprite-button",
      style = "slot_button",
      number = entry.count,
      sprite = entry.signal.type .. "/" .. entry.signal.name
    })
    ::skip::
	end

end

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
  local sc = global.open_sc

  local cfg = sc_config.from_combinator(sc)
  if (el.name == gui.INVERT_RED_NAME) then 
    cfg.invert_red = el.state
  elseif (el.name == gui.INVERT_GREEN_NAME) then 
    cfg.invert_green = el.state 
  end

  sc_config.to_combinator(sc, cfg)
  entity.dlog(sc, "Combinator's settings are now: " .. serpent.line(sc_config.from_combinator(sc)))
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