local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProjectileData = require(ReplicatedStorage.Shared.ProjectileSimulation.ProjectileData)

local USE_SIMULATION = false

local remoteEvents = ReplicatedStorage.RemoteEvents
local projectileCreated = remoteEvents:FindFirstChild("ProjectileCreated")
local projectileChanged = remoteEvents:FindFirstChild("ProjectileChanged")

if not projectileCreated then
	projectileCreated = Instance.new("RemoteEvent")
	projectileCreated.Name = "ProjectileCreated"
	projectileCreated.Parent = remoteEvents
end

if not projectileChanged then
	projectileChanged = Instance.new("RemoteEvent")
	projectileChanged.Name = "ProjectileChanged"
	projectileChanged.Parent = remoteEvents
end

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
}

type RealProjectileParams = {
	ProjectileType: string,
	Direction: Vector3,
	RemainingLifetime: number,
}

function SimulationManager:CreateProjectile(player: Player, mouseHit: CFrame)
	-- Create fireball in front of player
	local fireBall = sourceFireBall:Clone()
	fireBall.Parent = workspace
	local character = player.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	fireBall:PivotTo(humanoidRootPart.CFrame * CFrame.new(0, 0, -5))
	local origin = fireBall:GetPivot()
	local direction = (mouseHit.Position - origin.Position).Unit

	local projectileType = "FireBall"
	local lifetime = ProjectileData[projectileType].Lifetime
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
