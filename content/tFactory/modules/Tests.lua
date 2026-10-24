local Tests = {}

local Debug = require("Debug")

Tests.tests = {
	{
		name = "Serializer, vector3 serialize",
		func = function()
			local Serializer = require("serialization/Serializer")
			return Serializer.serializeVector3({ x = 3, y = 4, z = 5 })
		end,
		value = "x:3y:4z:5",
		class = "serialization",
	},
	{
		name = "Serializer, vector3 deserialize",
		func = function()
			local Serializer = require("serialization/Serializer")
			return Serializer.deserializeVector3("x:3y:4z:5")
		end,
		value = { x = 3, y = 4, z = 5 },
		class = "serialization",
	},
}

local function equal(a, b)
	if type(a) ~= type(b) then
		return false
	end
	if type(a) ~= "table" then
		return a == b
	end
	for k, v in pairs(a) do
		if not equal(v, b[k]) then
			return false
		end
	end
	for k in pairs(b) do
		if a[k] == nil then
			return false
		end
	end
	return true
end
local function tAssert(value, func, name)
	if name == nil then
		name = "Unknown"
	end
	if not equal(value, func()) then
		Debug.log("ERROR", "Tests", "Test with name: " .. name .. ", failed!")
		return false
	end

	Debug.log("INFO", "Tests", "Test with name: " .. name .. ", passed.")
	return true
end

function Tests.startAll()
	Debug.log("INFO", "Tests", "Starting all tests")
	local passed = 0
	local notPassed = 0
	local total = #Tests.tests

	for _, test in ipairs(Tests.tests) do
		if tAssert(test.value, test.func, test.name) then
			passed = passed + 1
		else
			notPassed = notPassed + 1
		end
	end

	Debug.log("INFO", "Tests", "Passed: " .. passed .. ", Not Passed: " .. notPassed .. ", Total: " .. total)
end

return Tests
