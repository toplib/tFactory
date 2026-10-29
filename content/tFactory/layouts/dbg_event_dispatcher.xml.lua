local K = require("kompot:kompot")
local UI = require("kompot:ui")
local Events = require("Events")
local handle

local Screen = K.component(function()
	local event = K.state("nil")
	local readonly = K.state(false)

	K.Box({ modifier = K.M:fill_max_size() }, function()
		UI.Panel(
			{
				title = "Debug tFactory Event dispatcher",
				modifier = K.M:align("center")
			}, function()
				UI.TextField({
					state = event,
					label = "Name",
					editable = not readonly.value,
					supporting = "This event will be dispatcher",
				})
				UI.Button({
					text = "Dispatch",
					on_click = function()
						Events.dispatch(event.value, {})
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
