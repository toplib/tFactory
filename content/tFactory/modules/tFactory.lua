local tFactory = {}

local CellProccessor = require("CellProccessor")
local GameStorage = require("GameStorage")
local Item = require("Item")
local Events = require("Events")
local Settings = require("Settings")

function tFactory.registerEvents()
	Events.registerEvent(function(arguments)
		if Settings.debug then
			print("tFactory - Events | onConveyorItemOwnershipChange")
		end
	end, "onConveyorItemOwnershipChange")
end

-- TODO: Fix saves system
function tFactory.loadSave()
	GameStorage.save["raw"] = ""
	file.write("save-meta.dat", "Test")
	GameStorage.save["raw"] = file.read("save-meta.dat")
	print(GameStorage.save["raw"])
end

function tFactory.start()
	print("----------------------------------------------")
	print("              Starting tFactory               ")
	print("----------------------------------------------")

	print("----------------------------------------------")
	print("             Registering Events               ")
	print("----------------------------------------------")
	tFactory.registerEvents()
	print('Done "registerEvents"!')
	print("----------------------------------------------")
	print("                Loading save                  ")
	print("----------------------------------------------")
	-- tFactory.loadSave()
	print('Done "loadSave"!')

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

-- GameStorage abstraction

function tFactory.getCoreHealth()
	return { health = GameStorage.core.health, max_health = GameStorage.core.max_health }
end

function tFactory.getCoreVault()
	return {
		Item({
			id = "tFactory:iron_ore",
			title = "Iron Ore",
			"Iron Ore",
			on_interact = function()
				print("Hello, world!")
			end,
			is_interactable = true,
		}),
		Item({
			id = "tFactory:copper_ore",
			title = "Copper Ore",
			"Copper Ore",
			on_interact = function()
				print("Copper found!")
			end,
			is_interactable = true,
		}),
		Item({
			id = "tFactory:gold_ore",
			title = "Gold Ore",
			"Gold Ore",
			on_interact = function()
				print("Golden treasure!")
			end,
			is_interactable = true,
		}),
		Item({
			id = "tFactory:stone_brick",
			title = "Stone Brick",
			"Stone Brick",
			on_interact = function()
				print("Solid material!")
			end,
			is_interactable = true,
		}),
		Item({
			id = "tFactory:wood_plank",
			title = "Wood Plank",
			"Wood Plank",
			on_interact = function()
				print("Timber acquired!")
			end,
			is_interactable = true,
		}),
		Item({
			id = "tFactory:diamond",
			title = "Diamond",
			"Diamond",
			on_interact = function()
				print("Precious gem!")
			end,
			is_interactable = true,
		}),
	}
end

return tFactory
