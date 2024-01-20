----------------------------------------------------------------------------------------------------
--- Runtime settings
----------------------------------------------------------------------------------------------------

local RuntimeSettings = {
  invert_signals = { Mod.NAME .. "-defaults-invert", "none" },
  update_delay = { Mod.NAME .. "-update-delay", 6 },
  update_limit = { Mod.NAME .. "-update-limit", 100 },
  empty_unpowered = { Mod.NAME .. "-empty-unpowered", false },
  non_item_signals = { Mod.NAME .. "-non-items", "pass" },
}

----------------------------------------------------------------------------------------------------
return RuntimeSettings