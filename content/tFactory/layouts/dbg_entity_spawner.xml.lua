local K = require("kompot:kompot")
local UI = require("kompot:ui")
local Debug = require("Debug")
local handle

local Screen = K.component(function()
	local event = K.state("nil")
	local readonly = K.state(false)

	K.Box({ modifier = K.M:fill_max_size() }, function()
		UI.Panel({ title = "Debug tFactory Entity Spawner", modifier = K.M:align("center") }, function()
			UI.TextField({
				state = event,
				label = "Name",
				editable = not readonly.value,
				supporting = "This entity will be spawned",
			})
			UI.Button({
				text = "Spawn",
				on_click = function()
					Debug.log("INFO", "dbg_entity_spawner", "Spawning entity with name: " .. event.value)
					local px, py, pz = player.get_pos(playerid)
					entities.spawn(event.value, { px, py, pz })
				end,
			})
		end)
	end)
end)

function on_open()
	handle = K.mount({
		target = document.root,
		theme = UI.theme(),
		content = Screen,
	})
end

function on_close()
	if handle then
		handle:dispose()
		handle = nil
	end
end
