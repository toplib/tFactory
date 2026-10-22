local Events = require("Events")

local OWNERSHIP_EVENT = "onConveyorItemOwnershipChange"

local belts = {}

local onOwnershipChange = function(arguments)
	print("Done!")
end

function on_block_present(x, y, z)
	belts[x .. ":" .. y .. ":" .. z] = true
	Events.subscribe(OWNERSHIP_EVENT, onOwnershipChange)
end

function on_block_removed(x, y, z)
	belts[x .. ":" .. y .. ":" .. z] = nil
	if next(belts) == nil then
		Events.unsubscribe(OWNERSHIP_EVENT, onOwnershipChange)
	end
end
