local table = require('__stdlib__/stdlib/utils/table')

----------------------------------------------------------------------------------------------------
--- # Entity status indicator of the stack combinator GUI
----------------------------------------------------------------------------------------------------

local GuiStatusLabel = {
  STATUS_SPRITES = nil,
  STATUS_NAMES = nil,

  indicator = nil,
  text = nil,
}

--- Update status indicator on every tick
function GuiStatusLabel:tick(sc)
  if (This.runtime.signal_overflows and This.runtime.signal_overflows[sc.id]) then
    self.indicator.sprite = "utility/status_not_working"
    self.text.caption = { "gui.signal-overflow-status" }
    self.text.tooltip = This.runtime.signal_overflows[sc.id]
  else
    self.indicator.sprite = "utility/" .. self.STATUS_SPRITES[sc.input.status]
    self.text.caption = { "entity-status." .. self.STATUS_NAMES[sc.input.status] }
  end
end

--- Create the status indicator
function GuiStatusLabel:create(sc, parent)
  self:init()

  local flow = parent.add {
    type = "flow",
    style = "status_flow",
    direction = "horizontal"
  }
  flow.style.vertical_align = "center"
  flow.style.horizontally_stretchable = true

  -- Status indicator
  self.indicator = flow.add {
    type = "sprite",
    style = "status_image",
  }
  self.indicator.style.stretch_image_to_widget_size = true

  -- Status text
  self.text = flow.add {
    type = "label"
  }

  local spacer = flow.add {
    type = "empty-widget"
  }
  spacer.style.horizontally_stretchable = true

  flow.add {
    type = "label",
    caption = "ID: " .. sc.id
  }

  self:tick(sc)
end

--- Initialize the status indicator GUI element
function GuiStatusLabel:init()
  -- Status sprite names
  if not (self.STATUS_SPRITES) then
    self.STATUS_SPRITES = {}
    --- Status sprite names
    local RED = "status_not_working"
    local GREEN = "status_working"
    local YELLOW = "status_yellow"

    -- Built-in combinator statuses
    self.STATUS_SPRITES[defines.entity_status.working] = GREEN
    self.STATUS_SPRITES[defines.entity_status.normal] = GREEN
    self.STATUS_SPRITES[defines.entity_status.no_power] = RED
    self.STATUS_SPRITES[defines.entity_status.low_power] = YELLOW
    self.STATUS_SPRITES[defines.entity_status.disabled_by_control_behavior] = RED
    self.STATUS_SPRITES[defines.entity_status.disabled_by_script] = RED
    self.STATUS_SPRITES[defines.entity_status.marked_for_deconstruction] = RED
    -- Special state for insufficient signal space
    self.STATUS_SPRITES[defines.entity_status.full_output] = RED
  end

  -- Convert status constants to locale names
  if not (self.STATUS_NAMES) then
    self.STATUS_NAMES = {}
    for n, i in pairs(defines.entity_status) do
      self.STATUS_NAMES[i] = string.gsub(n, "_", "-")
    end  
  end
end

--------------------------------------------------------------------------------

return GuiStatusLabel