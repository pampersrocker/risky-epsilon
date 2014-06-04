
LevelMeta = {}


function LevelMeta:initializeGameObject()
	logMessage("LevelMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(1000,1000,1))
	cinfo.motionType = MotionType.Fixed
	--cinfo.mass = 100.0
	cinfo.restitution = 0.0
	cinfo.friction = 10.0
	--cinfo.maxLinearVelocity = 300.0
	--cinfo.maxAngularVelocity = 2.0
	----cinfo.linearDamping = 1.0
	--cinfo.angularDamping = 10.0
	cinfo.position = Vec3(0.0, 0.0, 0.0)

	CreatePhysicsComponent( self , cinfo )
	--CreateRenderComponent(self, "data/models/plane.thModel")
	logMessage("LevelMeta:init() end")

end

function LevelMeta.update( guid, elapsedTime )
end

function LevelMeta.init( guid )
	-- body
end

function LevelMeta.destroy( ... )
	-- body
	logMessage("DESTROY!")
end

