
LevelMeta = {}

function LevelMeta:initializeTrack_ice()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/roundtrack_ice.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.track.ice.restitution
	cinfo.friction = Config.materials.track.ice.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/roundtrack_ice.thModel")
end

function LevelMeta:initializeTrack_wood()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/roundtrack_wood.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.track.wood.restitution
	cinfo.friction = Config.materials.track.wood.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/roundtrack_wood.thModel")
end

function createPhantomCallbackTriggerBox(guid, halfExtends, position)
	local trigger = GameObjectManager:createGameObject(guid)
	trigger.pc = trigger:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	local boundingShape = PhysicsFactory:createBox(halfExtends)
	local phantomCallbackShape = PhysicsFactory:createPhantomCallbackShape(halfExtends)
	cinfo.shape = PhysicsFactory:createBoundingVolumeShape(boundingShape, phantomCallbackShape)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	trigger.pc.rb = trigger.pc:createRigidBody(cinfo)
	trigger.phantomCallback = phantomCallbackShape

	return trigger
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

