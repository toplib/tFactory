local K = require("kompot:kompot")
local UI = require("kompot:ui")
local tFactory = require("tfactory:tFactory")
local handle

local Screen = K.component(function()
	local isVaultOpen = K.state(0)
	isVaultOpen.value = false

	local globalPanelName = K.state(0)

	local core_health = tFactory.getCoreHealth()

	K.Box({ modifier = K.M:fill_max_size() }, function()
		UI.Panel({ title = "Core", modifier = K.M:align("center") }, function()
			if not isVaultOpen.value then
				K.Text("Monitoring:")
				K.Text("Health: " .. core_health.health)
				K.Text("Max Health: " .. core_health.max_health)
				K.Text("Vault Items: " .. 1751)
				K.Text("Vault Max Items: " .. 3000)
				UI.Button({
					text = "Open Vault",
					on_click = function()
						isVaultOpen.value = true
						print("True")
					end,
				})
			else
				K.Text("Vault:")

				UI.Panel({ title = "Iron Ore", modifier = K.M:align("center") }, function()
					K.Text("Count: " .. 571)
				end)

				UI.Button({
					text = "Close Vault",
					on_click = function()
						isVaultOpen.value = false
						print("False")
					end,
				})
			end
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
