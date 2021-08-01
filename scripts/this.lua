----------------------------------------------------------------------------------------------------
--- Initialize this mod's globals
----------------------------------------------------------------------------------------------------

local This = { }

function This:init()
  self.settings = Mod.settings:add_startup(require("scripts/settings-startup"))
  self.settings = Mod.settings:add_runtime(require("scripts/settings-runtime"))

  self.StaCo = require("scripts/staco/staco")

  if (script) then
    self.runtime = require("scripts/runtime")
    self.gui = require("scripts/gui/gui")
  end
end

----------------------------------------------------------------------------------------------------

return This