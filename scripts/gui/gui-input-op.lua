--------------------------------------------------------------------------------
--- # Mathematical operation selector of the stack combinator GUI
--------------------------------------------------------------------------------

local GuiInputOp = {
  selector = nil,
  description = nil,

  description_keys = {
    "multiply",
    "divide",
    "round",
    "ceil",
    "floor",
  },

  item_names = {
    " *",
    " /",
    "↕",
    "↑",
    "↓",
  }
}

function GuiInputOp:create(sc, parent)
  parent = parent.add {
    type = "flow",
    direction = "horizontal"
  }
  parent.style.vertical_align = "center"

  self.selector = parent.add {
    type = "drop-down",
    items = self.item_names,
    selected_index = sc.config.operation
  }
  self.selector.style.width = 60


  self.description = parent.add {
    type = "label",
  }
end

--------------------------------------------------------------------------------

return GuiInputOp