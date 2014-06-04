function InitializeWorld(  )

	-- body
	local cinfo = WorldCInfo()
	cinfo.gravity = Config.world.gravity
	cinfo.worldSize = 4000.0
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)

	-- create player
	GameLogic.playerInstance = CreateEmptyGameObject("playerInstance")
	PlayerMeta.__index = PlayerMeta
	setmetatable( GameLogic.playerInstance, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstance, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstance:initializeGameObject()
	--GameLogic.playerInstance.go:setComponentStates(ComponentState.Inactive)
	
	-- create playerStone
	GameLogic.playerInstanceStone = CreateEmptyGameObject("playerInstanceStone")
	PlayerMeta.__index = PlayerMeta
	setmetatable( GameLogic.playerInstanceStone, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstanceStone, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstanceStone:initializeGameObjectStone()
	GameLogic.playerInstanceStone.go:setComponentStates(ComponentState.Inactive)
	
	--create camera
	isoCam = createDefaultCam("IsoCam")
	isoCam.go.cc:look(Config.camera.initLook)
	isoCam.trackingObject = GetGObyGUID("playerInstance")
	
	setmetatable( isoCam, IsoCamera)
	CreateScriptComponent(isoCam, IsoCamera.init, IsoCamera.update, IsoCamera.destroy)
	GameLogic.isoCam = isoCam
	logMessage("GameLogic:init()")

	--create Level
	logMessage("Creating Level")
	GameLogic.level = CreateEmptyGameObject("TestLevel")
	LevelMeta.__index = LevelMeta
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	--GameLogic.level.cb = CreateCollisionBox("cb_ground", Vec3(166.0, 192.0, 3.0), Vec3(0.0, 0.0, 0.0))
	GameLogic.level:initializeGameObject()
end

InitializeWorld()