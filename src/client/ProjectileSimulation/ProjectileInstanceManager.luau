local ProjectileRendererFactory = require(script.Parent.ProjectileRendererFactory)

local ProjectileInstanceManager = {
	ProjectileObjects = {
		--[[
        [string]: {
            Instance_: Instance,
            ProjectileType: string,
            ...
        }
        ]]
	},
}

type ProjectileInstanceParams = {
	ProjectileType: string,
	Direction: Vector3,
	ObjectId: string,
	Instance: Instance,
}

function ProjectileInstanceManager:RegisterObject(params: ProjectileInstanceParams)
	self.ProjectileObjects[params.ObjectId] = {
		Instance_ = params.Instance,
		ProjectileType = params.ProjectileType,
		Direction = params.Direction,
	}
end

function ProjectileInstanceManager:OnPreRender(dt: number)
	for _objectId, data in pairs(self.ProjectileObjects) do
		local projectilePreRenderParams = {
			Dt = dt,
			ProjectileType = data.ProjectileType,
			Instance = data.Instance_,
			Direction = data.Direction,
		}

		ProjectileRendererFactory.OnPreRender(projectilePreRenderParams)
	end
end

return ProjectileInstanceManager
