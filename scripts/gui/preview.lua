--------------------------------------------------------------------------------
--- # Entity preview "window" in the combinator GUI
--------------------------------------------------------------------------------

local this = {}

function this.create(sc, parent)
	local ep_frame = parent.add {
		type = "frame",
		style = "deep_frame_in_shallow_frame",
	}
	ep_frame.style.minimal_width = 0
	ep_frame.style.horizontally_stretchable = true
	ep_frame.style.padding = 0
	
	local ep = ep_frame.add {
		type = "entity-preview",
	}
	ep.style.minimal_width = 400
	ep.style.height = 146
	ep.style.horizontally_stretchable = true
	ep.entity = sc
end

return this