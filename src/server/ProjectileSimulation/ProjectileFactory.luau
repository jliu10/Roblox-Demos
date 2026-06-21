local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FireBall = require(script.Parent.FireBall)
local Types = require(ReplicatedStorage.Shared.ProjectileSimulation.Types)

type SimulationParams = Types.SimulationParams

local ProjectileFactory = {}

function ProjectileFactory.OnHeartbeat(projectileId: string, simulationParams: SimulationParams, deltaTime: number): SimulationParams?
	local projectileType = simulationParams.ProjectileType
	if projectileType == "FireBall" then
		return FireBall.OnHeartbeat(projectileId, simulationParams, deltaTime)
	else
		warn(`Unknown projectile type: {projectileType}`)
		return nil
	end
end

return ProjectileFactory