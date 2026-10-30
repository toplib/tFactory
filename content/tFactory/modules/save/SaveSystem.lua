local SaveSystem = {}

local Debug = require("Debug")

function SaveSystem.load(filename)
	if not file.isfile(filename) then
		return {}
	end

	local ok, data = pcall(json.parse, file.read(filename))
	if not ok or type(data) ~= "table" then
		Debug.log("WARN", "SaveSystem", "Cannot load save file: " .. filename)
		return {}
	end
	return data
end

function SaveSystem.save(filename, data)
	file.write(filename, json.tostring(data))
end

return SaveSystem
