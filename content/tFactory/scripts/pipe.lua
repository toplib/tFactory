local CellLifecycle = require("CellLifecycle")
require("blocks/Pipe")

local CLASS = "tfactory:pipe"

function on_block_present(x, y, z)
	CellLifecycle.present(x, y, z, CLASS)
end

function on_block_removed(x, y, z)
	CellLifecycle.removed(x, y, z, CLASS)
end

function on_replaced(x, y, z)
	CellLifecycle.save(x, y, z, CLASS)
end
