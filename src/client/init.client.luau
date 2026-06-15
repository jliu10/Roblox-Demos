local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProjectileInstanceManager = require(script.ProjectileSimulation.ProjectileInstanceManager)
local ProjectileRendererFactory = require(script.ProjectileSimulation.ProjectileRendererFactory)
local RunService = game:GetService("RunService")

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local projectileCreated = remoteEvents:WaitForChild("ProjectileCreated")
local projectileChanged = remoteEvents:WaitForChild("ProjectileChanged")

local bindableEvents = script.Parent:WaitForChild("BindableEvents")
local projectileRendered = bindableEvents:WaitForChild("ProjectileRendered")

type ProjectileRendererParams = {
	ProjectileType: string,
	Origin: CFrame,
	Direction: Vector3,
	ObjectId: string,
}

type ProjectileInstanceParams = {
	ProjectileType: string,
	Direction: Vector3,
	ObjectId: string,
	Instance: Instance,
}

local function onProjectileCreated(params: ProjectileRendererParams)
	ProjectileRendererFactory.Render(params)
end

projectileCreated.OnClientEvent:Connect(onProjectileCreated)

projectileRendered.Event:Connect(function(params: ProjectileInstanceParams)
	ProjectileInstanceManager:RegisterObject(params)
end)

RunService.PreRender:Connect(function(dt: number)
	ProjectileInstanceManager:OnPreRender(dt)
end)
