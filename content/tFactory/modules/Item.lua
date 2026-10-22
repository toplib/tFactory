local Item = {
	id = "tfactory:void",
	title = "Void",
	description = "This might be bug :/",
	on_interact = nil,
	is_interactable = false,
}

return function(data)
	if data.id == nil then
		print("tFactory - WARN | Cannot instance Item beacause id is 'nil', using void. \n Ret - Item:Void")
		return Item
	else
		Item.id = data.id
	end

	if data.title == nil then
		print("tFactory - INFO | Cannot instance Item beacause title is 'nil', using void. \n Continue")
		Item.title = "Unknown"
	else
		Item.id = data.id
	end

	if data.description == nil then
		print("tFactory - INFo | Cannot instance Item beacause description is 'nil', using void. \n Continue")
		Item.description = "Unknown"
	else
		Item.description = data.description
	end

	if data.on_interact == nil then
		print("tFactory - INFO | Cannot instance Item beacause on_interact is 'nil', using void. \n Continue")
		Item.on_interact = nil
	else
		Item.on_interact = data.on_interact
	end

	if data.is_interactable == nil then
		print("tFactory - INFO | Cannot instance Item beacause is_interactable is 'nil', using void. \n Continue")
		Item.is_interactable = nil
	else
		Item.is_interactable = data.is_interactable
	end
	return Item
end
