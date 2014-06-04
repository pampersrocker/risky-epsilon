function InitializeWorld(  )

	-- body
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.81)
	cinfo.worldSize = 4000.0
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)

	-- create player
	GameLogic.playerInstance = CreateEmptyGameObject("playerInstance")
	setmetatable( GameLogic.playerInstance, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstance, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstance.cb = CreateCollisionSphere("cb_player", 15, GameLogic.playerInstance.go:getWorldPosition())
	--create camera

	distance = 50.0
	distanceDelta = 5.0
	distanceMin = 15.0
	distanceMax = 200.0


	isoCam = createDefaultCam("IsoCam")
	isoCam.go.cc:look(Vec2(0.0, 20.0))

	setmetatable( isoCam, IsoCamera)
	CreateScriptComponent(isoCam, IsoCamera.init, IsoCamera.update, IsoCamera.destroy)
	logMessage("GameLogic:init()")

	--create Level
	logMessage("Creating Level")
	GameLogic.level = CreateEmptyGameObject("TestLevel")
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.initialize, LevelMeta.update, LevelMeta.destroy)
	GameLogic.level.cb = CreateCollisionBox("cb_ground", Vec3(166.0, 192.0, 3.0), Vec3(0.0, 0.0, 0.0))
end

InitializeWorld()