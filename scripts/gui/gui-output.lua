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
    local st = entry.signal.type == "virtual" and "virtual-signal" or entry.signal.type
    self.signal_table.add({
      type = "sprite-button",
      style = "compact_slot",
      number = entry.count,
      sprite = st .. "/" .. entry.signal.name,
      --enabled = false
    })
  end
end

function GuiOutput:create(parent)
  parent.add({
    type = "label",
    -- Built-in localisation
    caption = { "gui-constant.output-signals" },
    style = "heading_3_label"
  })

  local scroll_pane = parent.add({
    type = "scroll-pane",
    style = "naked_scroll_pane",
  })
  scroll_pane.style.minimal_height = 36
  scroll_pane.style.margin = 0
  scroll_pane.style.maximal_height = 36 * 4

  local flow = scroll_pane.add {
    type = "flow",
    direction = "horizontal"
  }
  flow.style.horizontal_align = "center"
  flow.style.horizontally_stretchable = true

  self.signal_table = flow.add {
    type = "table",
    style = "slot_table",
    column_count = 11
  }
end

return GuiOutput