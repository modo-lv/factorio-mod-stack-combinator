--------------------------------------------------------------------------------
--- # GUI layout: the window and all its contents
--------------------------------------------------------------------------------

local sc_config = require("entity-config")

local this = {}
this.NAME = SC_ENTITY_NAME .. "-gui"
this.CLOSE_BUTTON_NAME = this.NAME .. "-close"
this.INVERT_RED_NAME = this.NAME .. "-invert-red"
this.INVERT_GREEN_NAME = this.NAME .. "-invert-green"

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

--- Create and show the the GUI
function this.create(sc, player)

  local window = player.gui.screen.add { 
		type = "frame", 
		direction = "vertical",
		name = this.NAME,
	}
	local caption = window.add {
		type = "flow"
	}
	local title = caption.add {
		type = "label",
		caption = {"", {"entity-name." .. SC_ENTITY_NAME}, " " , sc.unit_number},
		style = "frame_title"
	}
	title.drag_target = parent

	local spacer = caption.add {
		type = "empty-widget",
		style = "draggable_space"
	}
  spacer.style.horizontally_stretchable = true
  spacer.style.minimal_width = 16
  spacer.style.minimal_height = 24
	spacer.drag_target = window
	
	caption.add {
    type = "sprite-button",
    style = "frame_action_button",
		sprite = "utility/close_white",
		hovered_sprite = "utility/close_black",
		clicked_sprite = "utility/close_black",
		name = this.CLOSE_BUTTON_NAME,
  }

	local contents = window.add({
		type = "frame",
		style = "item_and_count_select_background",
		direction = "horizontal",
	}).add({
		type = "table",
		column_count = 2,
		vertical_centering = false,
	})

	contents.add {
		type = "label",
		caption = {"gui.invert"},
		tooltip = {"gui.invert-description"}
	}

	local checks = contents.add {
		type = "flow",
		direction = "vertical"
	}
	
	local cfg = sc_config.from_combinator(sc)

	checks.add {
		type = "checkbox",
		state = (cfg and cfg.invert_red) == true,
		name = this.INVERT_RED_NAME,
		caption = {"gui.invert-red"},
		tooltip = {"gui.invert-red-description"}
	}

	checks.add {
		type = "checkbox",
		state = (cfg and cfg.invert_green) == true,
		name = this.INVERT_GREEN_NAME,
		caption = {"gui.invert-green"},
		tooltip = {"gui.invert-green-description"}
  }

  window.force_auto_center()
	player.opened = window
	global.open_sc = sc
  return window
end

return this