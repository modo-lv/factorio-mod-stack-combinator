--------------------------------------------------------------------------------
--- # Runtime management
-- @type Runtime
--------------------------------------------------------------------------------

-- Game globals
local _game = game
local _global = global
local _math = math
-- Libraries
local _event = require('__stdlib__/stdlib/event/event')
local _table = require '__stdlib__/stdlib/utils/table'
-- Components
local StackCombinator = require("stack-combinator")


local Runtime = {
  --- List of all stack combinators on the map
  combinators = nil,

  --- ID of a playthrough, remains unchanging within a save file.
  game_id = nil
}


--- Get the stack combinator data for an existing input entity
function Runtime:sc(input)
  return self.combinators[input.unit_name]
end

--- Find and register all existing stack combinators on the map
function Runtime:register_combinators()
  local start = _game.ticks_played
  self.combinators = {}

  for _, surface in pairs(_game.surfaces) do
    -- Find all SC entities
    local scs = surface.find_entities_filtered({ name = StackCombinator.INPUT_NAME })
    -- Find each SC's output and store both in the list
    for _, input in pairs(scs) do
      local output = surface.find_entity(StackCombinator.Output.NAME, input.position)
      if not output then 
        error("Stack Combinator " .. input.id 
        .. " (at {" .. input.position.x .. ", " .. input.position.y .. "} on " 
        .. surface.name  .. ") has no output!") 
      end

      self.register_sc(StackCombinator.created(input, output))
    end
  end

  local delta = game.ticks_played - start
  self.save()
  dlog("(Re-)registered " .. table_size(global.all_combinators) .. " stack combinator(s) in " .. delta .. " tick(s).")
end


--- Register an existing stack combinator
-- @tparam LuaEntity input Stack combinator entity
-- @tparam LuaEntity output Stack combinator output entity
function Runtime:register_sc(sc)
  if not (self.combinators) then self.combinators = {} end
  self.combinators[sc.id] = sc
  self:save()
end


--- Unregister a no longer existing stack combinator.
-- @tparam StackCombinator Stack combinator to unregister
function Runtime:unregister_sc(sc)
  self.combinators[sc.id] = nil
  self:save()
end


--- Update persistent data
function Runtime:save()
  global.combinators = _table.map(self.combinators, function(sc) return true end)
  global.game_id = self.game_id
end


--------------------------------------------------------------------------------
return Runtime