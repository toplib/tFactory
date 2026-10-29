local Furnace = {}

local Debug = require("Debug")

function Furnace.constructor(parameters)
  Debug.log("DEBUG", "Furnace", "Furnace.constructor()")
end

function Furnace.work(data)
  Debug.log("DEBUG", "Furnace", "Furnace.work()")
end

return Furnace
