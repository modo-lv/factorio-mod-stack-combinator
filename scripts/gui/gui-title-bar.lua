--------------------------------------------------------------------------------
--- # Title bar of the stack combinator GUI
--------------------------------------------------------------------------------

local StaCo = require("scripts/staco/staco")

--------------------------------------------------------------------------------

local GuiTitleBar = {
  close_button = nil,
}


function GuiTitleBar:create(sc, parent)
  local title_bar = parent.add { 
    type = "flow",
    direction = "horizontal"
  }
  title_bar.drag_target = parent

  -- Title text
  title_bar.add {
    type = "label",
    caption = { "entity-name." .. StaCo.NAME },
    style = "frame_title",
    ignored_by_interaction = true
  }

  -- Fill the space between title and close button
  local spacer = title_bar.add {
    type = "empty-widget",
    style = "draggable_space_header",
    ignored_by_interaction = true
  }
  spacer.style.horizontally_stretchable = true
  spacer.style.minimal_width = 16
  spacer.style.minimal_height = 24
  
  -- Close button
  self.close_button = title_bar.add {
    type = "sprite-button",
    style = "frame_action_button",
    sprite = "utility/close_white",
    hovered_sprite = "utility/close_black",
    clicked_sprite = "utility/close_black"
  }
end

--------------------------------------------------------------------------------

return GuiTitleBar