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
    runtime = { },
    player = { },
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

--- Add setting definitions of the given setting_type to the corresponding table
function Settings:add_all(setting_type, definitions)
  table.merge(self.definitions[setting_type], definitions)
end
--- Add setting definitions to the startup table
function Settings:add_startup(definitions)
  self:add_all("startup", definitions)
end
--- Add setting definitions to the runtime table
function Settings:add_runtime(definitions)
  self:add_all("runtime", definitions)
end
--- Add setting definitions to the player table
function Settings:add_player(definitions)
  self:add_all("player", definitions)
end

--- Access the mod's settings
-- @tparam string setting_type Setting setting_type. Valid values are "startup", "runtime" and "player"
-- @tparam boolean reload Reload the settings from in-game?
function Settings:load(setting_type, reload)
  if (not loaded[setting_type] or reload) then
    local definition = self.definitions[setting_type]
    loaded[setting_type] = {}
    local t = (setting_type == "runtime" and "global") or setting_type
    for key, setting_def in pairs(definition) do
      if (type(setting_def) == "table") then
        local value = settings[t][setting_def[1]].value
        if (value == nil) then
          value = setting_def[2]
        end
        loaded[setting_type][key] = value
      end
    end
    Mod.logger:debug("Loaded " .. setting_type .. " settings: " .. serpent.line(loaded[setting_type]))
  end
  return loaded[setting_type] or error("Failed to load " .. setting_type .. " settings.")
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