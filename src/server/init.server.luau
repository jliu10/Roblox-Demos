local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local remoteEvents = ReplicatedStorage.RemoteEvents

local wandActivated = Instance.new("RemoteEvent")
wandActivated.Name = "WandActivated"
wandActivated.Parent = remoteEvents

local projectileCreated = Instance.new("RemoteEvent")
projectileCreated.Name = "ProjectileCreated"
projectileCreated.Parent = remoteEvents

local projectileChanged = Instance.new("RemoteEvent")
projectileChanged.Name = "ProjectileChanged"
projectileChanged.Parent = remoteEvents

local SimulationManager = require(script.ProjectileSimulation.SimulationManager)

wandActivated.OnServerEvent:Connect(function(player: Player, mouseHit: CFrame)
    print(`Wand activated`)

    SimulationManager:CreateProjectile(player, mouseHit)
end)


RunService.Heartbeat:Connect(function(dt: number)
	SimulationManager:OnHeartbeat(dt)
end)
