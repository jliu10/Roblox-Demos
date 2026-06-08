local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SimulationManager = require(script.ProjectileSimulation.SimulationManager)

local remoteEvents = ReplicatedStorage.RemoteEvents
local wandActivated = remoteEvents:FindFirstChild("WandActivated")

if not wandActivated then
    wandActivated = Instance.new("RemoteEvent")
    wandActivated.Name = "WandActivated"
    wandActivated.Parent = remoteEvents
end

wandActivated.OnServerEvent:Connect(function(player: Player, mouseHit: CFrame)
    print(`Wand activated`)

    SimulationManager:CreateProjectile(player, mouseHit)
end)


RunService.Heartbeat:Connect(function(dt: number)
	SimulationManager:OnHeartbeat(dt)
end)
