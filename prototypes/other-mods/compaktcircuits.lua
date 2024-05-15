local table = require('__stdlib__/stdlib/utils/table')

local StaCo = require("scripts/staco/staco")

if (mods["compaktcircuit"]) then
    local empty_sprite = {
        filename = '__core__/graphics/empty.png',
        width = 1,
        height = 1,
    }

    local sc = table.deepcopy(data.raw["arithmetic-combinator"][StaCo.NAME])

    -- PrototypeBase
    sc.name = StaCo.PACKED_NAME

    -- ArithmeticCombinatorPrototype
    sc.and_symbol_sprites = empty_sprite
    sc.divide_symbol_sprites = empty_sprite
    sc.left_shift_symbol_sprites = empty_sprite
    sc.minus_symbol_sprites = empty_sprite
    sc.modulo_symbol_sprites = empty_sprite
    sc.multiply_symbol_sprites = empty_sprite
    sc.or_symbol_sprites = empty_sprite
    sc.plus_symbol_sprites = empty_sprite
    sc.power_symbol_sprites = empty_sprite
    sc.right_shift_symbol_sprites = empty_sprite
    sc.xor_symbol_sprites = empty_sprite

    -- CombinatorPrototype
    sc.sprites = empty_sprite
    sc.activity_led_sprites = empty_sprite
    sc.draw_circuit_wires = false

    -- EntityPrototype
    sc.minable = nil
    sc.flags = {
        'placeable-off-grid',
        "hidden",
        "hide-alt-info",
        "not-on-map",
        "not-upgradable",
        "not-deconstructable",
        "not-blueprintable",
    }

    sc.collision_mask = {}
    sc.collision_box = nil
    sc.selectable_in_game = false

    local sc_output = table.deepcopy(data.raw["constant-combinator"][StaCo.Output.NAME])

    -- PrototypeBase
    sc_output.name = StaCo.Output.PACKED_NAME

    -- ConstantCombinatorPrototype
    sc_output.sprites = empty_sprite
    sc_output.activity_led_sprites = empty_sprite
    sc_output.draw_circuit_wires = false

    -- EntityPrototype
    sc_output.minable = nil
    sc_output.flags = {
        'placeable-off-grid',
        "hidden",
        "hide-alt-info",
        "not-on-map",
        "not-upgradable",
        "not-deconstructable",
        "not-blueprintable",
    }

    sc_output.collision_mask = {}
    sc_output.collision_box = nil
    sc_output.selectable_in_game = false

    data:extend { sc, sc_output }

    Mod.logger:debug(string.format("CC Entities `%s`, `%s` defined.", sc.name, sc_output.name))
end
