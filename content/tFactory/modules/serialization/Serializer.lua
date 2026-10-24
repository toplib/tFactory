local Serializer = {}

function Serializer.serializeVector3(value)
	return "x:" .. value.x .. "y:" .. value.y .. "z:" .. value.z
end

function Serializer.deserializeVector3(value)
	return {
		x = tonumber(value:match("x:(%-?%d+%.?%d*)")),
		y = tonumber(value:match("y:(%-?%d+%.?%d*)")),
		z = tonumber(value:match("z:(%-?%d+%.?%d*)")),
	}
end
return Serializer
