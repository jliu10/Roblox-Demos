export type RealProjectileParams = {
	ProjectileType: string,
	Direction: Vector3,
	RemainingLifetime: number,
}

export type SimulationParams = {
	ProjectileType: string,
	Direction: Vector3,
	RemainingLifetime: number,
	Position: Vector3,
}

export type ProjectileInstanceParams = {
	ProjectileType: string,
	Direction: Vector3,
	ObjectId: string,
	Instance: Instance,
}

export type ProjectileRendererParams = {
	ProjectileType: string,
	Origin: CFrame,
	Direction: Vector3,
	ObjectId: string,
}

export type ProjectilePreRenderParams = {
	Dt: number,
	ProjectileType: string,
	Instance: Instance,
	Direction: Vector3,
}

return nil