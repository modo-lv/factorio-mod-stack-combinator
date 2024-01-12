--------------------------------------------------------------------------------
--- # Input (configuration)
--------------------------------------------------------------------------------

local GuiInput = {
  red = nil,
  green = nil,
}

function GuiInput:create(sc, parent)
  local row = parent.add {
    type = "table",
    direction = "horizontal",
    column_count = 3,
    tooltip = { "gui.invert-description" },
  }

  GuiInput.red = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = sc.config.invert_red,
    caption = { "", { "gui.invert-wire", "[item=red-wire]" }, " [img=info]" }
  }
  GuiInput.red.style.horizontally_squashable = false

  local spacer = row.add {
    type = "label"
  }
  spacer.style.horizontally_squashable = false
  spacer.style.horizontally_stretchable = true

  GuiInput.green = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = sc.config.invert_green,
    caption = { "", { "gui.invert-wire", "[item=green-wire]" }, " [img=info]" }
  }
  GuiInput.green.style.horizontally_squashable = false

end

--------------------------------------------------------------------------------

return GuiInput