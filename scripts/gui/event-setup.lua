local events = require('__stdlib__/stdlib/event/event')

----------------------------------------------------------------------------------------------------
--- # GUI events
-- Showing, hiding, interactions, etc.
----------------------------------------------------------------------------------------------------

local GuiEvents = {}

--- Every tick updates (status & signals)
local function tick()
  local sc = This.gui.staco
  This.gui.elements.status:tick(sc)
  This.gui.elements.output:tick(sc)
end

--- Show the GUI when user opens the combinator
local function open(ev)
  This.gui:create(
    This.runtime:sc(ev.entity),
    game.get_player(ev.player_index)
  )
  -- Enable real-time updates
  events.register(defines.events.on_tick, tick)
end

--- Update combinator's settings when user changes them
local function config(ev)
  local sc = This.gui.staco
  local el = ev.element
  if (el.name == This.gui.INVERT_RED_NAME) then
    sc.config.invert_red = el.state
  elseif (el.name == This.gui.INVERT_GREEN_NAME) then
    sc.config.invert_green = el.state
  end
  sc.config:save()
end

--- Remove the GUI when its closed
local function close(ev)
  This.gui:destroy(game.get_player(ev.player_index))
  -- Disable real-time updates
  events.remove(defines.events.on_tick, tick)
end

--- Close GUI if user clicks the `X` button
local function click(ev)
  ev.element = This.gui.window
  close(ev)
end

----------------------------------------------------------------------------------------------------

--- Register handlers to their events
function GuiEvents.register_all()
  -- Open
  events.register(defines.events.on_gui_opened, open,
    function(ev) return ev.entity and ev.entity.name == This.StaCo.NAME end
  )

  -- Checkboxes
  events.register(defines.events.on_gui_checked_state_changed, config,
    function(ev)
      return ev.element and (
        ev.element.name == This.gui.INVERT_RED_NAME or
          ev.element.name == This.gui.INVERT_GREEN_NAME
      )
    end
  )

  -- Click
  events.register(defines.events.on_gui_click, click,
    function(ev) return ev.element and ev.element.name == This.gui.CLOSE_BUTTON_NAME end
  )

  -- Close
  events.register(defines.events.on_gui_closed, close,
    function(ev) return ev.element and ev.element.name == This.gui.NAME end
  )
end

----------------------------------------------------------------------------------------------------

return GuiEvents