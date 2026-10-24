local CellProccessor = {}

local Vector3 = require("Vector3")
local Debug = require("Debug")

CellProccessor.cells = {}

--[[
Example:
{
  from = {
      x = -150,
      y = 25,
      z = 150,
  },
  to = {
      x = 150,
      y = -25,
      z = -150,
  },
}
]]

CellProccessor.updatingRegions = {}

--[[
Example:
from x:-150y:25z:75 to x:-150y:25z:70 same update
]]

CellProccessor.inTimeUpdating = {}

CellProccessor.dirtyCells = {}

--[[
cell
{
  string positionVec3,
  string rotationVec3,
  string value,
  int radius,
  int health,
  string class,
  function condition(radiusBlock),
  function onSuccessful(successBlock),
  function work(callbackFunction, data),
  function put(item),
  function get(),
  table candidatesList,
  bool dirty,
}
]]

--[[
query
{
  string type,
  table parameters
}
]]
function CellProccessor.loadIntialState(cells)
	Debug.log("INFO", "CellProccessor", "Initializing initial state")
	for _, cell in ipairs(cells) do
		CellProccessor.cells[cell.position] = {
			value = cell.value,
			rotation = cell.rotation,
		}
		Debug.log("INFO", "CellProccessor", "Done cell with position: " .. cell.position)
	end
	Debug.log("INFO", "CellProccessor", "Done!")
end

function CellProccessor.updateCell(cell)
	local existing = CellProccessor.cells[cell.position]
	if existing then
		Debug.log(
			"INFO",
			"CellProccessor",
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
	Debug.log("BT", "CellProccessor", "Step...")

	for dirtyCell in ipairs(CellProccessor.dirtyCells) do
		-- Test
	end
end

return CellProccessor
