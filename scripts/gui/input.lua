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
    --style = "control_settings_section_frame"
    --style = "entity_frame"
    tooltip = {"gui.invert-description"},
  }
  row.style.horizontally_stretchable = true

  local cfg = sc_config.from_combinator(sc)

  this.red = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = (cfg and cfg.invert_red) == true,
    caption = {"gui.invert-red"}
  }
  this.red.style.horizontally_stretchable = true

  this.green = row.add {
    type = "checkbox",
    tooltip = {"gui.invert-description"},
    state = (cfg and cfg.invert_red) == true,
    caption = {"gui.invert-green"}
  }
  this.red.style.horizontally_stretchable = true

end

return this