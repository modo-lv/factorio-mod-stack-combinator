local events = require('__stdlib__/stdlib/event/event')

----------------------------------------------------------------------------------------------------
--- # GUI events
-- Showing, hiding, interactions, etc.
----------------------------------------------------------------------------------------------------

local GuiEvents = {}

--- Every tick updates (status & signals)
local function tick()
  This.gui:tick()
end

--- Update combinator's settings when user changes them
local function config(ev)
  local sc = This.gui.staco
  local el = ev.element
  local save = false
  if (el and el.name == This.gui.INVERT_RED_NAME) then
    sc.config.invert_red = el.state
    save = true
  elseif (el and el.name == This.gui.INVERT_GREEN_NAME) then
    sc.config.invert_green = el.state
    save = true
  end

  -- Update op description
  local op = This.gui.elements.input_op
  op.description.caption = {
    "gui.input-op-" .. op.description_keys[op.selector.selected_index]
  }

  -- Update op selection
  if (el and el.name == This.gui.INPUT_OP_NAME) then
    sc.config.operation = el.selected_index
    save = true
  end

  if (save) then
    sc.config:save()
  end
end

--- Show the GUI when user opens the combinator
local function open(ev)
  This.gui:create(
    This.runtime:sc(ev.entity),
    game.get_player(ev.player_index)
  )

  config({})

  -- Enable real-time updates
  events.on_nth_tick(-10, tick)
end

--- Remove the GUI when its closed
local function close(ev)
  This.gui:destroy(game.get_player(ev.player_index))
  -- Disable real-time updates
  --events.remove(defines.events.on_tick, tick)
  events.remove(-10, tick)
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
    function(ev)
      return ev.entity and ev.entity.name == This.StaCo.NAME
    end
  )

  -- Checkboxes & drop-down
  events.register(
    {
      defines.events.on_gui_checked_state_changed,
      defines.events.on_gui_selection_state_changed
    },
    config,
    function(ev)
      return ev.element and (
        ev.element.name == This.gui.INVERT_RED_NAME or
          ev.element.name == This.gui.INVERT_GREEN_NAME or
          ev.element.name == This.gui.INPUT_OP_NAME
      )
    end
  )

  -- Click
  events.register(defines.events.on_gui_click, click,
    function(ev)
      return ev.element and ev.element.name == This.gui.CLOSE_BUTTON_NAME
    end
  )

  -- Close
  events.register(defines.events.on_gui_closed, close,
    function(ev)
      return ev.element and ev.element.name == This.gui.NAME
    end
  )
end

----------------------------------------------------------------------------------------------------

return GuiEvents