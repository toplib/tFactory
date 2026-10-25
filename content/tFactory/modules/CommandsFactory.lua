local CommandsFactory = {}

local Debug = require("Debug")

CommandsFactory.commands = {
	{
		id = "tfactory-ctl-debug-event-dispatcher",
		class = "control",

		name = "tFactory Control Debug Event Dispatcher",
		description = "Debug!!",
		func = function(args)
			if not world.is_open() then
				return "world is not open"
			end
			hud.show_overlay("tfactory:dbg_event_dispatcher", true)
		end,
		scheme = "tfactory-ctl-debug-event-dispatcher",
		isCheat = true,
	},
	{
		id = "tfactory-ctl-debug-entity-spawner",
		class = "control",

		name = "tFactory Control Debug Entity Spawner",
		description = "Debug!!",
		func = function(args)
			if not world.is_open() then
				return "world is not open"
			end
			hud.show_overlay("tfactory:dbg_entity_spawner", true)
		end,
		scheme = "tfactory-ctl-debug-entity-spawner",
		isCheat = true,
	},
}

function CommandsFactory.registerCommands()
	for _, command in ipairs(CommandsFactory.commands) do
		Debug.log(
			"INFO",
			"CommandsFactory",
			"Reach target: Add command " .. command.name .. ", with id: " .. command.id
		)
		console.add_command(command.scheme, command.description, command.func, command.isCheat)
	end
end
return CommandsFactory
