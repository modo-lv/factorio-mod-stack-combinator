--------------------------------------------------------------------------------
--- # Output (signals)
--------------------------------------------------------------------------------

local this = {
  signal_table = nil
}

function this.tick(sc)
  if not (this.signal_table) then return end
  this.signal_table.clear()
  local out = all_combinators[sc.unit_number].out
  local signals = out.get_circuit_network(
    -- Color doesn't matter since output is connected to both cables.
    defines.wire_type.red,
    defines.circuit_connector_id.constant_combinator
  ).signals

  if not (signals) then return end

  for _, entry in pairs(signals) do
    this.signal_table.add({
      type = "sprite-button",
      style = "slot_button",
      number = entry.count,
      sprite = entry.signal.type .. "/" .. entry.signal.name,
      enabled = false
    })
    ::skip::
  end
end

function this.create(sc, parent, sc_config)
  parent.add({
    type = "label",
    -- Built-in localisation
    caption = {"gui-constant.output-signals"},
    style = "bold_label"
  })

  local scroll_pane = parent.add({
    type = "scroll-pane",
    style = "logistics_scroll_pane",
  })
  scroll_pane.style.minimal_height = 0
  scroll_pane.style.margin = 0
  
  this.signal_table = scroll_pane.add({
    type = "frame",
    style = "slot_button_deep_frame",
  }).add({
    type = "table",
    style = "slot_table",
    column_count = 10,
  })
end

return this