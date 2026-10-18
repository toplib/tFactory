local tFactory = {}

local CellProccessor = require("CellProccessor")
function tFactory.start()
	print("----------------------------------------------")
	print("              Starting tFactory               ")
	print("----------------------------------------------")

	local cells = {
		{
			position = "x:0y:0z:0",
			rotation = "x:8y:1z:0",
			value = "tfactory:crafter",
		},
		{
			position = "x:1y:2z:0",
			rotation = "x:1y:5z:0",
			value = "tfactory:rail",
		},
		{
			position = "x:0y:3z:0",
			rotation = "x:1y:0z:5",
			value = "tfactory:rail",
		},
		{
			position = "x:3y:0z:1",
			rotation = "x:4y:0z:1",
			value = "tfactory:furnance",
		},
	}
	CellProccessor.loadIntialState(cells)

	local cellToUpdateInCells = {
		position = "x:0y:0z:0",
		rotation = "x:9y:9z:9",
		value = "tfactory:null",
	}
	local cellToUpdateNotInCells = {
		position = "x:15y:11z:10",
		rotation = "x:1y:1z:1",
		value = "tfactory:not_null",
	}

	CellProccessor.updateCell(cellToUpdateInCells)
	CellProccessor.updateCell(cellToUpdateNotInCells)
end

return tFactory
