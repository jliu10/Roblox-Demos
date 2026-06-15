local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileData = require(ReplicatedStorage.Shared.ProjectileSimulation.ProjectileData)

local USE_SIMULATION = true

local remoteEvents = ReplicatedStorage.RemoteEvents
local projectileCreated = Instance.new("RemoteEvent")
projectileCreated.Name = "ProjectileCreated"
projectileCreated.Parent = remoteEvents

local projectileChanged = Instance.new("RemoteEvent")
projectileChanged.Name = "ProjectileChanged"
projectileChanged.Parent = remoteEvents

local sourceFireBall = ReplicatedStorage.Projectiles.FireBall

local SimulationManager = {
	RealProjectiles = {
		--[[
        [Instance] = {
            ProjectileType: string,
            Direction: Vector3,
            RemainingLifetime: number
        }
        ]]
	},
	Simulations = {
		--[[
        [string] = {
            Position: Vector3,
            Direction: Vector3,
        }
        ]]
	},
}

type RealProjectileParams = {
	ProjectileType: string,
	Direction: Vector3,
	RemainingLifetime: number,
}

type SimulationParams = {
	ProjectileType: string,
	Direction: Vector3,
	RemainingLifetime: number,
	Position: Vector3,
}

function SimulationManager:CreateSimulation(player: Player, simulationParams: SimulationParams): string
	local objectId = HttpService:GenerateGUID(false)
	self.Simulations[objectId] = simulationParams
	return objectId
end

function SimulationManager:CreateProjectile(player: Player, mouseHit: CFrame)
	-- Create fireball in front of player
	local character = player.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local projectileType = "FireBall"
	local lifetime = ProjectileData[projectileType].Lifetime
	local origin = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
	local direction = (mouseHit.Position - origin.Position).Unit

	if USE_SIMULATION then
		local simulationParams = {
			ProjectileType = projectileType,
			Position = origin.Position,
			Direction = direction,
			RemainingLifetime = lifetime,
		}
		local objectId = SimulationManager:CreateSimulation(player, simulationParams)
		local projectileRendererParams = {
			ObjectId = objectId,
			ProjectileType = projectileType,
			Origin = origin,
			Direction = direction,
		}
		projectileCreated:FireAllClients(projectileRendererParams)
		return
	end

	local fireBall = sourceFireBall:Clone()
	fireBall.Parent = workspace
	fireBall:PivotTo(origin)

	local params = {
		ProjectileType = projectileType,
		Direction = direction,
		RemainingLifetime = lifetime,
	}
	self.RealProjectiles[fireBall] = params
end

function SimulationManager:OnHeartbeat(dt: number)
	for fireBall, params in pairs(self.RealProjectiles) do
		params.RemainingLifetime -= dt
		if params.RemainingLifetime <= 0 then
			fireBall:Destroy()
			self.RealProjectiles[fireBall] = nil
			continue
		end

		-- Check for hit
		local overlapParams = OverlapParams.new()
		overlapParams.RespectCanCollide = true
		local partsInFireBall = workspace:GetPartsInPart(fireBall.Root, overlapParams)

		-- Also ignore the caster/teammates in your actual game!
		if #partsInFireBall > 0 then
			-- Add explosion, damage, etc. here
			print("FireBall hit!")
			fireBall:Destroy()
			self.RealProjectiles[fireBall] = nil
			continue
		end

		fireBall:MoveTo(fireBall.Root.Position + params.Direction * ProjectileData[params.ProjectileType].Speed * dt)
	end
end

return SimulationManager
