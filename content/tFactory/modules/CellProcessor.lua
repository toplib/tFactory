local CellProcessor = {}

local Debug = require("Debug")
local Serializer = require("serialization/Serializer")

CellProcessor.templates = {}   -- [class] = template
CellProcessor.cells = {}       -- [key] = cell
CellProcessor.dirtyCells = {}  -- [key] = cell
CellProcessor.activeCells = {} -- [key] = cell

local OFFSET = 2097152
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
	return (x + OFFSET) + y * 4194304 + (z + OFFSET) * 1073741824
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

local function markNeighborsDirty(x, y, z)
	for i = 1, #neighbors do
		CellProcessor.markDirty(x + neighbors[i][1], y + neighbors[i][2],
			z + neighbors[i][3])
	end
end

local function shouldWork(cell)
	local template = cell.template
	if template.alwaysActive then
		return true
	end
	return template.condition == nil or template.condition(cell)
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

	cell.dirty = true
	CellProcessor.dirtyCells[cell.key] = cell
end

function CellProcessor.setCell(x, y, z, class, rotation)
	local key = CellProcessor.positionKey(x, y, z)
	local template = CellProcessor.templates[class]

	if template == nil then
		if CellProcessor.cells[key] ~= nil then
			CellProcessor.removeCell(x, y, z)
		end
		return nil
	end

	local cell = CellProcessor.cells[key]
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
			item = nil,
			progress = 0,
		}
		CellProcessor.cells[key] = cell
		Debug.log(
			"INFO",
			"CellProcessor",
			'Created cell "' ..
			class .. '" with position: "x:' .. x .. "y:" .. y .. "z:" .. z .. '"'
		)
	elseif cell.class ~= class then
		if cell.template.onRemoved ~= nil then
			cell.template.onRemoved(cell)
		end
		Debug.log(
			"INFO",
			"CellProcessor",
			'Replacing: "'
			.. cell.class
			.. '", to: "'
			.. class
			.. '". With position: "x:'
			.. x
			.. "y:"
			.. y
			.. "z:"
			.. z
			.. '"'
		)
		cell.class = class
		cell.template = template
		cell.item = nil
		cell.progress = 0
	end

	if rotation ~= nil then
		cell.dx, cell.dy, cell.dz = parseVec3(rotation)
	end

	cell.dirty = true
	CellProcessor.dirtyCells[key] = cell

	if template.onPlaced ~= nil then
		template.onPlaced(cell)
	end

	markNeighborsDirty(x, y, z)
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

	CellProcessor.cells[key] = nil
	CellProcessor.dirtyCells[key] = nil
	CellProcessor.activeCells[key] = nil

	Debug.log("INFO", "CellProcessor",
		'Removed cell with position: "x:' .. x .. "y:" .. y .. "z:" .. z .. '"')

	markNeighborsDirty(x, y, z)
end

function CellProcessor.pushItem(cell, item)
	if cell.dx == 0 and cell.dy == 0 and cell.dz == 0 then
		return false
	end

	local neighbor = CellProcessor.getCell(cell.x + cell.dx, cell.y + cell.dy,
		cell.z + cell.dz)
	if neighbor == nil then
		return false
	end

	local template = neighbor.template
	if template.acceptItem == nil or template.putItem == nil then
		return false
	end
	if not template.acceptItem(neighbor, item) then
		return false
	end

	template.putItem(neighbor, item)
	CellProcessor.markDirty(neighbor.x, neighbor.y, neighbor.z)
	return true
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

function CellProcessor.step()
	tick = tick + 1

	for key, cell in pairs(CellProcessor.dirtyCells) do
		CellProcessor.dirtyCells[key] = nil
		cell.dirty = false

		if shouldWork(cell) then
			cell.active = true
			CellProcessor.activeCells[key] = cell
		else
			cell.active = false
			CellProcessor.activeCells[key] = nil
		end
	end

	for key, cell in pairs(CellProcessor.activeCells) do
		local template = cell.template
		local interval = template.tickInterval or 1

		if interval <= 1 or (tick + key) % interval == 0 then
			if template.work ~= nil then
				template.work(cell, STEP * interval)
			end
		end

		if not shouldWork(cell) then
			cell.active = false
			CellProcessor.activeCells[key] = nil
		end
	end
end

return CellProcessor
