--------------------------------------------------------------------------------
--- # Runtime management
-- @type Runtime
--------------------------------------------------------------------------------
-- Libraries
local _table = require "__stdlib__/stdlib/utils/table"
-- Components

-- @see StackCombinator
local StaCo = require("staco/staco")

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
  if not (self.combinators) then
    self.register_combinators()
  end
  for _, sc in pairs(self.combinators) do
    sc:run()
  end
end

--- Raise an alarm if a StaCo is receiving more signals than it can output.
-- @tparam StackCombinator staco The StaCo to check.
-- @tparam number total          Total amount of signals by the StaCo.
function Runtime:signal_overflow(staco, total)
  local max = staco.output.prototype.item_slot_count

  if (total > max) then
    -- Raise alarm
    for _, player in pairs(game.players) do
      player.add_custom_alert(
        self.input,
        {
          type = "item",
          name = StaCo.NAME
        },
        Mod.runtime.signal_space_errors[self.id],
        true
      )
    end
    if not (self.signal_space_errors[staco.id]) then
      self.signal_space_errors[staco.id] = {"gui.signal-space-error-description", total, max}
    end
  elseif (Mod.runtime.signal_space_errors[self.id]) then
    --- Clear the alarm if signal count is OK now
    for _, player in pairs(game.players) do
      player.remove_alert {
        entity = self.input,
        type = Defines.alert_type.custom,
        icon = {
          type = "item",
          name = StaCo.NAME
        }
      }
    end
    Mod.runtime.signal_space_errors[self.id] = nil
  end
end

--- Get the stack combinator data for an existing input entity
function Runtime:sc(input)
  return self.combinators[input.unit_number]
end

--- Find and register all existing stack combinators on the map
function Runtime:register_combinators()
  local start = game.ticks_played
  self.combinators = {}

  for _, surface in pairs(game.surfaces) do
    -- Find all SC entities
    local scs =
      surface.find_entities_filtered(
      {
        name = StaCo.NAME
      }
    )
    -- Find each SC's output and store both in the list
    for _, input in pairs(scs) do
      local output = surface.find_entity(StaCo.Output.NAME, input.position)
      if not output then
        error(
          "Stack Combinator " ..
            input.id ..
              " (at {" .. input.position.x .. ", " .. input.position.y .. "} on " .. surface.name .. ") has no output!"
        )
      end

      self:register_sc(StaCo.created(input, output))
    end
  end

  local delta = game.ticks_played - start
  self:save()
  Mod.debug:log(
    "(Re-)registered " .. table_size(self.combinators) .. " stack combinator(s) in " .. delta .. " tick(s)."
  )
end

--- Register an existing stack combinator
-- @tparam LuaEntity input Stack combinator entity
-- @tparam LuaEntity output Stack combinator output entity
function Runtime:register_sc(sc)
  if not (self.combinators) then
    self.combinators = {}
  end
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
  global.combinators =
    _table.map(
    self.combinators,
    function()
      return true
    end
  )
  global.game_id = self.game_id
end

--------------------------------------------------------------------------------
return Runtime
