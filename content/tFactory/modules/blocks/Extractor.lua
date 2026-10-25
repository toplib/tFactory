local Extractor = {}

local CellProcessor = require("CellProcessor")

Extractor.class = "tfactory:extractor"
Extractor.alwaysActive = true

Extractor.work = function(cell, dt)
	if cell.item ~= nil then
		if CellProcessor.pushItem(cell, cell.item) then
			cell.item = nil
		end
		return
	end

	cell.progress = cell.progress + dt
	if cell.progress < 1.0 then
		return
	end

	cell.progress = 0
	cell.item = "tfactory:iron_ore"
end

CellProcessor.registerTemplate(Extractor)

return Extractor
