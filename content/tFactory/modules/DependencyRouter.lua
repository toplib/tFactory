local DependencyRouter = {}

function DependencyRouter.route(route)
	return require(route)
end

return DependencyRouter
