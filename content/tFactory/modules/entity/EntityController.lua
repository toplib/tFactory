local EntityController = {}

local GameStorage = require("GameStorage")
local Debug = require("Debug")

EntityController.entites = {}

local function restoreEntities()
	for uid, entity in pairs(entities.get_all()) do
		Debug.log("INFO", "EntityController", "Removing entity")
		entities.despawn(uid)
	end
end
function EntityController.EntityController()
	Debug.log("INFO", "EntityController", "Starting EntityController service")
	restoreEntities()
end

return EntityController
