local ItemStack = {}

ItemStack.max = 64

function ItemStack.create(id, count, data)
	return {
		id = id,
		count = count or 1,
		data = data,
	}
end

function ItemStack.copy(stack, count)
	if stack == nil then
		return nil
	end
	return {
		id = stack.id,
		count = count or stack.count,
		data = stack.data,
	}
end

function ItemStack.isEmpty(stack)
	return stack == nil or stack.id == nil or (stack.count or 0) <= 0
end

function ItemStack.accepts(stack, id, limit)
	if stack == nil then
		return true
	end
	return stack.id == id and stack.count < (limit or ItemStack.max)
end

function ItemStack.merge(target, source, limit)
	if target == nil or source == nil or target.id ~= source.id then
		return source and source.count or 0
	end

	local moved = math.min(source.count, (limit or ItemStack.max) - target.count)
	if moved <= 0 then
		return source.count
	end

	target.count = target.count + moved
	source.count = source.count - moved
	return source.count
end

function ItemStack.take(stack, count)
	if ItemStack.isEmpty(stack) then
		return nil
	end

	count = math.min(count or 1, stack.count)
	local result = ItemStack.copy(stack, count)
	stack.count = stack.count - count
	return result
end

return ItemStack
