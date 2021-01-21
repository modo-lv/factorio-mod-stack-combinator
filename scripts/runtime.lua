--------------------------------------------------------------------------------
--- # Runtime management
-- @type Runtime
--------------------------------------------------------------------------------

-- Libraries
local _table = require '__stdlib__/stdlib/utils/table'
-- Components
local StaCo = require("main/staco")

--------------------------------------------------------------------------------

local Runtime = {
  --- List of all stack combinators on the map
  combinators = nil,

  --- ID of a playthrough, remains unchanging within a save file.
  game_id = nil,

  --- Errors/alerts about overloaded StaCos
  signal_space_errors = {}
}

--- Run the main logic on all StaCos
-- For binding to the on_tick event
function Runtime:run_combinators()
  if not (self.combinators) then self.register_combinators() end
  for _, sc in pairs(self.combinators) do
    sc:run()
  end
end

--- Get the stack combinator data for an existing input entity
function Runtime:sc(input)
  return self.combinators[input.unit_number]
end

--- Find and register all existing stack combinators on the map
function Runtime:register_combinators()
  if (not Game and game) then Game = game end

  local start = Game.ticks_played
  self.combinators = {}

  for _, surface in pairs(Game.surfaces) do
    -- Find all SC entities
    local scs = surface.find_entities_filtered({ name = StaCo.NAME })
    -- Find each SC's output and store both in the list
    for _, input in pairs(scs) do
      local output = surface.find_entity(StaCo.Output.NAME, input.position)
      if not output then 
        error("Stack Combinator " .. input.id 
        .. " (at {" .. input.position.x .. ", " .. input.position.y .. "} on " 
        .. surface.name  .. ") has no output!") 
      end

      self:register_sc(StaCo.created(input, output))
    end
  end

  local delta = game.ticks_played - start
  self:save()
  Mod.debug:log("(Re-)registered " .. table_size(self.combinators) .. " stack combinator(s) in " .. delta .. " tick(s).")
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
-- @tparam StaCo Stack combinator to unregister
function Runtime:unregister_sc(sc)
  self.combinators[sc.id] = nil
  self:save()
  sc:debug_log("Combinator unregistered.")
end


--- Update persistent data
function Runtime:save()
  global.combinators = _table.map(self.combinators, function(sc) return true end)
  global.game_id = self.game_id
end


--------------------------------------------------------------------------------
return Runtime