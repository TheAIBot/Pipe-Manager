local pipeCleaner = require("pipe-cleaner")

script.on_init(function()
	reset()
end)

script.on_configuration_changed(function(data)
	if data.mod_changes and data.mod_changes["Pipe-Manager"] then
		reset()
	end
end)

function reset()
	global.jobsStartedCount = 1
	global.jobs = {}
end

script.on_event(defines.events.on_built_entity      , pipeCleaner.checkCreateNewCleanerJob)
script.on_event(defines.events.on_robot_built_entity, pipeCleaner.checkCreateNewCleanerJob)

script.on_event(defines.events.on_tick, function(event)
	pipeCleaner.doTick(event)
end)


