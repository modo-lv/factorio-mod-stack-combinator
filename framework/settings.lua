----------------------------------------------------------------------------------------------------

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
      debug_mode = false,
      NAMES = {
        debug_mode = Mod.NAME .. "-debug-mode"
      }
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

function Settings:add_all(type, definition) table.merge(self.definitions[type], definition) end
function Settings:add_startup(definition) self.add_all { startup = definition } end
function Settings:add_runtime(definition) self.add_all { runtime = definition } end
function Settings:add_player(definition) self.add_all { player = definition } end

--- Define all settings
-- @tparam table definitions Setting definitions, matching Settings.definitions
function Settings:define_all(definitions)
  self.definitions = definitions
  return self
end

--- Access the mod's settings
-- @tparam string type Setting type. Valid values are "startup", "runtime" and "player"
-- @tparam boolean reload Reload the settings from in-game?
function Settings:load(type, reload)
  if (not loaded[type] or reload) then
    local definition = self.definitions[type]
    loaded[type] = {}
    for setting, default in pairs(definition) do
      if (definition.NAMES[setting]) then
        loaded[type][setting] = settings[type][definition.NAMES[setting]].value or default
      end
    end
    Mod.logger:debug("Loaded " .. type .. " settings: " .. serpent.line(loaded[type]))
  end
  return loaded[type] or error("Failed to load " .. type .. " settings.")
end

--- Access the mod's startup settings.
function Settings:startup()
  return self:load("startup", StartupSettings)
end

--- Access the mods's runtime settings.
-- @tparam boolean reload Reload the settings from the game?
--                        Use this with `on_runtime_mod_setting_changed`.
function Settings:runtime(reload)
  return self:load("runtime", RuntimeSettings, reload)
end

--- Access the mods's player settings.
-- @tparam boolean reload Reload the settings from the game?
--                        Use this with `on_runtime_mod_setting_changed`.
function Settings:player(reload)
  return self:load("player", reload)
end

----------------------------------------------------------------------------------------------------
return Settings