local CellLifecycle = {}

local CellProcessor = require("CellProcessor")
local CellStorage = require("CellStorage")

function CellLifecycle.present(x, y, z, expected)
	local id = block.get(x, y, z)
	if id <= 0 then
		return
	end

	local class = block.name(id)
	if expected ~= nil and class ~= expected then
		return
	end

	local dx, dy, dz = block.get_X(x, y, z)
	CellProcessor.setCell(x, y, z, class, { x = dx, y = dy, z = dz })
end

function CellLifecycle.removed(x, y, z, expected)
	local cell = CellProcessor.getCell(x, y, z)
	if cell == nil or (expected ~= nil and cell.class ~= expected) then
		return
	end
	CellProcessor.removeCell(x, y, z)
end

function CellLifecycle.save(x, y, z, expected)
	local cell = CellProcessor.getCell(x, y, z)
	if cell == nil or (expected ~= nil and cell.class ~= expected) then
		return
	end
	CellStorage.save(cell)
end

return CellLifecycle
