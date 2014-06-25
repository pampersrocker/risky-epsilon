function InitializeWorld(  )

	-- body
	local cinfo = WorldCInfo()
	cinfo.gravity = Config.world.gravity
	cinfo.worldSize = 4000.0
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)

	PlayerMeta.__index = PlayerMeta

	-- create player
	GameLogic.playerInstance = CreateEmptyGameObject("playerInstance")
	setmetatable( GameLogic.playerInstance, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstance, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstance:initializeGameObjectWood()
	--GameLogic.playerInstance.go:setComponentStates(ComponentState.Inactive)

	-- create playerStone
	GameLogic.playerInstanceStone = CreateEmptyGameObject("playerInstanceStone")

	setmetatable( GameLogic.playerInstanceStone, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstanceStone, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstanceStone:initializeGameObjectStone()
	GameLogic.playerInstanceStone.go:setComponentStates(ComponentState.Inactive)

	-- create playerPaper
	GameLogic.playerInstancePaper = CreateEmptyGameObject("playerInstancePaper")
	setmetatable( GameLogic.playerInstancePaper, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstancePaper, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstancePaper:initializeGameObjectPaper()
	GameLogic.playerInstancePaper.go:setComponentStates(ComponentState.Inactive)

	--create camera
	GameLogic.isoCam = createDefaultCam("IsoCam")
	GameLogic.isoCam.go.cc:look(Config.camera.initLook)
	GameLogic.isoCam.trackingObject = GetGObyGUID("playerInstance")
	setmetatable( GameLogic.isoCam, IsoCamera)
	--CreateScriptComponent(GameLogic.isoCam, IsoCamera.init, IsoCamera.update, IsoCamera.destroy)
	GameLogic.isoCam.isEnabled = true
	logMessage("GameLogic:init()")

	--create Level
	logMessage("Creating Level")
	GameLogic.level = CreateEmptyGameObject("TestLevel")
	LevelMeta.__index = LevelMeta
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	--GameLogic.level.cb = CreateCollisionBox("cb_ground", Vec3(166.0, 192.0, 3.0), Vec3(0.0, 0.0, 0.0))
	GameLogic.level:initializeGameObject()
	
	--create Fans
	logMessage("Creating Fan")
	local name = "Fan1"
	GameLogic.fan1 = CreateEmptyGameObject(name)
	FanMeta.__index = FanMeta
	setmetatable(GameLogic.fan1, FanMeta)
	CreateScriptComponent(GameLogic.fan1, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan1:initializeGameObjectFan1(name, Vec3(4.0,4.0,10.0), Vec3(40.0,0.0,5.0), true, Vec3(0.0,0.0,1123.0))
	
	logMessage("Creating Fan")
	local name = "Fan2"
	GameLogic.fan2 = CreateEmptyGameObject(name)
	FanMeta.__index = FanMeta
	setmetatable(GameLogic.fan2, FanMeta)
	CreateScriptComponent(GameLogic.fan2, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan2:initializeGameObjectFan1(name, Vec3(10.0,5.0,4.0), Vec3(-50.0,0.0,2.0), false, Vec3(4123.0,0.0,0.0))
	
	--wood fans
	logMessage("Creating Fan")
	local name = "Fan3"
	GameLogic.fan3 = CreateEmptyGameObject(name)
	FanMeta.__index = FanMeta
	setmetatable(GameLogic.fan3, FanMeta)
	CreateScriptComponent(GameLogic.fan3, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan3:initializeGameObjectFan1(name, Vec3(4.0,4.0,10.0), Vec3(120.0,0.0,5.0), true, Vec3(200.0,0.0,2123.0))
	
	logMessage("Creating Fan")
	local name = "Fan4"
	GameLogic.fan4 = CreateEmptyGameObject(name)
	FanMeta.__index = FanMeta
	setmetatable(GameLogic.fan4, FanMeta)
	CreateScriptComponent(GameLogic.fan4, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan4:initializeGameObjectFan1(name, Vec3(4.0,4.0,10.0), Vec3(130.0,0.0,5.0), true, Vec3(200.0,0.0,2123.0))
	
	logMessage("Creating Fan")
	local name = "Fan5"
	GameLogic.fan5 = CreateEmptyGameObject(name)
	FanMeta.__index = FanMeta
	setmetatable(GameLogic.fan5, FanMeta)
	CreateScriptComponent(GameLogic.fan5, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan5:initializeGameObjectFan1(name, Vec3(4.0,4.0,10.0), Vec3(140.0,0.0,5.0), true, Vec3(200.0,0.0,2123.0))
	
	--wood fans level parts
	GameLogic.woodfanslvlpart1 = CreateEmptyGameObject("woodfanslvlpart1")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(35.0,5.0,1.0))
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.position = Vec3(80.0, 0.0, 10.0)
	CreatePhysicsComponent( GameLogic.woodfanslvlpart1 , cinfo )
	
	--create Triggers
	local gotrigger = CreateEmptyGameObject("trigger for fan2")
	trigger = FanMeta:createPhantomCallbackTriggerBox("trigger for fan2", Vec3(2.0,2.0,2.0), Vec3(-20.0,10.0,0.0))
	trigger.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		local go = GetGObyGUID("playerInstanceStone")
		if (GameLogic.isoCam.trackingObject == go) then
			GameLogic.fan2.isActive = true			
		end
		
		return EventResult.Handled
	end)
	
end

InitializeWorld()