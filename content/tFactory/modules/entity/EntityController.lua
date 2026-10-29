local EntityController = {}

local GameStorage = require("GameStorage")
local Debug = require("Debug")
local Events = require("Events")

EntityController.entites = {}

local function registerEvent(name)
	Debug.log("INFO", "EntityController", "Register event " .. name)
	Events.registerEvent(function(arguments)
			Debug.log("DEBUG", "EntityController",
				"Executing, event " .. name)
		end,
		name)
end

local function registerEvents()
	Debug.log("INFO", "EntityController", "Reach target: Register Events")
	registerEvent("onEntityControllerEventEntitySpawn")
	registerEvent("onEntityControllerEventEntityRemove")
	registerEvent("onEntityControllerEventEntityMove")
	registerEvent("onEntityControllerEventEntityStateChange")
end

local function restoreEntities()
	for uid, entity in pairs(entities.get_all()) do
		Debug.log("INFO", "EntityController", "Removing entity")
		entities.despawn(uid)
	end
end
function EntityController.EntityController()
	Debug.log("INFO", "EntityController", "Starting EntityController service")
	registerEvents()
	restoreEntities()
	Debug.log("INFO", "EntityController", "Done.")
end

return EntityController
