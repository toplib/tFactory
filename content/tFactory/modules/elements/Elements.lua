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
    Events.dispatch("onElementsDatabaseElementAdd", {
      id = element.id,
      class = element.class,
    })
  end
end

function Elements.Elements()
  Debug.log("INFO", "Elements", "Initializing elements database")
  registerEvents()
  registerElements()
end

function Elements.getById(id)
  for i = 1, #Elements.elements do
    if Elements.elements[i].id == id then
      return Elements.elements[i]
    end
  end
  return nil
end

return Elements
