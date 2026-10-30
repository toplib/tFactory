local Furnace = {}

local CellProcessor = require("CellProcessor")
local ItemStack = require("ItemStack")
local FurnaceElement = require("elements/Furnace")

Furnace.class = "tfactory:furnace"

Furnace.storage = {
  { key = "input", field = "input", type = "stack" },
  { key = "fuel", field = "fuel", type = "stack" },
  { key = "output", field = "output", type = "stack" },
  { key = "progress", field = "progress", type = "number" },
  { key = "burn", field = "burn", type = "number" },
}

local function mergeInto(cell, key, stack)
  local held = cell.state[key]
  if held == nil then
    local count = math.min(stack.count, ItemStack.max)
    cell.state[key] = ItemStack.copy(stack, count)
    stack.count = stack.count - count
  else
    ItemStack.merge(held, stack)
  end
end

local function canOutput(cell, recipe)
  local output = cell.state.output
  if output == nil then
    return true
  end
  return output.id == recipe.result
    and output.count + (recipe.count or 1) <= ItemStack.max
end

local function addOutput(cell, recipe)
  local output = cell.state.output
  if output == nil then
    cell.state.output = ItemStack.create(recipe.result, recipe.count or 1)
  else
    output.count = output.count + (recipe.count or 1)
  end
end

local function takeFrom(cell, key)
  local stack = cell.state[key]
  ItemStack.take(stack, 1)
  if stack.count <= 0 then
    cell.state[key] = nil
  end
end

Furnace.condition = function(cell)
  local state = cell.state
  if cell.blocked then
    return false
  end
  return state.output ~= nil
    or (state.input ~= nil and (state.burn > 0 or state.fuel ~= nil))
end

Furnace.acceptItem = function(cell, stack)
  if FurnaceElement.getRecipe(stack.id) ~= nil then
    return ItemStack.accepts(cell.state.input, stack.id)
  end
  if FurnaceElement.getFuel(stack.id) ~= nil then
    return ItemStack.accepts(cell.state.fuel, stack.id)
  end
  return false
end

Furnace.putItem = function(cell, stack)
  if FurnaceElement.getRecipe(stack.id) ~= nil then
    mergeInto(cell, "input", stack)
  else
    mergeInto(cell, "fuel", stack)
  end

  cell.blocked = false
  CellProcessor.markDirty(cell.x, cell.y, cell.z)
  return stack.count
end

Furnace.onPlaced = function(cell)
  cell.state.progress = cell.state.progress or 0
  cell.state.burn = cell.state.burn or 0
end

Furnace.work = function(cell, dt)
  local state = cell.state

  if state.output ~= nil then
    local left = CellProcessor.pushItem(cell, state.output)
    if left <= 0 then
      state.output = nil
      CellProcessor.markDirty(cell.x, cell.y, cell.z)
    else
      CellProcessor.block(cell)
      return
    end
  end

  local recipe = state.input and FurnaceElement.getRecipe(state.input.id)
  if recipe == nil then
    return
  end

  if state.burn <= 0 then
    local fuel = state.fuel and FurnaceElement.getFuel(state.fuel.id)
    if fuel == nil then
      CellProcessor.block(cell)
      return
    end

    state.burn = fuel
    takeFrom(cell, "fuel")
    CellProcessor.markDirty(cell.x, cell.y, cell.z)
  end

  state.burn = math.max(0, state.burn - dt)
  state.progress = state.progress + dt
  if state.progress < recipe.time then
    return
  end

  if not canOutput(cell, recipe) then
    return
  end

  state.progress = state.progress - recipe.time
  takeFrom(cell, "input")
  addOutput(cell, recipe)
  cell.blocked = false
  CellProcessor.markDirty(cell.x, cell.y, cell.z)
end

CellProcessor.registerTemplate(Furnace)

return Furnace
