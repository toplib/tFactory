local CellProcessor = require("CellProcessor")
local ConveyorBelt = require("blocks/ConveyorBelt")

function on_block_present(x, y, z)
	local dx, dy, dz = block.get_X(x, y, z)
	CellProcessor.setCell(x, y, z, block.name(block.get(x, y, z)), { x = dx, y = dy, z = dz })
end

function on_block_removed(x, y, z)
	CellProcessor.removeCell(x, y, z)
end
