--------------------------------------------------------------------------------
--- # SC entity events
-- Event setup for combinator placing, moving, removing etc.
--------------------------------------------------------------------------------

local entity = require("entity")

local this = {}

--- Run on every tick
function this.tick(ev)
  if (all_combinators) then return end
  entity.find_all()
end

--- Creation events
function this.create(event)
  if not (event.created_entity and event.created_entity.name == SC_ENTITY_NAME) then return end
  entity.build(event.created_entity)
end

--- Rotation
function this.rotate(ev)
  if not (ev.entity and ev.entity.name == SC_ENTITY_NAME) then return end
  entity.rotate(ev.entity, game.get_player(ev.player_index))
end

--- Removal events
function this.destroy(event)
  local en = event.entity
  if not (en and en.name == SC_ENTITY_NAME) then return end

  entity.remove(en)
end

--- Chunk/surface removals
function this.purge_missing(ev)
  -- Deleting the combinator list will trigger its recreation on next tick,
  -- which will also remove any leftover configurations.
  all_combinators = nil
end

return this
