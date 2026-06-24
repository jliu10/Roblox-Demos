local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ProjectileInstanceManager = require(script.ProjectileSimulation.ProjectileInstanceManager)
local ProjectileRendererFactory = require(script.ProjectileSimulation.ProjectileRendererFactory)
local Types = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ProjectileSimulation"):WaitForChild("Types"))

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local projectileCreated = remoteEvents:WaitForChild("ProjectileCreated")
local projectileChanged = remoteEvents:WaitForChild("ProjectileChanged")

local bindableEvents = script.Parent:WaitForChild("BindableEvents")
local projectileRendered = bindableEvents:WaitForChild("ProjectileRendered")

type ProjectileRendererParams = Types.ProjectileRendererParams
type ProjectileInstanceParams = Types.ProjectileInstanceParams

local function onProjectileCreated(params: ProjectileRendererParams)
	ProjectileRendererFactory.Render(params)
end

projectileCreated.OnClientEvent:Connect(onProjectileCreated)

projectileChanged.OnClientEvent:Connect(function(params: ProjectileInstanceParams)
    ProjectileInstanceManager:OnProjectileChanged(params)
end)

projectileRendered.Event:Connect(function(params: ProjectileInstanceParams)
	ProjectileInstanceManager:RegisterObject(params)
end)

RunService.PreRender:Connect(function(dt: number)
	ProjectileInstanceManager:OnPreRender(dt)
end)
