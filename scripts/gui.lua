--------------------------------------------------------------------------------
--- # GUI layout: the window and all its contents
--------------------------------------------------------------------------------

local sc_config = require("entity-config")

local this = {
  elements = {
		title_bar = require("gui.title-bar"),
		status = require("gui.status-label"),
		preview = require("gui.preview"),
		input = require("gui.input"),
		output = require("gui.output")
	}
}
this.NAME = SC_ENTITY_NAME .. "-gui"
this.CLOSE_BUTTON_NAME = this.NAME .. "-close"
this.INVERT_RED_NAME = this.NAME .. "-invert-red"
this.INVERT_GREEN_NAME = this.NAME .. "-invert-green"


--- Create and show the the GUI
function this.create(sc, player)

  local window = player.gui.screen.add { 
    type = "frame", 
    direction = "vertical",
		name = this.NAME,
		tags = { sc = sc.unit_number }
  }

	-- Title bar
  this.elements.window = window
  this.elements.title_bar.create(sc, window)
  this.elements.title_bar.close_button.name = this.CLOSE_BUTTON_NAME

	-- Main content
  local contents = window.add({
    type = "frame",
    style = "entity_frame",
		direction = "vertical",
	})

	-- Status indicator & entity preview
	this.elements.status.create(sc, contents)
	this.elements.preview.create(sc, contents)

	-- Input configuration
	this.elements.input.create(sc, contents, sc_config)
	this.elements.input.red.name = this.INVERT_RED_NAME
	this.elements.input.green.name = this.INVERT_GREEN_NAME

	contents.add { type = "line" }

	-- Output sigjnals
	this.elements.output.create(sc, contents)

  window.force_auto_center()
  player.opened = window
  global.open_sc = sc
  return window
end


--- Destroy the GUI
function this.destroy(player)
  -- Since only one combinator GUI is supposed to be open at a time, we don't
  -- need to store any references; just remove everything that's ours.
  for _, g in ipairs(player.gui.screen.children) do 
    if g.name == this.NAME then
      player.opened = nil
      global.open_sc = nil
      g.destroy()
    end
  end
end



return this