local Debug = require("Debug")
local Tests = require("Tests")

function on_world_open()
	local tFactory = require("tFactory")
	Tests.startAll()
	Debug.log("INFO", "world", "World loading")
	tFactory.start()
end
