--------------------------------------------------------------------------------
--- # Input (configuration)
--------------------------------------------------------------------------------

local GuiInput = {
  red = nil,
  green = nil,
}

function GuiInput:create(sc, parent)
  parent.add {
    type = "label",
    style = "heading_3_label",
    -- Built-in localisation
    caption = { "gui-arithmetic.input" }
  }

  local row = parent.add {
    type = "table",
    direction = "horizontal",
    column_count = 2,
    tooltip = { "gui.invert-description" },
  }
  
  GuiInput.red = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = sc.config.invert_red,
    caption = { "", { "gui.invert-wire", "[item=red-wire]" } }
  }
  GuiInput.red.style.horizontally_stretchable = true
  GuiInput.red.style.horizontally_squashable = false

  GuiInput.green = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = sc.config.invert_green,
    caption = { "", { "gui.invert-wire", "[item=green-wire]" } }
  }
  GuiInput.green.style.horizontally_stretchable = false
  GuiInput.green.style.horizontally_squashable = false

end

--------------------------------------------------------------------------------

return GuiInput