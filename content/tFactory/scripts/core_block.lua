function on_interact(x, y, z, playerid)
	hud.show_overlay("tfactory:core", false)
	print("X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ", Player ID: " .. playerid)

	-- TEST ONLY
	local px, py, pz = player.get_pos(playerid)
	entities.spawn("tfactory:test001", { px, py + 1.0, pz })
	return true
end
