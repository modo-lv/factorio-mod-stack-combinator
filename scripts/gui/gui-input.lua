--------------------------------------------------------------------------------
--- # Input (configuration)
--------------------------------------------------------------------------------

local GuiInput = {
  red = nil,
  green = nil,
  merge_inputs = nil,
  wagon_stacks = nil,
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

  local mergeContainer = row.add {
    type = "flow",
    direction = "horizontal"
  }
  mergeContainer.style.horizontal_align = "center"
  mergeContainer.style.horizontally_squashable = true
  mergeContainer.style.horizontally_stretchable = true
  mergeContainer.style.margin = {0, 20}

  GuiInput.merge_inputs = mergeContainer.add {
    type = "checkbox",
    caption = { "", { "gui.input-merge-first" } },
    tooltip = { "", { "gui.input-merge-first-description", "[item=red-wire]", "[item=green-wire]" } },
    state = sc.config.merge_inputs,
  }

  GuiInput.green = row.add {
    type = "checkbox",
    tooltip = { "gui.invert-description" },
    state = sc.config.invert_green,
    caption = { "", { "gui.invert-wire", "[item=green-wire]" }, " [img=info]" }
  }
  GuiInput.green.style.horizontally_squashable = false

  -- Second row of options
  row = parent.add {
    type = "flow",
    direction = "horizontal"
  }
  row.style.horizontally_stretchable = true
  row.style.horizontal_align = "center"

  GuiInput.wagon_stacks = row.add {
    type = "checkbox",
    caption = { "", { "gui.input-wagon-stacks" }, " [img=info]" },
    tooltip = { "", { "gui.input-wagon-stacks-description" } },
    state = sc.config.wagon_stacks,
  }
end

--------------------------------------------------------------------------------

return GuiInput