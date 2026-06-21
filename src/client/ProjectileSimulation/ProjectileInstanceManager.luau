local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileRendererFactory = require(script.Parent.ProjectileRendererFactory)
local Types =
	require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ProjectileSimulation"):WaitForChild("Types"))

type ProjectileInstanceParams = Types.ProjectileInstanceParams

local ProjectileInstanceManager = {
	ProjectileObjects = {
		--[[
        [string]: {
            Instance: Instance,
            ProjectileType: string,
            ...
        }
        ]]
	},
}

function ProjectileInstanceManager:RegisterObject(params: ProjectileInstanceParams)
	self.ProjectileObjects[params.ObjectId] = {
		Instance = params.Instance,
		ProjectileType = params.ProjectileType,
		Direction = params.Direction,
	}
end

local function DestroyObject(id: string)
	if ProjectileInstanceManager.ProjectileObjects[id] == nil then
		return
	end

	ProjectileInstanceManager.ProjectileObjects[id].Instance:Destroy()
	ProjectileInstanceManager.ProjectileObjects[id] = nil
end

function ProjectileInstanceManager:OnProjectileChanged(projectileInstanceParams)
	local id = projectileInstanceParams.ObjectId
	local event = projectileInstanceParams.Event
	print(`Received ProjectileChanged event`)

	if event == "Hit" or event == "Expired" then
		DestroyObject(id)
	end
end

function ProjectileInstanceManager:OnPreRender(dt: number)
	for _objectId, data in pairs(self.ProjectileObjects) do
		local projectilePreRenderParams = {
			Dt = dt,
			ProjectileType = data.ProjectileType,
			Instance = data.Instance,
			Direction = data.Direction,
		}

		ProjectileRendererFactory.OnPreRender(projectilePreRenderParams)
	end
end

return ProjectileInstanceManager
