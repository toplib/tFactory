local Pipe = {}

local CellProcessor = require("CellProcessor")
local ItemStack = require("ItemStack")

Pipe.class = "tfactory:pipe"
Pipe.capacity = 1

Pipe.storage = {
	{ key = "item", field = "item", type = "stack" },
}

Pipe.condition = function(cell)
	return not cell.blocked and cell.state.item ~= nil
end

Pipe.acceptItem = function(cell, stack)
	return ItemStack.accepts(cell.state.item, stack.id, Pipe.capacity)
end

Pipe.putItem = function(cell, stack)
	local held = cell.state.item
	if held == nil then
		local count = math.min(stack.count, Pipe.capacity)
		cell.state.item = ItemStack.copy(stack, count)
		stack.count = stack.count - count
	else
		ItemStack.merge(held, stack, Pipe.capacity)
	end

	cell.blocked = false
	CellProcessor.markDirty(cell.x, cell.y, cell.z)
	return stack.count
end

Pipe.work = function(cell)
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

CellProcessor.registerTemplate(Pipe)

return Pipe
