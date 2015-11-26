data:extend(
{
    {
        type = "item",
        name = "pipe-cleaner",
        icon = "__Pipe-Manager__/graphics/icons/pipe-cleaner.png",
        flags = {"goes-to-quickbar"},
        damage_radius = 5,
        subgroup = "tool",
        order = "g[pipe-cleaner]",
        place_result = "pipe-cleaner",
        stack_size = 1
    },

    {
        type = "container",
        name = "pipe-cleaner",
        icon = "__Pipe-Manager__/graphics/icons/pipe-cleaner.png",
        flags = {"placeable-player", "player-creation"},
        minable = {mining_time = 1, result = "pipe-cleaner"},
        max_health = 100,
        corpse = "small-remnants",
        resistances ={{type = "fire",percent = 80}},
        collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
        collision_mask = {"floor-layer"},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        inventory_size = 1,
        picture =
        {
            filename = "__Pipe-Manager__/graphics/icons/pipe-cleaner.png",
            priority = "extra-high",
            width = 32,
            height = 32,
            shift = {0.0, 0.0}
        }
    },
    {
        type = "recipe",
        name = "pipe-cleaner",
		enabled = true,
        ingredients = {{"electronic-circuit",200},{"iron-plate", 50}},
        result = "pipe-cleaner",
        result_count = 1,
    },
	{
        type = "container",
        name = "debug_overlay",
        flags = {"placeable-neutral", "player-creation", "not-repairable"},
        icon = "__Pipe-Manager__/graphics/icons/pipe-cleaner.png",
        max_health = 1,
        order = 'z[pipe-cleaner]',
        collision_mask = {"resource-layer"},
        collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        inventory_size = 1,
        picture =
        {
            filename = "__Pipe-Manager__/graphics/entities/Debug_Overlay.png",
            priority = "extra-high",
            width = 32,
            height = 32,
            shift = {0.0, 0.0}
        }
    }
})