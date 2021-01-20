--------------------------------------------------------------------------------
--- # Input (configuration)
--------------------------------------------------------------------------------

local this = {
  red = nil,
  green = nil,
}

function this.create(sc, parent, sc_config)
  parent.add {
    type = "label",
    style = "bold_label",
    -- Built-in localisation
    caption = {"gui-arithmetic.input"}
  }

  local row = parent.add {
    type = "table",
    direction = "horizontal",
    column_count = 2,
    tooltip = { "gui.invert-description" },
  }
  
  local cfg = sc_config.from_combinator(sc)

  this.red = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = (cfg and cfg.invert_red) == true,
    caption = { "", { "gui.invert-wire", "[item=red-wire]" } }
  }
  this.red.style.horizontally_stretchable = true
  this.red.style.horizontally_squashable = false

  this.green = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = (cfg and cfg.invert_green) == true,
    caption = { "", { "gui.invert-wire", "[item=green-wire]" } }
  }
  this.green.style.horizontally_stretchable = false
  this.green.style.horizontally_squashable = false

end

return this