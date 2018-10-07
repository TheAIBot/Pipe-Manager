local tools = require("tools")

-----------------
--[[Constants]]--
-----------------
local CLEAN = "clean"
local REACTIVATE = "reactivate"
local MAX_CHANGES_PER_UPDATE = 10
local DEBUG_ENTITY = "debug_overlay"

local pipeCleaner = {}


--------------
--[[Events]]--
--------------
function pipeCleaner.checkCreateNewCleanerJob(event)
	if event.created_entity.name == "pipe-cleaner" then
		if event.player_index ~= nil then	
			local pos = event.created_entity.position
			local surface = event.created_entity.surface
			local playerStack = game.players[event.player_index].cursor_stack
			tools.reAddItemToPlayer(playerStack, "pipe-cleaner")
			event.created_entity.destroy()
			
			local pipeEntity = surface.find_entities_filtered{type = {"pipe", "pipe-to-ground"}, position = pos}
			if pipeEntity then
				for k, v in pairs(pipeEntity) do
					global.jobs[global.jobsStartedCount] = createCleanerJob(v)
					global.jobsStartedCount = global.jobsStartedCount + 1
				end
			end
		else
			event.created_entity.destroy()
		end
	end
end

function pipeCleaner.doTick(event)
	--if game.tick % 30 ~= 0 then
	--	return
	--end
	
	local toRemove = {}
    for k, job in pairs(global.jobs) do
		if job.job == CLEAN then
			jobEnded = doCleanerJob(job, doJobOnPipe, addPipeCleanPipe, operationDisablePipe)
		elseif job.job == REACTIVATE then
			jobEnded = doCleanerJob(job, enablePipe, addPipeReactivatePipe, operationReactivatePipe)
			if jobEnded then
				toRemove[#toRemove + 1] = k
			end
		end
		print(changesUsed)
		break
	end
	for k, v in pairs(toRemove) do
		global.jobs[v] = nil
	end
end


----------------------------
--[[Create Job Functions]]--
----------------------------
function createCleanerJob(pipe)
	local newJob = 
	{
		job = CLEAN,
		firstPipe = pipe,
		cleaners = 
		{ 
			createCleaner(pipe, pipe) 
		},
		newCleaners = {},
		cleanerUpdateIndex = 1,
	}
	return newJob
end


------------------------
--[[Do Job Functions]]--
------------------------
function doCleanerJob(job, funcOnPipe, funcAddPipe, funcOperationOnPipe)
	local stopIndex
	if job.cleanerUpdateIndex + MAX_CHANGES_PER_UPDATE > #job.cleaners then
		stopIndex = #job.cleaners
	else
		stopIndex = job.cleanerUpdateIndex + MAX_CHANGES_PER_UPDATE
	end
	for i = job.cleanerUpdateIndex, stopIndex do
		local cleaner = job.cleaners[i]
		funcOnPipe(cleaner.toClean)
		funcOnPipe(cleaner.cleaned)
		if cleaner.entity.valid then
			cleaner.entity.destroy()
		end
		for k, newNeighbor in pairs(findNewNeighbors(cleaner.toClean, cleaner.cleaned)) do
			if  funcAddPipe(newNeighbor) and
				(newNeighbor.type == "pipe" or
				newNeighbor.type == "pipe-to-ground") then
				local newCleaner = createCleaner(newNeighbor, cleaner.toClean)
				job.newCleaners[#job.newCleaners + 1] = newCleaner
				funcOperationOnPipe(newNeighbor)
			end
		end
	end
	job.cleanerUpdateIndex = stopIndex
	if #job.newCleaners == 0 then
		if job.job == CLEAN then
			job.newCleaners = {}
			job.cleanerUpdateIndex = 1
			job.job = REACTIVATE
			job.cleaners = { createCleaner(job.firstPipe, job.firstPipe) }
			return false
		else
			return true
		end
	end
	if stopIndex == #job.cleaners then
		job.cleaners = job.newCleaners
		job.newCleaners = {}
		job.cleanerUpdateIndex = 1
		return false
	end
	return false
end

function addPipeCleanPipe(neighbor)
	return neighbor.active
end

function addPipeReactivatePipe(neighbor)
	return neighbor.active == false
end

function operationDisablePipe(pipe)
	pipe.active = false
	pipe.destructible = false
	pipe.minable = false
end

function operationReactivatePipe(pipe)
	pipe.active = true
	pipe.destructible = true
	pipe.minable = true
end

function createCleaner(toCleanParam, cleanedParam)
	return {
		toClean = toCleanParam,
		cleaned = cleanedParam,
		entity = toCleanParam.surface.create_entity({name = DEBUG_ENTITY, position = toCleanParam.position})
	}
end

function doJobOnPipe(pipe)
	for i = 1, #pipe.fluidbox do
		pipe.fluidbox[i] = nil
	end
	pipe.active = false
	pipe.destructible = false
	pipe.minable = false
end

function enablePipe(pipe)
	pipe.active = true
	pipe.destructible = true
	pipe.minable = true
end

function findNewNeighbors(toClean, cleaned)
	local newNeighbors = {}
	for k, v in pairs(toClean.neighbours[1]) do
		if v ~= cleaned and v.valid then
			newNeighbors[#newNeighbors + 1] = v
		end
	end
	return newNeighbors
end

return pipeCleaner