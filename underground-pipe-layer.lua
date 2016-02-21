local tools = require("tools")

local pipePlacer = {}

function pipePlacer.checkPlacedPipePlacer(event)
	if event.created_entity.name == "underground-pipe-placer"  then
		local playerStack = game.get_player(event.player_index).cursor_stack
		local pos = event.created_entity.position
		local surface = event.created_entity.surface
		
		tools.reAddItemToPlayer(playerStack, "underground-pipe-placer")
		event.created_entity.destroy()
	end
end

function shouldPlacePipe(playerStack, pos, surface)
	
end












return pipePlacer
