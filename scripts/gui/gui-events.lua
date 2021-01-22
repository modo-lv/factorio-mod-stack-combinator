--------------------------------------------------------------------------------
--- # GUI events
-- Showing, hiding, interactions, etc.
--------------------------------------------------------------------------------

local _event = require('__stdlib__/stdlib/event/event')

local StaCo = require("staco")

--------------------------------------------------------------------------------

local GuiEvents = {}

--- Every tick updates (status & signals)
local function tick(ev)
  local sc = Mod.gui.staco
  Mod.gui.elements.status:tick(sc)
  Mod.gui.elements.output:tick(sc)
end


--- Show the GUI when user opens the combinator
local function open(ev)
  Mod.gui:create(
    Mod.runtime:sc(ev.entity),
    game.get_player(ev.player_index)
  )

  -- Tick
  _event.register(defines.events.on_tick, tick)
end

--- Update combinator's settings when user changes them
function GuiEvents.config(ev)
  local sc = Mod.gui.staco
  local el = ev.element
  if (el.name == Mod.gui.INVERT_RED_NAME) then 
    sc.config.invert_red = el.state
  elseif (el.name == Mod.gui.INVERT_GREEN_NAME) then 
    sc.config.invert_green = el.state 
  end
  sc.config:save()
end

--- Close GUI if user clicks the `X` button
function GuiEvents.click(ev)
  ev.element = Mod.gui.window
  GuiEvents.close(ev)
end

--- Remove the GUI when its closed
function GuiEvents.close(ev)
  Mod.gui:destroy(game.get_player(ev.player_index))

  _event.remove(defines.events.on_tick, tick)
end

--- Register handlers to their events
function GuiEvents.register_all()
  -- Open
  _event.register(defines.events.on_gui_opened, open, 
    function(ev) return ev.entity and ev.entity.name == StaCo.NAME end
  )

  -- Checkboxes
  _event.register(
    defines.events.on_gui_checked_state_changed,
    GuiEvents.config,
    function (ev)
      return ev.element and (
        ev.element.name == Mod.gui.INVERT_RED_NAME or 
        ev.element.name == Mod.gui.INVERT_GREEN_NAME
      )
    end
  )

  -- Click
  _event.register(
    defines.events.on_gui_click,
    GuiEvents.click,
    function(ev) 
      return ev.element and ev.element.name == Mod.gui.CLOSE_BUTTON_NAME
    end
  )

  -- Close
  _event.register(
    defines.events.on_gui_closed,
    GuiEvents.close,
    function (ev)
      return ev.element and ev.element.name == Mod.gui.NAME
    end
  )
end

--------------------------------------------------------------------------------

return GuiEvents