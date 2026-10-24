function on_interact(x, y, z, playerid)
	hud.show_overlay("tfactory:core", false)
	print("X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ", Player ID: " .. playerid)
	return true
end
