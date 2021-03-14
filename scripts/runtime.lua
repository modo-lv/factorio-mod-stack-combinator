----------------------------------------------------------------------------------------------------

--- Runtime management
local Runtime = {
  --- Combinator registry
  combinators = nil,

  signal_overflows = nil,
}

--- Run the main logic on all StaCos
-- For binding to the on_tick event
function Runtime:run_combinators()
  if not (self.combinators) then self.register_combinators() end
  for _, sc in pairs(self.combinators) do sc:run() end
end

--- Raise an alarm if a StaCo is receiving more signals than it can output.
-- @tparam StackCombinator staco The StaCo to check.
-- @tparam number total          Total amount of signals received by the StaCo.
function Runtime:signal_overflow(staco, total)
  local max = staco.output.prototype.item_slot_count
  self.signal_overflows = self.signal_overflows or { }

  if (total > max) then
    self.signal_overflows[staco.id] = { "gui.signal-overflow-message", total, max }
    -- Raise alarm
    for _, player in pairs(game.players) do
      player.add_custom_alert(
      -- Entity
        staco.input,
      -- Icons
        { type = "item", name = This.StaCo.NAME },
      -- Text
        self.signal_overflows[staco.id],
      -- Show on map?
        true
      )
    end
    return true
  end

  if (self.signal_overflows[staco.id]) then
    --- Clear the alarm if signal count is OK now
    for _, player in pairs(game.players) do
      player.remove_alert {
        entity = staco.input,
        type = defines.alert_type.custom,
        icon = { type = "item", name = This.StaCo.NAME }
      }
    end
    self.signal_overflows[staco.id] = nil
  end

  return false
end

--- Get the stack combinator data for an existing input entity
function Runtime:sc(input)
  if not self.combinators then self:register_combinators() end
  return self.combinators[input.unit_number]
end

--- Find and register all existing stack combinators on the map
function Runtime:register_combinators()
  local start = (game and game.ticks_played) or -1
  self.combinators = {}

  for _, surface in pairs(game.surfaces) do
    -- Find all SC entities
    local scs = surface.find_entities_filtered({ name = This.StaCo.NAME })
    -- Find each SC's output and store both in the list
    for _, input in pairs(scs) do
      local output = surface.find_entity(This.StaCo.Output.NAME, input.position)
      if not output then
        error(
          "Stack Combinator " .. input.unit_number ..
            " (at {" .. input.position.x .. ", " .. input.position.y ..
            "} on " .. surface.name .. ") has no output."
        )
      end
      self:register_sc(This.StaCo.created(input, output))
    end
  end

  local delta = (game and game.ticks_played or 0) - start
  self:save()
  Mod.logger:debug(
    "(Re-)registered " .. table_size(self.combinators) ..
      " stack combinator(s) in " .. (delta > 0 and delta or 1) .. " tick(s)."
  )
end

--- Register an existing stack combinator
-- @tparam StaCo Static combinator to register.
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
  Mod.runtime.save { combinators = self.combinators }
end

----------------------------------------------------------------------------------------------------

return Runtime
