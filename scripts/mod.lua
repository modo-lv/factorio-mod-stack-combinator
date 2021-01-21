--------------------------------------------------------------------------------
--- # Mod globals
-- @type Mod
--------------------------------------------------------------------------------

local Mod = {
  --[[ Constants ]]
  NAME = "stack-combinator",

  settings = nil
}

--- Initialize basic mod-level stuff
function Mod.init()
  Game = game
  Mod.settings:load()
  Mod.debug:log("Mod initialized.")
end

--- Unique(-ish) ID for the current save, so that we can have one persistent
-- log file per savegame
local game_id = nil
--- Get (generating if necessary) game ID
function Mod:game_id()
  if (game_id) then return game_id end
  if (global.game_id) then
    game_id = global.game_id 
  else 
    game_id = math.random(100, 999)
    global.game_id = game_id
  end
  return game_id
end

--------------------------------------------------------------------------------
return Mod