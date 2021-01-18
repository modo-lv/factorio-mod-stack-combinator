--------------------------------------------------------------------------------
--- # Title bar of the stack combinator GUI
--------------------------------------------------------------------------------

local this = {
  close_button = nil,
}

function this.create(sc, parent)
  local title_bar = parent.add { 
    type = "flow", direction = "horizontal"
  }
  title_bar.drag_target = parent

  -- Title text
  local title = title_bar.add {
    type = "label",
    caption = {"", {"entity-name." .. SC_ENTITY_NAME}, " " , sc.unit_number},
    style = "frame_title",
    ignored_by_interaction = true
  }

  -- Fill the space between title and close button
  local spacer = title_bar.add {
    type = "empty-widget",
    style = "draggable_space",
    ignored_by_interaction = true
  }
  spacer.style.horizontally_stretchable = true
  spacer.style.minimal_width = 16
  spacer.style.minimal_height = 24
  
  -- Close button
  this.close_button = title_bar.add {
    type = "sprite-button",
    style = "frame_action_button",
    sprite = "utility/close_white",
    hovered_sprite = "utility/close_black",
    clicked_sprite = "utility/close_black"
  }
end

return this