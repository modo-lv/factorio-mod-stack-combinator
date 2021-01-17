-- Main combinator
local sc = table.deepcopy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
sc.name = SC_ENTITY_NAME
sc.minable.result = SC_ENTITY_NAME

-- Hidden constant combinator for outputting signals to the network
-- Automatically de/constructed along with the main combinator
local out = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
out.name = OUT_ENTITY_NAME
out.minable = nil
out.collision_mask = {}
table.insert(out.flags, "placeable-off-grid")


data:extend{sc}
data:extend{out}