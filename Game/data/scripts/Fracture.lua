
FractureMeta = {}

function FractureMeta:InitializeWoodFracture( configTable )
	local cinfo = RigidBodyCInfo()
	if configTable.useShape then
		cinfo.shape = PhysicsFactory:loadCollisionMesh(configTable.collFile)
	else
		cinfo.shape = PhysicsFactory:createBox(configTable.dimension)
	end
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = configTable.mass
	cinfo.restitution = Config.materials.track.ice.restitution
	cinfo.friction = Config.materials.track.ice.friction
	local offset = configTable.offset
	if configTable.randomOffset then
		offset = Vec3(math.random(0.0,1.0),math.random(0.0,1.0),math.random(0.0,1.0))
	end
	cinfo.position = offset
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, configTable.model)
end

FractureMeta.__index = FractureMeta