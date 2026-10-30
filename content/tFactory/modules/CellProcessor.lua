local CellProcessor = {}

local Debug = require("Debug")
local Serializer = require("serialization/Serializer")
local CellStorage = require("CellStorage")
local ItemStack = require("ItemStack")

CellProcessor.templates = {}   -- [class] = template
CellProcessor.cells = {}       -- [key] = cell
CellProcessor.dirtyCells = {}  -- [key] = cell
CellProcessor.activeCells = {} -- [key] = cell

local STEP = 1.0 / 20.0

local tick = 0

local neighbors = {
	{ 1,  0,  0 },
	{ -1, 0,  0 },
	{ 0,  1,  0 },
	{ 0,  -1, 0 },
	{ 0,  0,  1 },
	{ 0,  0,  -1 },
}

function CellProcessor.positionKey(x, y, z)
	return x .. ":" .. y .. ":" .. z
end

local function round(value)
	return math.round(tonumber(value) or 0)
end

local function parseVec3(value)
	if type(value) == "string" then
		local vector = Serializer.deserializeVector3(value)
		return round(vector.x), round(vector.y), round(vector.z)
	end
	return round(value.x), round(value.y), round(value.z)
end

local function hashKey(key)
	local hash = 0
	for i = 1, #key do
		hash = (hash * 31 + string.byte(key, i)) % 2147483647
	end
	return hash
end

local function touch(cell, wake)
	cell.dirty = true
	if wake then
		cell.wake = true
	end
	CellProcessor.dirtyCells[cell.key] = cell
end

local function touchNeighbors(x, y, z, wake)
	for i = 1, #neighbors do
		local neighbor = CellProcessor.getCell(x + neighbors[i][1],
			y + neighbors[i][2], z + neighbors[i][3])
		if neighbor ~= nil then
			touch(neighbor, wake)
		end
	end
end

local function shouldWork(cell)
	return cell.template.condition == nil or cell.template.condition(cell)
end

function CellProcessor.registerTemplate(template)
	if template.class == nil then
		Debug.log(
			"WARN",
			"CellProcessor",
			"Cannot register template: class is nil!"
		)
		return
	end
	if CellProcessor.templates[template.class] ~= nil then
		Debug.log("WARN", "CellProcessor",
			'Template "' .. template.class .. '", already registered!')
		return
	end

	CellProcessor.templates[template.class] = template
	Debug.log("INFO", "CellProcessor",
		'Registered template "' .. template.class .. '"')
end

function CellProcessor.getCell(x, y, z)
	return CellProcessor.cells[CellProcessor.positionKey(x, y, z)]
end

function CellProcessor.markDirty(x, y, z)
	local cell = CellProcessor.getCell(x, y, z)
	if cell == nil then
		return
	end

	cell.save = true
	touch(cell, false)
	touchNeighbors(x, y, z, true)
end

function CellProcessor.deactivate(cell)
	if not cell.active then
		return
	end

	cell.active = false
	CellProcessor.activeCells[cell.key] = nil
	CellStorage.save(cell)
	cell.save = false
	touchNeighbors(cell.x, cell.y, cell.z, false)
end

function CellProcessor.block(cell)
	cell.blocked = true
	cell.active = false
	CellProcessor.activeCells[cell.key] = nil
	CellStorage.save(cell)
	cell.save = false
end

function CellProcessor.setCell(x, y, z, class, rotation)
	local key = CellProcessor.positionKey(x, y, z)
	local template = CellProcessor.templates[class]

	if template == nil then
		Debug.log("WARN", "CellProcessor",
			'Unknown cell class "' .. tostring(class) .. '"')
		return CellProcessor.cells[key]
	end

	local cell = CellProcessor.cells[key]
	local created = cell == nil or cell.class ~= class

	if cell == nil then
		cell = {
			key = key,
			x = x,
			y = y,
			z = z,
			class = class,
			template = template,
			dx = 0,
			dy = 0,
			dz = 0,
			dirty = true,
			active = false,
			blocked = false,
			wake = false,
			save = false,
			offset = 0,
			state = {},
		}
		CellProcessor.cells[key] = cell
	elseif created then
		if cell.template.onRemoved ~= nil then
			cell.template.onRemoved(cell)
		end

		cell.class = class
		cell.template = template
		cell.state = {}
		cell.blocked = false
		cell.active = false
		cell.wake = false
		cell.save = false
		CellProcessor.activeCells[key] = nil

		Debug.log("INFO", "CellProcessor",
			'Replaced cell with position: "x:' .. x .. "y:" .. y .. "z:" .. z ..
			'"')
	end

	cell.class = class
	cell.template = template

	if rotation ~= nil then
		cell.dx, cell.dy, cell.dz = parseVec3(rotation)
	end

	if created then
		cell.offset = hashKey(key) % (template.tickInterval or 1)
		cell.state = CellStorage.read(cell)
		if template.onPlaced ~= nil then
			template.onPlaced(cell)
		end

		Debug.log("INFO", "CellProcessor",
			'Created cell "' .. class .. '" with position: "x:' .. x .. "y:" ..
			y .. "z:" .. z .. '"')
	end

	touch(cell, false)
	touchNeighbors(x, y, z, true)
	return cell
end

function CellProcessor.removeCell(x, y, z)
	local key = CellProcessor.positionKey(x, y, z)
	local cell = CellProcessor.cells[key]
	if cell == nil then
		return
	end

	if cell.template.onRemoved ~= nil then
		cell.template.onRemoved(cell)
	end
	CellStorage.save(cell)

	CellProcessor.cells[key] = nil
	CellProcessor.dirtyCells[key] = nil
	CellProcessor.activeCells[key] = nil
	touchNeighbors(x, y, z, true)

	Debug.log("INFO", "CellProcessor",
		'Removed cell with position: "x:' .. x .. "y:" .. y .. "z:" .. z .. '"')
end

function CellProcessor.pushItem(cell, stack)
	if ItemStack.isEmpty(stack) then
		return 0
	end
	if cell.dx == 0 and cell.dy == 0 and cell.dz == 0 then
		return stack.count
	end

	local neighbor = CellProcessor.getCell(cell.x + cell.dx, cell.y + cell.dy,
		cell.z + cell.dz)
	if neighbor == nil then
		return stack.count
	end

	local template = neighbor.template
	if template.acceptItem == nil or template.putItem == nil then
		return stack.count
	end
	if not template.acceptItem(neighbor, stack) then
		return stack.count
	end

	return template.putItem(neighbor, stack)
end

function CellProcessor.updateCell(cell)
	if cell.value == nil then
		Debug.log("WARN", "CellProcessor", "Cannot update cell: value is nil!")
		return nil
	end

	local x, y, z = parseVec3(cell.position)
	return CellProcessor.setCell(x, y, z, cell.value, cell.rotation)
end

function CellProcessor.loadIntialState(cells)
	Debug.log("INFO", "CellProcessor", "Initializing initial state")

	for _, cell in ipairs(cells) do
		CellProcessor.updateCell(cell)
	end

	Debug.log("INFO", "CellProcessor", "Done!")
end

function CellProcessor.step(dt)
	tick = tick + 1
	dt = dt or STEP

	local dirty = CellProcessor.dirtyCells
	CellProcessor.dirtyCells = {}

	for key, cell in pairs(dirty) do
		if CellProcessor.cells[key] == cell then
			local active = cell.wake or shouldWork(cell)
			cell.wake = false
			cell.dirty = false

			if active then
				if not cell.active then
					cell.active = true
					CellProcessor.activeCells[key] = cell
				end
			elseif cell.active then
				CellProcessor.deactivate(cell)
			end

			if cell.save then
				cell.save = false
				CellStorage.save(cell)
			end
		end
	end

	local active = {}
	for key, cell in pairs(CellProcessor.activeCells) do
		if CellProcessor.cells[key] == cell then
			active[#active + 1] = cell
		end
	end

	for i = 1, #active do
		local cell = active[i]
		if cell.active and CellProcessor.cells[cell.key] == cell then
			local template = cell.template
			local interval = template.tickInterval or 1

			if interval <= 1 or (tick + cell.offset) % interval == 0 then
				if template.work ~= nil then
					template.work(cell, dt * interval)
				end
			end

			if cell.active and not shouldWork(cell) then
				CellProcessor.deactivate(cell)
			end

			if tick % 20 == 0 then
				CellStorage.save(cell)
			end
		end
	end
end

function CellProcessor.saveAll()
	for _, cell in pairs(CellProcessor.cells) do
		CellStorage.save(cell)
	end
end

return CellProcessor
