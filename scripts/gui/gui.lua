--------------------------------------------------------------------------------
--- # GUI layout: the main StaCo config window and all its contents
--------------------------------------------------------------------------------

local StaCo = require("scripts/main/staco")

local Gui = {
  NAME = StaCo.NAME .. "-gui",

  --- Static combinator that this GUI is opened for
  staco = nil,

  elements = {
    window = nil,
    title_bar = require("gui-title-bar"),
    status = require("gui-status-label"),
    preview = require("gui-preview"),
    input = require("gui-input"),
    output = require("gui-output")
  }
}
Gui.CLOSE_BUTTON_NAME = Gui.NAME .. "-close"
Gui.INVERT_RED_NAME = Gui.NAME .. "-invert-red"
Gui.INVERT_GREEN_NAME = Gui.NAME .. "-invert-green"


--- Create and show the the GUI
function Gui:create(sc, player)

  local window = player.gui.screen.add { 
    type = "frame", 
    direction = "vertical",
    name = Gui.NAME,
  }

  -- Title bar
  self.elements.window = window
  self.elements.title_bar:create(sc, window)
  self.elements.title_bar.close_button.name = self.CLOSE_BUTTON_NAME

  -- Main content
  local contents = window.add({
    type = "frame",
    style = "entity_frame",
    direction = "vertical",
  })

  -- Status indicator & entity preview
  self.elements.status:create(sc, contents)
  self.elements.preview:create(sc, contents)

  -- Input configuration
  self.elements.input:create(sc, contents, sc_config)
  self.elements.input.red.name = self.INVERT_RED_NAME
  self.elements.input.green.name = self.INVERT_GREEN_NAME

  contents.add { type = "line" }

  -- Output sigjnals
  self.elements.output:create(sc, contents)

  window.force_auto_center()
  player.opened = window
  -- Keep for reference
  self.staco = sc
  return window
end

--- Destroy the GUI
function Gui:destroy(player)
  -- Since only one combinator GUI is supposed to be open at a time, we don't
  -- need to store any specific references; just remove everything that's ours.
  for _, g in ipairs(player.gui.screen.children) do 
    if g.name == Gui.NAME then
      player.opened = nil
      Mod.gui.staco = nil
      g.destroy()
    end
  end
end



--------------------------------------------------------------------------------
return Gui