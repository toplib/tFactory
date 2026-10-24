local CommandsFactory = {}

local function registerCommand(command, description, func)
	print("[OK] Reach target add command " .. command)
	console.add_command(command, description, func)
end
function CommandsFactory.registerCommands()
	registerCommand("tfactory-ctl-debug-event-dispatcher", "DEBUG!!!", function(args)
		if not world.is_open() then
			return "world is not open"
		end
		hud.show_overlay("tfactory:dbg_event_dispatcher", true)
	end)

	registerCommand("tfactory-ctl-debug-spawn-entity-test001", "DEBUG!!!", function(args)
		local px, py, pz = player.get_pos(playerid)
		entities.spawn("tfactory:test001", { px, py + 1.0, pz })
	end)
end
return CommandsFactory
