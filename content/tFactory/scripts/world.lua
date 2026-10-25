local Debug = require("Debug")
local Tests = require("Tests")

local tFactory = nil
local weather_done = false

function on_world_open()
	Tests.startAll()
	Debug.log("INFO", "world", "World loading")
	tFactory = require("tFactory")
	tFactory.start()
end

function on_world_quit()
	if tFactory ~= nil then
		tFactory.onShutdown()
	end
end
function on_world_tick()
	if not weather_done and vc ~= nil and vc.is_client() and gfx ~= nil then
		weather_done = true
		Debug.log("INFO", "world", "Setting up weather preset")
		gfx.weather.change(json.parse(file.read("tfactory:presets/weather/wasteland.json")), 5.0, "wasteland")
	end
	if tFactory ~= nil then
		tFactory.tick()
	end
end

function on_block_placed(blockid, x, y, z, playerid)
	if tFactory ~= nil then
		tFactory.onBlockPlaced(blockid, x, y, z)
	end
end

function on_block_broken(blockid, x, y, z, playerid)
	if tFactory ~= nil then
		tFactory.onBlockBroken(blockid, x, y, z)
	end
end
