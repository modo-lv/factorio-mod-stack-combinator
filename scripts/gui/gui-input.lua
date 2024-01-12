--------------------------------------------------------------------------------
--- # Input (configuration)
--------------------------------------------------------------------------------

local GuiInput = {
  red = nil,
  green = nil,
  combine_first = nil,
}

function GuiInput:create(sc, parent)
  local row = parent.add {
    type = "table",
    direction = "horizontal",
    column_count = 3
  }

  GuiInput.red = row.add {
    type = "checkbox",
    tooltip = { "gui.invert-description" },
    state = sc.config.invert_red,
    caption = { "", { "gui.invert-wire", "[item=red-wire]" }, " [img=info]" }
  }
  GuiInput.red.style.horizontally_squashable = false

  local combineContainer = row.add {
    type = "flow",
    direction = "horizontal"
  }
  combineContainer.style.horizontal_align = "center"
  combineContainer.style.horizontally_squashable = true
  combineContainer.style.horizontally_stretchable = true
  combineContainer.style.margin = {0, 20}

  self.combine_first = combineContainer.add {
    type = "checkbox",
    caption = { "", { "gui.input-combine-first" } },
    tooltip = { "", { "gui.input-combine-first-description", "[item=red-wire]", "[item=green-wire]" } },
    state = false,
  }

  GuiInput.green = row.add {
    type = "checkbox",
    tooltip = { "gui.invert-description" },
    state = sc.config.invert_green,
    caption = { "", { "gui.invert-wire", "[item=green-wire]" }, " [img=info]" }
  }
  GuiInput.green.style.horizontally_squashable = false

end

--------------------------------------------------------------------------------

return GuiInput