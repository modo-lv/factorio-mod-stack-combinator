--[[ Libs ]]
local gui = require("__flib__.gui")

--[[ Runtime globals ]]
all_placed = all_placed or nil

--[[ Persistent globals ]]
global.configs = global.configs or {}
global.open = nil

--[[ Script ]]
local this = {}

--[[ Checkboxes changed ]]
function this.checked(event)
	local e = event.element
	local sc = global.open
	if not (
		sc and sc.name == "stack-combinator" and 
		e and (e.name == "stack-combinator-gui-invert-red" or e.name == "stack-combinator-gui-invert-green")
	) then return end
end

--[[ 
	Show combinator GUI when player opens it.	
]]
function this.show(event)
	if not (event.entity and event.entity.name == 'stack-combinator') then return end
	local sc = event.entity
	local player = game.get_player(event.player_index)

	local window = player.gui.screen.add { 
		type = "frame", 
		direction = "vertical",
		name = "stack-combinator-gui",
	}
	local caption = window.add {
		type = "flow"
	}
	local title = caption.add {type = "label", caption = {"gui.entity-name"}, style = "frame_title"}
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
		name = "stack-combinator-gui-close",
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
		caption = {"gui.invert"}
	}

	local checks = contents.add {
		type = "flow",
		direction = "vertical"
	}
	
	checks.add {
		type = "checkbox",
		state = false,
		name = "stack-combinator-gui-invert-red",
		caption = {"gui.invert-red"}
	}

	checks.add {
		type = "checkbox",
		state = false,
		name = "stack-combinator-gui-invert-green",
		caption = {"gui.invert-green"}
	}

	-- Close the built-in GUI (will trigger `on_gui_closed`!) and open ours instead
	player.opened = window
	global.open = sc
	window.force_auto_center()
end

--[[ Close the combinator GUI when player presses Escape or confirm key. ]]
function this.hide(event)
	if not (event.element and event.element.name == "stack-combinator-gui") then return end
	this.close(event)
end

--[[ Close GUI when player clicks the close button. ]]
function this.click(event)
	if not (event.element and event.element.name == "stack-combinator-gui-close") then return end
	this.close(event)
end

function this.close(event)
	local player = game.get_player(event.player_index)
	for _, g in ipairs(player.gui.screen.children) do 
		if g.name == "stack-combinator-gui" then
			player.opened = nil
			global.open = nil
			g.destroy()
			break
		end
	end
end

--[[ EOF ]]
return this