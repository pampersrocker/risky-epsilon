
LevelMeta = {}

function LevelMeta:initializeTrack1()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/track_material_test_01.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/track_material_test_01.thModel")
end
function LevelMeta:initializeTrack2()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/track_material_test_02.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/track_material_test_02.thModel")
end
function LevelMeta:initializeTrack3()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/track_material_test_03.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/track_material_test_03.thModel")
end
function LevelMeta:initializeTrack4()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/track_material_test_04.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/track_material_test_04.thModel")
end


function LevelMeta:initializeGameObject()
	logMessage("LevelMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(800,800,1))
	--cinfo.shape = PhysicsFactory:loadCollisionMesh("data/models/LevelElements/track_start_col.hkx")
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.position = Vec3(0.0, 0.0, 0.0)

	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/LevelElements/track_start.thModel")
	
	
	
	--[[
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
		
		local go = GetGObyGUID("playerInstanceStone")
		if not(GameLogic.isoCam.trackingObject == go) then
			ChangePlayer(go)
			--GetFanbyID().isActive = true
		end
		return EventResult.Handled
	end)
	GameLogic.trigger3.phantomCallback:getLeaveEvent():registerListener(function(arg)
		logMessage("Leaving trigger volume 3!")
		return EventResult.Handled
	end)
	
	logMessage("LevelMeta:init() end")
	]]

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

