local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileData = require(
	ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ProjectileSimulation"):WaitForChild("ProjectileData")
)

local bindableEvents = script.Parent.Parent.Parent:WaitForChild("BindableEvents")
local projectileRendered = Instance.new("BindableEvent")
projectileRendered.Name = "ProjectileRendered"
projectileRendered.Parent = bindableEvents

local SPEED = ProjectileData.FireBall.Speed

local projectiles = ReplicatedStorage:WaitForChild("Projectiles")
local sourceFireBall = projectiles:WaitForChild("FireBall")

local FireBallRenderer = {}

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

type ProjectileInstanceParams = {
	ProjectileType: string,
	Direction: Vector3,
	ObjectId: string,
	Instance: Instance,
}

function FireBallRenderer.Render(params: ProjectileRendererParams): Model
	local origin = params.Origin
	local castOffset = CFrame.new(0, 0, -5)
	local spawnCFrame = origin * castOffset

	local newFireBall = sourceFireBall:Clone()
	newFireBall:PivotTo(spawnCFrame)
	newFireBall.Parent = workspace

	local direction = params.Direction
	if direction == nil then
		error(`Fireball created with no direction`)
	end

	local projectileInstanceParams: ProjectileInstanceParams = {
		ProjectileType = params.ProjectileType,
		Direction = params.Direction,
		ObjectId = params.ObjectId,
		Instance = newFireBall,
	}
	projectileRendered:Fire(projectileInstanceParams)

	return newFireBall
end

function FireBallRenderer.OnPreRender(params: ProjectilePreRenderParams)
	local instance = params.Instance

	if not instance:IsA("Model") then
		error("Object passed to FireBall.OnPreRender is not a Model")
	end

	instance:PivotTo(instance:GetPivot() + params.Direction * SPEED * params.Dt)
end

return FireBallRenderer
