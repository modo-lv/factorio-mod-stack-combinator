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
	ep_frame.style.padding = 0
	
	local ep = ep_frame.add {
		type = "entity-preview",
	}
	ep.style.size = { 400, 146 }
	ep.entity = sc
end

return this