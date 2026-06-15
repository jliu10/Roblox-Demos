local FireBallRenderer = require(script.Parent.FireBallRenderer)

local ProjectileRendererFactory = {}

type ProjectileRendererParams = {
	ProjectileType: string,
	Origin: CFrame,
	Direction: Vector3,
	ObjectId: string,
}

type ProjectilePreRenderParams = {
	Dt: number,
	ProjectileType: string,
	Instance: Instance,
	Direction: Vector3,
}

function ProjectileRendererFactory.Render(params: ProjectileRendererParams): Instance
	if params.ProjectileType == "FireBall" then
		return FireBallRenderer.Render(params)
	else
		error(`Unknown projectile type: {params.ProjectileType}`)
	end
end

function ProjectileRendererFactory.OnPreRender(params: ProjectilePreRenderParams)
	if params.ProjectileType == "FireBall" then
		FireBallRenderer.OnPreRender(params)
	else
		warn(`Unknown projectile type: {params.ProjectileType}`)
	end
end

return ProjectileRendererFactory
