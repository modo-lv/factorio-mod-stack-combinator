----------------------------------------------------------------------------------------------------
--- GUI elements showing signals on the circuit networks
----------------------------------------------------------------------------------------------------

local GuiCircuitSignals = {
  red = nil,
  green = nil,
  input = false,
  connector_id = nil,
}

function GuiCircuitSignals:tick(sc)
  for _, color in ipairs { "red", "green" } do
    self[color].clear()
    local control = (self.input and sc.input or sc.output).get_control_behavior(defines.wire_type[color])
    local network = control.get_circuit_network(defines.wire_type[color], self.connector_id)
    -- If the wires between input & output have been cut, restore them.
    if not self.input and not network then
      sc:connect()
      network = control.get_circuit_network(defines.wire_type[color])
    end
    if network then
      for _, signal in ipairs(network.signals or { }) do
        local st = signal.signal.type == "virtual" and "virtual-signal" or signal.signal.type

        self[color].add {
          type = "sprite-button",
          sprite = st .. "/" .. signal.signal.name,
          number = signal.count,
          style = color .. "_circuit_network_content_slot",
        }
      end
    end
  end
end

function GuiCircuitSignals:create(input, parent)
  self.input = input
  self.connector_id = input
    and defines.circuit_connector_id.combinator_input
    or defines.circuit_connector_id.constant_combinator
  local key = input and "input" or "output"

  parent.add {
    type = "label",
    style = "heading_3_label",
    caption = { "", { "gui." .. key .. "-networks" }, " [img=info]" },
    tooltip = { "gui." .. key .. "-networks-description" }
  }

  local table = parent.add {
    type = "table",
    column_count = 2,
    tooltip = { "gui." .. key .. "-networks-description" }
  }
  table.style.column_alignments[1] = "left"
  table.style.column_alignments[2] = "right"

  local spacing = 36 / 4
  for _, color in ipairs { "red", "green" } do
    local block = table.add {
      type = "flow",
      direction = "horizontal",
      maximum_horizontal_squash_size = 0,
    }
    block.style.horizontally_stretchable = true
    block.style.horizontal_align = color == "red" and "left" or "right"
    block.style.margin = {0, (color == "red" and spacing or 0), 0, (color == "green" and spacing or 0)}
    block.style.width = 36 * 7

    local scroll = block.add {
      type = "scroll-pane",
      style = "naked_scroll_pane",
      vertical_scroll_policy = "never",
      horizontal_scroll_policy = "auto-and-reserve-space",
    }
    scroll.style.margin = 0
    scroll.style.padding = 0

    self[color] = scroll.add {
      type = "table",
      style = "slot_table",
      vertical_centering = false,
      column_count = Mod.settings:startup().signal_capacity,
    }
    self[color].style.horizontally_squashable = true
  end

end

----------------------------------------------------------------------------------------------------

return GuiCircuitSignals