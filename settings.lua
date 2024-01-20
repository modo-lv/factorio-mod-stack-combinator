require("globals")

----------------------------------------------------------------------------------------------------
--- Mod setting prototype definitions
----------------------------------------------------------------------------------------------------

local startup = {
  {
    -- Signal capacity
    setting_type = "startup",
    name = Mod.NAME .. "-signal-capacity",
    type = "int-setting",
    default_value = 40,
    minimum_value = 20,
    maximum_value = 10000
  },
  {
    -- Power requirement toggle
    setting_type = "startup",
    name = Mod.NAME .. "-require-power",
    type = "bool-setting",
    default_value = true
  },
  {
    -- Debug mode
    setting_type = "startup",
    name = Mod.NAME .. "-debug-mode",
    type = "bool-setting",
    default_value = false,
    order = "z"
  },
}

local runtime = {
  {
    -- Default signal inversion
    setting_type = "runtime-global",
    name = Mod.NAME .. "-defaults-invert",
    type = "string-setting",
    default_value = "none",
    allowed_values = {
      "none",
      "red",
      "green",
      "both"
    },
    order = "a"
  },
  {
    -- Non-items
    setting_type = "runtime-global",
    name = Mod.NAME .. "-non-items",
    type = "string-setting",
    default_value = "pass",
    allowed_values = {
      "pass",
      "invert",
      "drop"
    },
    order = "b"
  },
  {
    -- Update frequency
    setting_type = "runtime-global",
    name = Mod.NAME .. "-update-delay",
    type = "int-setting",
    default_value = 6,
    maximum_value = 60,
    minimum_value = 0,
    order = "x"
  },
  {
    -- Update limit
    setting_type = "runtime-global",
    name = Mod.NAME .. "-update-limit",
    type = "int-setting",
    default_value = 100,
    minimum_value = 1,
    order = "y"
  },
  {
    -- Empty unpowered
    setting_type = "runtime-global",
    name = Mod.NAME .. "-empty-unpowered",
    type = "bool-setting",
    default_value = false,
    order = "z"
  },
}

----------------------------------------------------------------------------------------------------

data:extend(startup)
data:extend(runtime)