local Debug = {}

local Constants = require("Constants")
local unpack = table.unpack or unpack

local function format(text, fmt)
	if fmt ~= nil then
		return string.format(text, unpack(fmt))
	end
	return text
end

function Debug.class(class)
	return {
		log = function(level, message, fmt)
			print("[" .. level .. "] " .. class .. ": " .. format(message, fmt))
		end,
		info = function(message, fmt)
			print("[INFO] " .. class .. ": " .. format(message, fmt))
		end,
		warn = function(message, fmt)
			print("[WARN] " .. class .. ": " .. format(message, fmt))
		end,
		error = function(message, fmt)
			print("[ERROR] " .. class .. ": " .. format(message, fmt))
		end,
		severe = function(message, fmt)
			print("[SEVERE] " .. class .. ": " .. format(message, fmt))
		end,
		btLog = function(message, fmt)
			if (not Constants.debug.backtrace or Constants.debug.backtrace == nil)
				and level == "BT" then
				return
			end
			print("[BT] " .. class .. ": " .. format(message, fmt))
		end,
	}
end

-- Deprecated
function Debug.log(level, class, message)
	if (not Constants.debug.backtrace or Constants.debug.backtrace == nil)
		and level == "BT" then
		return
	end
	print("[" .. level .. "] " .. class .. ": " .. message)
end

return Debug
