
LevelMeta = {}


function LevelMeta:initializeGameObject()
	logMessage("LevelMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	--cinfo.shape = PhysicsFactory:createBox(Vec3(800,800,1))
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/track_parts_Default_1.hkx")
	cinfo.motionType = MotionType.Fixed
	--cinfo.mass = 100.0
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	--cinfo.maxLinearVelocity = 300.0
	--cinfo.maxAngularVelocity = 2.0
	----cinfo.linearDamping = 1.0
	--cinfo.angularDamping = 10.0
	cinfo.position = Vec3(0.0, 0.0, 0.0)

	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/track_test.thModel")
	
	
	
	
	GameLogic.trigger2 = createPhantomCallbackTriggerBox("trigger2", Vec3(2, 2, 2), Vec3(50.0, 0.0, 1.0))
	GameLogic.trigger2.phantomCallback:getEnterEvent():registerListener(function(arg)
		logMessage("Entering trigger volume 2!")
		
		local go = GetGObyGUID("playerInstancePaper")
		if not(GameLogic.isoCam.trackingObject == go) then
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.trigger2.phantomCallback:getLeaveEvent():registerListener(function(arg)
		logMessage("Leaving trigger volume 2!")
		return EventResult.Handled
	end)
	
	GameLogic.trigger1 = createPhantomCallbackTriggerBox("trigger1", Vec3(2, 2, 2), Vec3(50.0, 20.0, 1.0))
	GameLogic.trigger1.phantomCallback:getEnterEvent():registerListener(function(arg)
		logMessage("Entering trigger volume 1!")
		
		local go = GetGObyGUID("playerInstance")
		if not(GameLogic.isoCam.trackingObject == go) then
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.trigger1.phantomCallback:getLeaveEvent():registerListener(function(arg)
		logMessage("Leaving trigger volume 1!")
		return EventResult.Handled
	end)
	
	GameLogic.trigger3 = createPhantomCallbackTriggerBox("trigger3", Vec3(2, 2, 2), Vec3(50.0,  -20.0, 1.0))
	GameLogic.trigger3.phantomCallback:getEnterEvent():registerListener(function(arg)
		logMessage("Entering trigger volume 3!")
		
		local go = GetGObyGUID("playerInstance")
		if not(GameLogic.isoCam.trackingObject == go) then
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.trigger3.phantomCallback:getLeaveEvent():registerListener(function(arg)
		logMessage("Leaving trigger volume 3!")
		return EventResult.Handled
	end)
	
	logMessage("LevelMeta:init() end")

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

