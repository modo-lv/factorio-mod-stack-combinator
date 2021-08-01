local events = require('__stdlib__/stdlib/event/event')
----------------------------------------------------------------------------------------------------

--- Runtime management
local Runtime = {
  --- Combinator registry
  combinators = nil,

  signal_overflows = nil,

  update_delay = nil,
}

local function run()
  Runtime:run_combinators()
end

function Runtime:register_run()
  if (self.update_delay) then
    events.remove(-self.update_delay, run)
    self.update_delay = nil
  end

  local cfg = Mod.settings:runtime()
  self.update_delay = cfg.update_delay + 1
  Mod.logger:debug("Update delay is " .. cfg.update_delay .. ", (re-)registering update events...")
  events.register(-self.update_delay, run)
end

--- Run the main logic on all StaCos
-- For binding to the on_tick event
function Runtime:run_combinators()
  if not (self.combinators) then
    self:register_combinators()
  end
  for _, sc in pairs(self.combinators) do
    sc:run()
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
  if not self.combinators then
    self:register_combinators()
  end
  return self.combinators[input.unit_number]
end

--- Find and register all existing stack combinators on the map
function Runtime:register_combinators()
  local start = game.ticks_played
  self.combinators = {}

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

  self:save()
  Mod.logger:log("(Re-)registered " .. table_size(self.combinators) .. " stack combinator(s).")
end

--- Register an existing stack combinator
-- @tparam StaCo Static combinator to register.
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
  Mod.runtime.save { combinators = self.combinators }
end

----------------------------------------------------------------------------------------------------

return Runtime
