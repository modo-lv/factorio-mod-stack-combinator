-- Main combinator
local sc = table.deepcopy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
sc.name = "stack-combinator"
sc.minable.result = "stack-combinator"
sc.localised_name = "Stack size combinator"
sc.localised_description = "Multiplies incoming item signal values by their stack size."

-- Hidden constant combinator for outputting signals to the network
-- Automatically de/constructed along with the main combinator
local out = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
out.name = "stack-combinator-output"
out.collision_mask = {}
table.insert(out.flags, "placeable-off-grid")


data:extend{sc}
data:extend{out}