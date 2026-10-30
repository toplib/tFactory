local tFactory = {}

local CellProcessor = require("CellProcessor")
local GameStorage = require("GameStorage")
local Item = require("Item")
local Events = require("Events")
local Settings = require("Settings")
local CommandsFactory = require("CommandsFactory")
local Debug = require("Debug")
local EntityController = require("entity/EntityController")
local AnimationController = require("animation/AnimationController")
local SoundEngine = require("sound/SoundEngine")
local Elements = require("elements/Elements")

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
	Debug.log("INFO", "tFactory", "Starting tFactory")

	Debug.log("INFO", "tFactory", "Registering Events")
	tFactory.registerEvents()

	Debug.log("INFO", "tFactory", 'Done "registerEvents"!')
	Debug.log("INFO", "tFactory", "Loading save")
	-- tFactory.loadSave()
	Debug.log("INFO", "tFactory", 'Done "loadSave"!')

	Debug.log("INFO", "tFactory", "Register commands")
	CommandsFactory.registerCommands()
	Debug.log("INFO", "tFactory", 'Done "registerCommands"!')

	Debug.log("INFO", "tFactory", "Starting EntityController")
	EntityController.EntityController()
	Debug.log("INFO", "tFactory", 'Done "EntityController"!')


	Debug.log("INFO", "tFactory", "Starting Elements Database")
	Elements.Elements()
	Debug.log("INFO", "tFactory", 'Done "Elements Database"!')
end

function tFactory.tick(dt)
	SoundEngine.tick()
	CellProcessor.step(dt)
end

function tFactory.onSave()
	CellProcessor.saveAll()
end

function tFactory.onShutdown()
	CellProcessor.saveAll()
	SoundEngine.onShutdown()
end

-- GameStorage abstraction

function tFactory.getCoreHealth()
	return {
		health = GameStorage.core.health,
		max_health = GameStorage.core.max_health
	}
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
