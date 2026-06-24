local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FireBallRenderer = require(script.Parent.FireBallRenderer)
local Types =
	require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ProjectileSimulation"):WaitForChild("Types"))

--[[
	This module is useful if you have different projectile types.
	For each projectile type, there should be a corresponding module that handles the projectile's behavior. It should implement the OnPreRender()
	function, which should be called in a conditional check below.
]]
local ProjectileRendererFactory = {}

type ProjectileRendererParams = Types.ProjectileRendererParams
type ProjectilePreRenderParams = Types.ProjectilePreRenderParams

function ProjectileRendererFactory.Render(params: ProjectileRendererParams): Instance
	if params.ProjectileType == "FireBall" then
		return FireBallRenderer.Render(params)
	-- Add other entries via `elseif` statements
	else
		error(`Unknown projectile type: {params.ProjectileType}`)
	end
end

function ProjectileRendererFactory.OnPreRender(params: ProjectilePreRenderParams)
	if params.ProjectileType == "FireBall" then
		FireBallRenderer.OnPreRender(params)
	-- Add other entries via `elseif` statements
	else
		warn(`Unknown projectile type: {params.ProjectileType}`)
	end
end

return ProjectileRendererFactory
