local Debug = require("Debug").class("world")
local Tests = require("Tests")

local TICK_INTERVAL = 1.0 / 20.0

local tFactory = nil
local weather_done = false

function on_world_open()
	Tests.startAll()
	Debug.log("INFO", "World loading")
	tFactory = require("tFactory")
	tFactory.start()
end

function on_world_save()
	if tFactory ~= nil then
		tFactory.onSave()
	end
end

function on_world_quit()
	if tFactory ~= nil then
		tFactory.onShutdown()
	end
end

function on_world_tick()
	if not weather_done and vc ~= nil and vc.is_client() and gfx ~= nil then
		weather_done = true
		Debug.info("Setting up weather preset")
		gfx.weather.change(
			json.parse(file.read("tfactory:presets/weather/wasteland.json")), 5.0,
			"wasteland")
	end
	if tFactory ~= nil then
		tFactory.tick(TICK_INTERVAL)
	end
end
