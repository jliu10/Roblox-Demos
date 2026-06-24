local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FireBall = require(script.Parent.FireBall)
local Types = require(ReplicatedStorage.Shared.ProjectileSimulation.Types)

type SimulationParams = Types.SimulationParams

--[[
	This module is useful if you have different projectile types.
	For each projectile type, there should be a corresponding module that handles the projectile's behavior. It should implement the OnHeartbeat()
	function, which should be called in a conditional check below.
]]
local ProjectileFactory = {}

function ProjectileFactory.OnHeartbeat(projectileId: string, simulationParams: SimulationParams, deltaTime: number): SimulationParams?
	local projectileType = simulationParams.ProjectileType
	if projectileType == "FireBall" then
		return FireBall.OnHeartbeat(projectileId, simulationParams, deltaTime)
	-- Add other entries via `elseif` statements
	else
		warn(`Unknown projectile type: {projectileType}`)
		return nil
	end
end

return ProjectileFactory