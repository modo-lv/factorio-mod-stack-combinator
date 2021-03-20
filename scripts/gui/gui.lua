--------------------------------------------------------------------------------
--- # GUI layout: the main StaCo config window and all its contents
--------------------------------------------------------------------------------

local Gui = {
  NAME = This.StaCo.NAME .. "-gui",

  --- Static combinator that this GUI is opened for
  staco = nil,

  elements = {
    window = nil,
    title_bar = require("gui-title-bar"),
    status = require("gui-status-label"),
    preview = require("gui-preview"),
    input = require("gui-input"),
    input_op = require("gui-input-op"),
    output = require("gui-output"),
    output_network = require("gui-output-network")
  }
}
Gui.CLOSE_BUTTON_NAME = Gui.NAME .. "-close"
Gui.INVERT_RED_NAME = Gui.NAME .. "-invert-red"
Gui.INVERT_GREEN_NAME = Gui.NAME .. "-invert-green"
Gui.INPUT_OP_NAME = Gui.NAME .. "-input-op"
Gui.INPUT_OP_DESC = Gui.NAME .. "-input-op-description"

function Gui:tick()
  self.elements.status:tick(self.staco)
  self.elements.output:tick(self.staco)
  self.elements.output_network:tick(self.staco)
end


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
  self.elements.input:create(sc, contents)
  self.elements.input.red.name = self.INVERT_RED_NAME
  self.elements.input.green.name = self.INVERT_GREEN_NAME

  -- Operation
  self.elements.input_op:create(sc, contents)
  self.elements.input_op.selector.name = self.INPUT_OP_NAME
  self.elements.input_op.description.name = self.INPUT_OP_DESC

  contents.add { type = "line" }

  -- Output signals
  self.elements.output:create(contents)
  self.elements.output_network:create(contents)

  player.opened = window
  -- Keep for reference
  self.staco = sc
  self:tick()
  window.force_auto_center()
  return window
end

--- Destroy the GUI
function Gui:destroy(player)
  -- Since only one combinator GUI is supposed to be open at a time, we don't
  -- need to store any specific references; just remove everything that's ours.
  for _, g in ipairs(player.gui.screen.children) do
    if g.name == Gui.NAME then
      player.opened = nil
      This.gui.staco = nil
      g.destroy()
    end
  end
end



--------------------------------------------------------------------------------
return Gui