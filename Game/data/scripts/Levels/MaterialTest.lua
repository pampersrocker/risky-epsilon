
LevelMeta = {}


function LevelMeta.update( guid, elapsedTime )
end

function LevelMeta.initialize( guid )
	logMessage("LevelMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(1)
	cinfo.motionType = MotionType.Fixed
	cinfo.mass = 100.0
	cinfo.restitution = 0.0
	cinfo.friction = 10.0
	cinfo.maxLinearVelocity = 300.0
	cinfo.maxAngularVelocity = 2.0
	--cinfo.linearDamping = 1.0
	cinfo.angularDamping = 10.0
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	go = GetGObyGUID(guid)
	CreatePhysicsComponent( go , cinfo )
	CreateRenderComponent(go, "data/models/plane.thModel")
	logMessage("LevelMeta:init() end")

end

function LevelMeta.destroy( ... )
	-- body
	logMessage("DESTROY!")
end

