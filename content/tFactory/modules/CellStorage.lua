local CellStorage = {}

local ItemStack = require("ItemStack")

local function blockClass(x, y, z)
	local id = block.get(x, y, z)
	if id <= 0 then
		return nil
	end
	return block.name(id)
end

local function valid(cell)
	return blockClass(cell.x, cell.y, cell.z) == cell.class
end

local function readField(cell, name)
	return block.get_field(cell.x, cell.y, cell.z, name)
end

local function writeField(cell, name, value)
	block.set_field(cell.x, cell.y, cell.z, name, value)
end

function CellStorage.read(cell)
	local state = {}
	if cell.template.storage == nil or not valid(cell) then
		return state
	end

	local spec = cell.template.storage
	for i = 1, #spec do
		local entry = spec[i]
		if entry.type == "stack" then
			local id = readField(cell, entry.field)
			local count = readField(cell, entry.field .. "Count")
			if id ~= nil and id ~= "" and count ~= nil and count > 0 then
				state[entry.key] = ItemStack.create(id, count)
			end
		else
			local value = readField(cell, entry.field)
			if value ~= nil then
				state[entry.key] = value
			end
		end
	end

	return state
end

function CellStorage.save(cell)
	if cell.template.storage == nil or not valid(cell) then
		return
	end

	local spec = cell.template.storage
	for i = 1, #spec do
		local entry = spec[i]
		if entry.type == "stack" then
			local stack = cell.state[entry.key]
			if ItemStack.isEmpty(stack) then
				writeField(cell, entry.field, "")
				writeField(cell, entry.field .. "Count", 0)
			else
				writeField(cell, entry.field, stack.id)
				writeField(cell, entry.field .. "Count", stack.count)
			end
		else
			writeField(cell, entry.field, cell.state[entry.key] or 0)
		end
	end
end

return CellStorage
