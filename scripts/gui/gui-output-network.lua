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
  table.style.column_alignments[1] = "left"
  table.style.column_alignments[2] = "right"

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

    local flow = pane.add {
      type = "flow",
      direction = "horizontal",
      maximum_horizontal_squash_size = 0,
    }
    flow.style.horizontally_stretchable = true
    flow.style.horizontal_align = color == "red" and "left" or "right"

    local scroll = flow.add {
      type = "scroll-pane",
      style = "naked_scroll_pane",
    }
    scroll.style.minimal_height = 36
    scroll.style.margin = 0
    scroll.style.maximal_height = 36 * 4
    scroll.style.padding = 0


    self[color] = scroll.add {
      type = "table",
      style = "slot_table",
      column_count = 5,
    }
    self[color].style.horizontally_squashable = true
  end

end

----------------------------------------------------------------------------------------------------

return GuiOutputNetwork