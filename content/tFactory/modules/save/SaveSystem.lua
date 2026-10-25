local SaveSystem = {}

local Debug = require("Debug")

function SaveSystem.load(filename)
	Debug.log("INFO", "SaveSystem", "Loading save file: " .. filename)
	return {}
end

function SaveSystem.save(filename, data)
	Debug.log("INFO", "SaveSystem", "Saving save file: " .. filename)
end

return SaveSystem
