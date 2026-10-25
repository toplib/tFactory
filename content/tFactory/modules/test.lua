local K = require("kompot:kompot")
local UI = require("kompot:ui")
local M = K.M

local Screen = K.component(function(props)
	UI.Button({}, function()
		K.Text("Test")
	end)
end)

K.preview("Screen", { width = 400, height = 300, theme = UI.theme() }, function()
	Screen({})
end)

return { Screen = Screen }

