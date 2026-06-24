local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileData = require(ReplicatedStorage.Shared.ProjectileSimulation.ProjectileData)
local ProjectileFactory = require(script.Parent.ProjectileFactory)
local Types = require(ReplicatedStorage.Shared.ProjectileSimulation.Types)

type SimulationParams = Types.SimulationParams
type RealProjectileParams = Types.RealProjectileParams

local USE_SIMULATION = false

local remoteEvents = ReplicatedStorage.RemoteEvents
local projectileCreated = remoteEvents:WaitForChild("ProjectileCreated")

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

function SimulationManager:CreateSimulation(simulationParams: SimulationParams): string
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
		local objectId = SimulationManager:CreateSimulation(simulationParams)
		local projectileRendererParams = {
			ObjectId = objectId,
			ProjectileType = projectileType,
			Origin = origin,
			Direction = direction,
		}
		projectileCreated:FireAllClients(projectileRendererParams)
		return
	end

	-- The following is only used for real projectiles!
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
	if USE_SIMULATION then
		-- The following is only used for simulated projectiles!
		for projectileId, simulationParams in pairs(self.Simulations) do
			local onHeartbeatResult = ProjectileFactory.OnHeartbeat(projectileId, simulationParams, dt)
			self.Simulations[projectileId] = onHeartbeatResult
		end
	else
		-- The following is only used for real projectiles!
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

			fireBall:MoveTo(
				fireBall.Root.Position + params.Direction * ProjectileData[params.ProjectileType].Speed * dt
			)
		end
	end
end

return SimulationManager
