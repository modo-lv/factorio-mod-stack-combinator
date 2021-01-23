local table = require('__stdlib__/stdlib/utils/table')

----------------------------------------------------------------------------------------------------

--- Access to all mod settings
local Settings = {
  --- Contains setting definitions
  -- Each field must be a table with `setting = <default value>` items, as well as containing a
  -- `NAMES` table mapping settings fields to their in-game names (fields not present in NAMES will
  -- be ignored).
  definitions = {
    startup = {
      debug_mode = { Mod.NAME .. "-debug-mode", false }
    },
    runtime = {},
    player = {},
  }
}

local loaded = {
  --- Startup settings
  startup = nil,
  --- Runtime settings
  runtime = nil,
  --- Player settings
  player = nil,
}

--- Add setting definitions of the given type to the corresponding table
function Settings:add_all(type, definition) table.merge(self.definitions[type], definition) end
--- Add setting definitions to the startup table
function Settings:add_startup(definition) self:add_all("startup", definition) end
--- Add setting definitions to the runtime table
function Settings:add_runtime(definition) self:add_all("runtime", definition) end
--- Add setting definitions to the player table
function Settings:add_player(definition) self:add_all("player", definition) end

--- Access the mod's settings
-- @tparam string type Setting type. Valid values are "startup", "runtime" and "player"
-- @tparam boolean reload Reload the settings from in-game?
function Settings:load(type, reload)
  if (not loaded[type] or reload) then
    local definition = self.definitions[type]
    loaded[type] = {}
    for key, setting_def in pairs(definition) do
      loaded[type][key] = settings[type][setting_def[1]].value or setting_def[2]
    end
    Mod.logger:debug("Loaded " .. type .. " settings: " .. serpent.line(loaded[type]))
  end
  return loaded[type] or error("Failed to load " .. type .. " settings.")
end

--- Access the mod's startup settings.
function Settings:startup()
  return self:load("startup")
end

--- Access the mods's runtime settings.
-- @tparam boolean reload Reload the settings from the game?
--                        Use this with `on_runtime_mod_setting_changed`.
function Settings:runtime(reload)
  return self:load("runtime", reload)
end

--- Access the mods's player settings.
-- @tparam boolean reload Reload the settings from the game?
--                        Use this with `on_runtime_mod_setting_changed`.
function Settings:player(reload)
  return self:load("player", reload)
end

----------------------------------------------------------------------------------------------------

return Settings