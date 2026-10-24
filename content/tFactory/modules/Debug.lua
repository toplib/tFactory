local Debug = {}

local Constants = require("Constants")
function Debug.log(level, class, message)
	if (not Constants.debug.backtrace or Constants.debug.backtrace == nil) and level == "BT" then
		return
	end
	print("[" .. level .. "] " .. class .. ": " .. message)
end
return Debug
