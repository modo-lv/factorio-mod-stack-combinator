--[[
  # Entity events
  Event setup for placing, moving, removing and otherwise handling combinator
  entity lifecycle.
]]
--------------------------------------------------------------------------------

local entity = require("entity-layout")

local this = {}

--- Handle all entity creation events
function this.create(event)
  if not (event.created_entity and event.created_entity.name == "stack-combinator") then return end
  entity.build(event.created_entity)
end

return this
