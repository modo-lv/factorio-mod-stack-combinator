require("globals")

data:extend{
  -- Startup
  {
    setting_type = "startup",
    name = MOD_NAME .. "-signal-capacity",
    type = "int-setting",
    default_value = 40,
    minimum_value = 20,
    maximum_value = 10000
  },
  -- Map
  {
    setting_type = "runtime-global",
    name = MOD_NAME .. "-invert",
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
    setting_type = "runtime-global",
    name = MOD_NAME .. "-debug-mode",
    type = "bool-setting",
    default_value = false,
    order = "z"
  },
}