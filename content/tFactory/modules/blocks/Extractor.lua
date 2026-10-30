local Extractor = {}

local CellProcessor = require("CellProcessor")
local ItemStack = require("ItemStack")

Extractor.class = "tfactory:extractor"
Extractor.output = "tfactory:iron_ore"
Extractor.interval = 1.0

Extractor.storage = {
	{ key = "item", field = "item", type = "stack" },
	{ key = "progress", field = "progress", type = "number" },
}

Extractor.condition = function(cell)
	return not cell.blocked
end

Extractor.onPlaced = function(cell)
	cell.state.progress = cell.state.progress or 0
end

Extractor.work = function(cell, dt)
	local item = cell.state.item
	if item ~= nil then
		local left = CellProcessor.pushItem(cell, item)
		if left <= 0 then
			cell.state.item = nil
			cell.blocked = false
			CellProcessor.markDirty(cell.x, cell.y, cell.z)
		else
			CellProcessor.block(cell)
		end
		return
	end

	cell.state.progress = cell.state.progress + dt
	if cell.state.progress < Extractor.interval then
		return
	end

	cell.state.progress = cell.state.progress - Extractor.interval
	cell.state.item = ItemStack.create(Extractor.output, 1)
	cell.blocked = false
	CellProcessor.markDirty(cell.x, cell.y, cell.z)
end

CellProcessor.registerTemplate(Extractor)

return Extractor
