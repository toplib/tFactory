local Events = {}

function Events.registerEvent(onExecute, name)
	if Events[name] ~= nil then
		print('tFactory - Events | Event "' .. name .. '", already registered!')
		return
	end

	Events[name] = {
		subscribers = {},
		onExecute = onExecute,
	}
end

function Events.subscribe(name, onExecute)
	if Events[name] == nil then
		print('tFactory - Events | Event "' .. name .. '", cannot be found!')
		return
	end

	if type(onExecute) ~= "function" then
		print('tFactory - Events | Event "' .. name .. '", subscriber is not a function!')
		return
	end

	local t = Events[name]["subscribers"]
	for i = 1, #t do
		if t[i] == onExecute then
			return
		end
	end

	t[#t + 1] = onExecute
end

function Events.unsubscribe(name, onExecute)
	if Events[name] == nil then
		print('tFactory - Events | Event "' .. name .. '", cannot be found!')
		return
	end

	local t = Events[name]["subscribers"]
	for i = 1, #t do
		if t[i] == onExecute then
			table.remove(t, i)
			return
		end
	end
end

function Events.execute(name, arguments)
	if Events[name] == nil then
		print('tFactory - Events | Event "' .. name .. '", cannot be found!')
		return
	end

	local event = Events[name]

	local subscribers = {}
	for i = 1, #event["subscribers"] do
		subscribers[i] = event["subscribers"][i]
	end

	if type(event["onExecute"]) == "function" then
		event["onExecute"](arguments)
	end

	for i = 1, #subscribers do
		if type(subscribers[i]) == "function" then
			subscribers[i](arguments)
		else
			print("tFactory - Events | Function in " .. name .. '", cannot be executed!')
		end
	end
end

return Events
