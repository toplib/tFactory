local Item = {
	id = "tfactory:void",
	title = "Void",
	description = "This might be bug :/",
	on_interact = nil,
	is_interactable = false,
}

local function create(data)
	return {
		id = data.id or Item.id,
		title = data.title or "Unknown",
		description = data.description or "Unknown",
		on_interact = data.on_interact,
		is_interactable = data.is_interactable == true,
	}
end

return function(data)
	if data.id == nil then
		print("tFactory - WARN | Cannot instance Item because id is 'nil', using void.")
		return create(Item)
	end
	return create(data)
end
