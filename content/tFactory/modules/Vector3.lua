local Vector3 = {}

Vector3.x = 0
Vector3.y = 0
Vector3.z = 0

function Vector3.toString()
	return "x:" .. Vector3.x .. "y:" .. Vector3.y .. "z:" .. Vector3.z
end

function Vector3.toVector3(str) end

return Vector3
