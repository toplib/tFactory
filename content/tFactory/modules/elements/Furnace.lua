local Furnace = {
  meltable = {
    {
      source = "tfactory:iron_ore",
      result = "tfactory:iron_ingot",
      count = 1,
      time = 2.0,
    },
    {
      source = "tfactory:copper_ore",
      result = "tfactory:copper_ingot",
      count = 1,
      time = 2.0,
    },
  },
  fuels = {
    ["tfactory:coal"] = 8.0,
    ["tfactory:wood_plank"] = 4.0,
  },
}

local Debug = require("Debug")

function Furnace.getRecipe(itemId)
  if itemId == nil then
    return nil
  end
  for i = 1, #Furnace.meltable do
    if itemId == Furnace.meltable[i].source then
      return Furnace.meltable[i]
    end
  end
  return nil
end

function Furnace.canMelt(itemId)
  return Furnace.getRecipe(itemId)
end

function Furnace.getFuel(itemId)
  if itemId == nil then
    return nil
  end
  return Furnace.fuels[itemId]
end

function Furnace.constructor(parameters)
  Debug.log("DEBUG", "Furnace", "Furnace.constructor()")
end

function Furnace.work(data)
  Debug.log("DEBUG", "Furnace", "Furnace.work()")
end

return Furnace
