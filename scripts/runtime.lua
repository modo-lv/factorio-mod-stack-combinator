local events = require('__stdlib__/stdlib/event/event')
----------------------------------------------------------------------------------------------------

--- Runtime management
local Runtime = {
  signal_overflows = nil,

  update_delay = nil,
}

function Runtime:cfg_update()
  local cfg = Mod.settings:runtime()
  self.update_delay = cfg.update_delay
  Mod.logger:debug("Update delay: " .. self.update_delay .. " tick(s).")
end

--- Run the main logic on all StaCos
-- For binding to the on_tick event
function Runtime:run_combinators(tick)
  if (not self.update_delay) then
    self:cfg_update()
  end

  if (self.update_delay == 0 or tick % self.update_delay == 0) then
    for _, sc in pairs(self:combinators()) do
      sc:run()
    end
  end
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
  return self:combinators()[input.unit_number]
end

--- Find and register all existing stack combinators on the map
-- @tparam boolean force_update Recreate the StaCo registry from scratch?
function Runtime:combinators(force_update)
  if (global.combinators) and (not force_update) then
    return global.combinators
  end

  global.combinators = {}
  for _, surface in pairs(game.surfaces) do
    -- Find all SC outputs
    local outputs = surface.find_entities_filtered({ name = This.StaCo.Output.NAME })

    -- Find all SCs
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
      for i, v in ipairs(outputs) do
        if v == output then
          table.remove(outputs, i)
          break
        end
      end
    end
    if (#outputs > 0) then
      Mod.logger:debug("Found " .. #outputs .. " orphan SC outputs, removing.")
      for _, output in pairs(outputs) do
        output.destroy()
      end
    end
  end

  Mod.logger:log("Registry updated: " .. table_size(global.combinators) .. " stack combinator(s).")
  return global.combinators
end

--- Register an existing stack combinator
-- @tparam StaCo Static combinator to register.
function Runtime:register_sc(sc)
  global.combinators[sc.id] = sc
  sc:debug_log("Combinator registered.")
end

--- Unregister a no longer existing stack combinator.
-- @tparam StaCo Stack combinator to unregister
function Runtime:unregister_sc(sc)
  global.combinators[sc.id] = nil
  sc:debug_log("Combinator unregistered.")
end

----------------------------------------------------------------------------------------------------

return Runtime
