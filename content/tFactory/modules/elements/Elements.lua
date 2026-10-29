local Elements = {}

local Debug = require("Debug")
local Events = require("Events")

Elements.elements = {
  {
    id = "tfactory:furnace",
    class = {
      "tfactory:class:any"
    },
    element = require("elements/Furnace"),
  }
}

local function registerEvent(name)
  Debug.log("INFO", "Elements", "Register event " .. name)
  Events.registerEvent(function(arguments)
      Debug.log("DEBUG", "Elements",
        "Executing, event " .. name)
    end,
    name)
end

local function registerEvents()
  Debug.log("INFO", "Elements", "Reach target: Register Events")
  registerEvent("onElementsDatabaseElementAdd")
  registerEvent("onElementsDatabaseElementRemove")
end


local function registerElements()
  Debug.log("INFO", "Elements", "Reach target: Register Elements")
  for _, element in ipairs(Elements.elements) do
    Debug.log("INFO", "Elements", "Registering element " .. element.id)
    element.element.constructor({ data = false })
  end
end

function Elements.Elements()
  Debug.log("INFO", "Elements", "Initializing elements database")
  registerEvents()
  registerElements()
end

return Elements
