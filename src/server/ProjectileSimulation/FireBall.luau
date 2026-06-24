local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileData = require(ReplicatedStorage.Shared.ProjectileSimulation.ProjectileData)
local Types = require(ReplicatedStorage.Shared.ProjectileSimulation.Types)

type SimulationParams = Types.SimulationParams

local remoteEvents = ReplicatedStorage.RemoteEvents
local projectileChanged = remoteEvents.ProjectileChanged

local projectiles = ReplicatedStorage:WaitForChild("Projectiles")
local sourceFireBall = projectiles:WaitForChild("FireBall")
local root = sourceFireBall.Root

local FIREBALL_RADIUS = math.max(root.Size.X, root.Size.Y, root.Size.Z) / 2
local SPEED = ProjectileData.FireBall.Speed

local FireBall = {}

function FireBall.OnHeartbeat(
	projectileId: string,
	simulationParams: SimulationParams,
	deltaTime: number
): SimulationParams?
	local currentPosition = simulationParams.Position
	if simulationParams.RemainingLifetime == nil then
		error("SimulationParams has no RemainingLifetime")
	end

	-- First check if the projectile expired
	if simulationParams.RemainingLifetime <= 0 then
		local projectileChangedParams = {
			ObjectId = projectileId,
			Event = "Expired",
			Position = currentPosition,
		}
		projectileChanged:FireAllClients(projectileChangedParams)
		return nil
	end

	local travelVector = simulationParams.Direction * SPEED * deltaTime

	-- Modify the raycastParams properties if you want to prevent friendly fire.
	-- i.e. filter out the characters of the caster and their allies.
	local raycastParams = RaycastParams.new()

	-- Perform a Spherecast along the path of travel using the fireball's radius
	local result = workspace:Spherecast(currentPosition, FIREBALL_RADIUS, travelVector, raycastParams)

	-- Then check for hit detection
	if result then
		local projectileChangedParams = {
			ObjectId = projectileId,
			Event = "Hit",
			Position = result.Position,
		}
		projectileChanged:FireAllClients(projectileChangedParams)
		return nil
	end

	-- Finally, we can move the projectile
	local newPosition = currentPosition + travelVector
	local remainingLifetime = simulationParams.RemainingLifetime - deltaTime
	local newState = {
		Position = newPosition,
		Direction = simulationParams.Direction,
		ProjectileType = "FireBall",
		RemainingLifetime = remainingLifetime,
	}

	return newState
end

return FireBall
