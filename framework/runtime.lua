local table = require('__stdlib__/stdlib/utils/table')

----------------------------------------------------------------------------------------------------

--- Main class governing the runtime.
-- Runtime exists during gameplay.
local Runtime = { }

--- Framework storage, not intended for direct access from the mod
function Runtime:storage()
  if (not global[Mod.STORAGE]) then global[Mod.STORAGE] = {} end
  return global[Mod.STORAGE]
end

--- Write data to persistent storage.
-- @tparam table Data to save (simple values only).
function Runtime:save(fields)
  table.merge(global, fields)
  return self
end

--- Read data from persistent storage.
-- @treturn table Data stored in the persistent storage.
function Runtime:load()
  return table.deep_copy(global)
end

local game_id
--- Get (generate if necessary) game ID.
-- Unique(-ish) ID for the current save, so that we can have one persistent log file per savegame.
function Runtime:game_id()
  if (game_id) then return game_id end
  game_id = Mod.runtime:storage().game_id or math.random(100, 999)
  return game_id
end

----------------------------------------------------------------------------------------------------

return Runtime