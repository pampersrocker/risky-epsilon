
FractureMeta = {}

function FractureMeta:InitializeWoodFracture( configTable )
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh(configTable.collFile)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = configTable.mass
	cinfo.restitution = Config.materials.track.ice.restitution
	cinfo.friction = Config.materials.track.ice.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, configTable.model)
end

FractureMeta.__index = FractureMeta