local Events = {}

local Debug = require("Debug")
function Events.registerEvent(onDispatch, name)
	if Events[name] ~= nil then
		print('tFactory - Events | Event "' .. name .. '", already registered!')
		return
	end

	Events[name] = {
		subscribers = {},
		onDispatch = onDispatch,
	}
end

function Events.subscribe(name, onDispatch)
	if Events[name] == nil then
		Debug.log("WARN", "Events", 'Event "' .. name .. '", cannot be found!')
		return
	end

	if type(onDispatch) ~= "function" then
		Debug.log("WARN", "Events",
			'Event "' .. name .. '", subscriber is not a function!')
		return
	end

	local t = Events[name]["subscribers"]
	for i = 1, #t do
		if t[i] == onDispatch then
			return
		end
	end

	t[#t + 1] = onDispatch
end

function Events.unsubscribe(name, onDispatch)
	if Events[name] == nil then
		Debug.log("WARN", "Events", 'Event "' .. name .. '", cannot be found!')
		return
	end

	local t = Events[name]["subscribers"]
	for i = 1, #t do
		if t[i] == onDispatch then
			table.remove(t, i)
			return
		end
	end
end

function Events.has(name)
	if Events[name] == nil then
		return false
	end
	return true
end

function Events.dispatch(name, arguments)
	if Events[name] == nil then
		Debug.log("WARN", "Events", 'Event "' .. name .. '", cannot be found!')
		return
	end

	local event = Events[name]

	local subscribers = {}
	for i = 1, #event["subscribers"] do
		subscribers[i] = event["subscribers"][i]
	end

	if type(event["onDispatch"]) == "function" then
		event["onDispatch"](arguments)
	end

	for i = 1, #subscribers do
		if type(subscribers[i]) == "function" then
			subscribers[i](arguments)
		else
			Debug.log("WARN", "Events",
				"Function in " .. name .. '", cannot be executed!')
		end
	end
end

return Events
