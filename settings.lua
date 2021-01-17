require("globals")

data:extend{
  {
    setting_type = "runtime-global",
    name = MOD_NAME .. "-defaults-invert",
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