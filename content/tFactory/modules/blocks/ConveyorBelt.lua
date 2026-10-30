local ConveyorBelt = {}

local CellProcessor = require("CellProcessor")
local ItemStack = require("ItemStack")

ConveyorBelt.class = "tfactory:conveyor_belt"

ConveyorBelt.storage = {
	{ key = "item", field = "item", type = "stack" },
}

ConveyorBelt.condition = function(cell)
	return not cell.blocked and cell.state.item ~= nil
end

ConveyorBelt.acceptItem = function(cell, stack)
	return ItemStack.accepts(cell.state.item, stack.id)
end

ConveyorBelt.putItem = function(cell, stack)
	local held = cell.state.item
	if held == nil then
		local count = math.min(stack.count, ItemStack.max)
		cell.state.item = ItemStack.copy(stack, count)
		stack.count = stack.count - count
	else
		ItemStack.merge(held, stack)
	end

	cell.blocked = false
	CellProcessor.markDirty(cell.x, cell.y, cell.z)
	return stack.count
end

ConveyorBelt.work = function(cell)
	local item = cell.state.item
	if item == nil then
		return
	end

	local left = CellProcessor.pushItem(cell, item)
	if left <= 0 then
		cell.state.item = nil
		cell.blocked = false
		CellProcessor.markDirty(cell.x, cell.y, cell.z)
	else
		CellProcessor.block(cell)
	end
end

CellProcessor.registerTemplate(ConveyorBelt)

return ConveyorBelt
