--------------------------------------------------------------------------------
--- # Entity status indicator of the stack size combinator GUI
--------------------------------------------------------------------------------

local table = require("__flib__.table")

local this = {
  indicator = nil,
  text = nil,

  STATUS_SPRITES = nil,
  STATUS_NAMES = nil
}

function this.tick(sc)
  this.indicator.sprite = "utility/" .. this.STATUS_SPRITES[sc.status]
  this.text.caption = { "entity-status." .. this.STATUS_NAMES[sc.status] }
end

--- Create the status indicator
function this.create(sc, parent)
  this.init()

  local flow = parent.add {
    type = "flow",
    style = "status_flow"
  }
  flow.style.vertical_align = "center"

  -- Status indicator
  this.indicator = flow.add {
    type = "sprite",
    style = "status_image",
  }

  -- Status text
  this.text = flow.add {
    type = "label",
    vertically_stretchable = true,
    size = 16,
  }

  this.tick(sc)
end

--- Initialize the status indicator GUI element
function this.init()
  -- Status sprite names
  if not (this.STATUS_SPRITES) then
    this.STATUS_SPRITES = {}
    --- Status sprite names
    local RED = "status_not_working"
    local GREEN = "status_working"
    local YELLOW = "status_yellow"

    -- Built-in combinator statuses
    this.STATUS_SPRITES[defines.entity_status.working] = GREEN
    this.STATUS_SPRITES[defines.entity_status.normal] = GREEN
    this.STATUS_SPRITES[defines.entity_status.no_power] = RED
    this.STATUS_SPRITES[defines.entity_status.low_power] = YELLOW
    this.STATUS_SPRITES[defines.entity_status.disabled_by_control_behavior] = RED
    this.STATUS_SPRITES[defines.entity_status.disabled_by_script] = RED
    this.STATUS_SPRITES[defines.entity_status.marked_for_deconstruction] = RED
    -- Special state for insufficient signal space
    this.STATUS_SPRITES[defines.entity_status.full_output] = RED
  end

  -- Convert status constants to locale names
  if not (this.STATUS_NAMES) then
    this.STATUS_NAMES = {}
    local names = table.shallow_copy(defines.entity_status)
    for n, i in pairs(names) do
      this.STATUS_NAMES[i] = string.gsub(n, "_", "-")
    end  
  end
end

return this