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
	
	--create Fan
	logMessage("Creating Fan")
	local name = "Fan1"
	GameLogic.fan1 = CreateEmptyGameObject(name)
	FanMeta.__index = FanMeta
	setmetatable(GameLogic.fan1, FanMeta)
	CreateScriptComponent(GameLogic.fan1, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan1:initializeGameObjectFan1(name, Vec3(4.0,4.0,10.0), Vec3(40.0,0.0,0.0), true, Vec3(0.0,0.0,1123.0))
end

InitializeWorld()