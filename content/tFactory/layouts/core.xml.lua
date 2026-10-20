local K = require("kompot:kompot")
local UI = require("kompot:ui")
local handle

local Screen = K.component(function()
	local count = K.state(0)

	UI.Panel({ title = "Первый экран" }, function()
		K.Text("Нажатий: " .. count.value)
		UI.Button({
			text = "Нажать",
			on_click = function()
				count.value = count:peek() + 1
			end,
		})
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
