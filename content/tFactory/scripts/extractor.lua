local CellProcessor = require("CellProcessor")
local Extractor = require("blocks/Extractor")

function on_block_present(x, y, z)
	CellProcessor.setCell(x, y, z, block.name(block.get(x, y, z)))
end

function on_block_removed(x, y, z)
	CellProcessor.removeCell(x, y, z)
end
