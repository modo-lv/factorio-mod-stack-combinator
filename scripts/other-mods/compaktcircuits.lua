local events = require('__stdlib__/stdlib/event/event')
local StaCoConfig = require("scripts/staco/staco-config")

----------------------------------------------------------------------------------------------------
--- # Support for Compakt Circuits
----------------------------------------------------------------------------------------------------

local function cc_get_info(entity)
    assert(entity and entity.valid, "stack combinator " .. (entity and entity.unit_number) or '<unknown entity>' .. " is not valid")

    return {
        parameters = entity.get_control_behavior().parameters,
        direction = entity.direction,
        position = entity.position,
    }
end

----------------------------------------------------------------------------------------------------

local function cc_create_packed_entity(info, surface, position, force)
    local packed_entity = surface.create_entity {
        name = This.StaCo.PACKED_NAME,
        force = force,
        position = position,
        direction = info.direction }

    packed_entity.get_control_behavior().parameters = info.parameters
    packed_entity.direction = info.direction

    local sc = This.StaCo.created(packed_entity)
    This.runtime:register_sc(sc)
    if (This.runtime.update_queue) then
        table.insert(This.runtime.update_queue, sc.id)
    end

    Mod.logger:debug(string.format("Called cc_create_packed_entity(%s, %s, %s, %s)", info, surface, position, force))
    return packed_entity
end

----------------------------------------------------------------------------------------------------

local function cc_create_entity(info, surface, force)
    local entity = surface.create_entity {
        name = This.StaCo.NAME,
        force = force,
        position = info.position,
        direction = info.direction }

    entity.get_control_behavior().parameters = info.parameters
    entity.direction = info.direction

    local sc = This.StaCo.created(entity)
    This.runtime:register_sc(sc)
    if (This.runtime.update_queue) then
        table.insert(This.runtime.update_queue, sc.id)
    end

    Mod.logger:debug(string.format("Called cc_create_entity(%s, %s, %s)", info, surface, force))
end

----------------------------------------------------------------------------------------------------

local function register(event)

    if (remote.interfaces["compaktcircuit"]) then
        Mod.logger:debug("Compakt Circuits detected, adding support.")

        remote.call("compaktcircuit", "add_combinator", {
            name = This.StaCo.NAME,
            packed_names = { This.StaCo.PACKED_NAME, This.StaCo.Output.PACKED_NAME },
            interface_name = This.StaCo.NAME,
        })

        remote.add_interface(This.StaCo.NAME, {
            get_info = cc_get_info,
            create_packed_entity = cc_create_packed_entity,
            create_entity = cc_create_entity,
        })

        -- update the various search and match constants to cover packed entities as well
        This.StaCo.SEARCH_NAMES = { This.StaCo.NAME, This.StaCo.PACKED_NAME }
        This.StaCo.MATCH_NAMES = { [ This.StaCo.NAME ] = true, [This.StaCo.PACKED_NAME] = true }
        This.StaCo.Output.SEARCH_NAMES = { This.StaCo.Output.NAME, This.StaCo.Output.PACKED_NAME }
        This.StaCo.Output.MATCH_NAMES = { [ This.StaCo.Output.NAME ] = true, [This.StaCo.Output.PACKED_NAME] = true }
    end
end

----------------------------------------------------------------------------------------------------

return {
    register_all = function()
        events.on_load(register)
        events.on_init(register)
    end,
}

----------------------------------------------------------------------------------------------------
