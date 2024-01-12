--------------------------------------------------------------------------------
--- # Mathematical operation selector of the stack combinator GUI
--------------------------------------------------------------------------------

local GuiInputOp = {
  selector = nil,
  description = nil,

  description_keys = {
    "multiply",
    "divide-ceil",
    "divide-floor",
    "round",
    "ceil",
    "floor",
  },

  item_names = {
    " *",
    " / ↑",
    " / ↓",
    "↕",
    "↑",
    "↓",
  }
}

function GuiInputOp:create(sc, parent)
  parent = parent.add {
    type = "flow",
    direction = "vertical"
  }
  parent.style.vertical_align = "center"
  parent.style.horizontal_align = "center"
  parent.style.horizontally_stretchable = true

  self.selector = parent.add {
    type = "drop-down",
    items = self.item_names,
    selected_index = sc.config.operation
  }
  self.selector.style.width = 70

  self.description = parent.add {
    type = "label",
  }
  self.description.style.horizontal_align = "center"
  self.description.style.width = 400
end

--------------------------------------------------------------------------------

return GuiInputOp