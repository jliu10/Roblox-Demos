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

-- In my game, I have a Tool (a wand) that has a local script that fires the WandActivated RemoteEvent. It passes the mouseHit as an argument.
-- In your game, you should probably fire a differently named event from your own Tool.
wandActivated.OnServerEvent:Connect(function(player: Player, mouseHit: CFrame)
	print(`Wand activated`)

	SimulationManager:CreateProjectile(player, mouseHit)
end)

RunService.Heartbeat:Connect(function(dt: number)
	SimulationManager:OnHeartbeat(dt)
end)
