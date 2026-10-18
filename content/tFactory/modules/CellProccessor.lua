local CellProccessor = {}

local Vector3 = require("Vector3")

CellProccessor.cells = {}

--[[
cell
{
  string positionVec3,
  string rotationVec3,
  string value,
}
]]

function CellProccessor.loadIntialState(cells)
	print("Initializing initial state")
	for _, cell in ipairs(cells) do
		CellProccessor.cells[cell.position] = {
			value = cell.value,
			rotation = cell.rotation,
		}
		print("Done cell with position: " .. cell.position)
	end
	print("Done!")
end

function CellProccessor.updateCell(cell)
	local existing = CellProccessor.cells[cell.position]
	if existing then
		print(
			'Replacing: "'
				.. existing.value
				.. '", to: "'
				.. cell.value
				.. '". With position: "'
				.. cell.position
				.. '"'
		)
	end

	CellProccessor.cells[cell.position] = {
		value = cell.value,
		rotation = cell.rotation,
	}
end

function CellProccessor.step()
	print("Step...")
end

return CellProccessor
