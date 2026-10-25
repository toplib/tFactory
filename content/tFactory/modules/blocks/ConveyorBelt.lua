local ConveyorBelt = {}

local CellProcessor = require("CellProcessor")

ConveyorBelt.class = "tfactory:conveyor_belt"

ConveyorBelt.condition = function(cell)
	return cell.item ~= nil
end

ConveyorBelt.acceptItem = function(cell, item)
	return cell.item == nil
end

ConveyorBelt.putItem = function(cell, item)
	cell.item = item
	CellProcessor.markDirty(cell.x, cell.y, cell.z)
end

ConveyorBelt.work = function(cell, dt)
	if cell.item == nil then
		return
	end

	if CellProcessor.pushItem(cell, cell.item) then
		cell.item = nil
		CellProcessor.markDirty(cell.x, cell.y, cell.z)
	end
end

CellProcessor.registerTemplate(ConveyorBelt)

return ConveyorBelt
