console.add_command("tfactory-ctl-debug-event-dispatcher", "DEBUG!!!", function(args)
	if not world.is_open() then
		return "world is not open"
	end
	hud.show_overlay("tfactory:dbg_event_dispatcher", true)
end)

console.add_command("tfactory-ctl-debug-spawn-entity-test001", "DEBUG!!!", function(args)
	local px, py, pz = player.get_pos(playerid)
	entities.spawn("tfactory:test001", { px, py + 1.0, pz })
end)
