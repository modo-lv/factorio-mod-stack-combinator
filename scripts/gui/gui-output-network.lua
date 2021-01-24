----------------------------------------------------------------------------------------------------
--- GUI elements showing signals on the output circuit networks
----------------------------------------------------------------------------------------------------

local GuiOutputNetwork = {
  red = nil,
  green = nil,
}

function GuiOutputNetwork:tick(sc)
  for _, color in ipairs { "red", "green" } do
    self[color].clear()
    local control = sc.output.get_control_behavior(defines.wire_type[color])
    local network = control.get_circuit_network(defines.wire_type[color])
    for _, signal in ipairs(network.signals or { }) do
      self[color].add {
        type = "sprite-button",
        sprite = signal.signal.type .. "/" .. signal.signal.name,
        number = signal.count,
        style = color .. "_circuit_network_content_slot",
      }
    end
    :: next ::
  end
end

function GuiOutputNetwork:create(parent)
  parent.add {
    type = "label",
    style = "heading_3_label",
    caption = { "", { "gui.output-networks" }, " [img=info]" },
    tooltip = { "gui.output-networks-description" }
  }

  local table = parent.add {
    type = "table",
    column_count = 2,
    tooltip = { "gui.output-networks-description" }
  }

  -- Red
  for _, color in ipairs { "red", "green" } do

    local pane = table.add {
      type = "flow",
      direction = "vertical",
    }
    pane.style.horizontal_align = color == "red" and "left" or "right"
    pane.add {
      type = "label",
      style = "heading_3_label_yellow",
      caption = { "gui.output-network", "[item="..color.."-wire]"},
    }

    local scroll = pane.add {
      type = "scroll-pane",
      style = "logistics_scroll_pane",
    }
    scroll.style.minimal_height = 0
    scroll.style.margin = 0
    scroll.style.maximal_height = 36 * 4

    self[color] = scroll.add {
      type = "table",
      style = "slot_table",
      column_count = 5,
    }
  end

end

----------------------------------------------------------------------------------------------------

return GuiOutputNetwork