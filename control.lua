require("defines")
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
    pipeCleaner.checkCrateNewCleanerJob(event)
end)

script.on_event(defines.events.on_tick, 
function()
	pipeCleaner.doTick(event)
end)


