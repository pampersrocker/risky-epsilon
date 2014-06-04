
PlayerMeta = {}


function PlayerMeta.update( guid, elapsedTime )
end

function PlayerMeta.init( guid )
	logMessage("PlayerMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(1)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 100.0
	cinfo.restitution = 0.0
	cinfo.friction = 10.0
	cinfo.maxLinearVelocity = 300.0
	cinfo.maxAngularVelocity = 2.0
	--cinfo.linearDamping = 1.0
	cinfo.angularDamping = 10.0
	cinfo.position = Vec3(0.0, 0.0, 2.0)
	go = GetGObyGUID(guid)
	--CreatePhysicsComponent( go , cinfo )
	CreateRenderComponent(go, "data/models/ball.thmodel")
	logMessage("PlayerMeta:init() end")

end

function PlayerMeta.destroy( ... )
	-- body
	logMessage("DESTROY!")
end

