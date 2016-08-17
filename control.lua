local pipeCleaner = require("pipe-cleaner")

script.on_configuration_changed(
function()
	if not global.jobs then
		global.jobs = {}
	end
    for k, v in pairs(game.players) do
		v.force.reset_recipes()
	end
	pipeCleaner.resetPipes()
end)

script.on_event(defines.events.on_built_entity, 
function(event)
    pipeCleaner.checkCreateNewCleanerJob(event)
end)

script.on_event(defines.events.on_robot_built_entity, 
function(event)
	pipeCleaner.checkCreateNewCleanerJob(event)
end)

script.on_event(defines.events.on_tick, 
function(event)
	pipeCleaner.doTick(event)
end)


