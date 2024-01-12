----------------------------------------------------------------------------------------------------
--- Output (signals)
----------------------------------------------------------------------------------------------------

local GuiOutput = {
  signal_table = nil
}

function GuiOutput:tick(sc)
  if not (self.signal_table) then return end
  self.signal_table.clear()
  local signals = sc.output.get_control_behavior().parameters

  if not (signals) then return end

  for _, entry in pairs(signals) do
    if not (entry.signal.name) then goto next end
    local st = entry.signal.type == "virtual" and "virtual-signal" or entry.signal.type
    self.signal_table.add({
      type = "sprite-button",
      style = "compact_slot",
      number = entry.count,
      sprite = st .. "/" .. entry.signal.name
      --enabled = false
    })
    ::next::
  end
end

function GuiOutput:create(parent)
  parent.add({
    type = "label",
    -- Built-in localisation
    caption = { "", { "gui-constant.output-signals" }, " [img=info]" },
    tooltip = { "gui.output-signals-description" },
    style = "heading_3_label"
  })

  local scroll_pane = parent.add({
    type = "scroll-pane",
    style = "naked_scroll_pane",
    vertical_scroll_policy = "never",
    horizontal_scroll_policy = "auto-and-reserve-space",
  })
  scroll_pane.style.margin = 0
  scroll_pane.style.horizontally_stretchable = true

  local flow = scroll_pane.add {
    type = "flow",
    direction = "horizontal"
  }
  flow.style.horizontal_align = "center"
  flow.style.horizontally_stretchable = true
  flow.style.horizontally_squashable = true

  self.signal_table = flow.add {
    type = "table",
    style = "slot_table",
    column_count = Mod.settings:startup().signal_capacity
  }
  flow.style.horizontally_squashable = true
end

return GuiOutput