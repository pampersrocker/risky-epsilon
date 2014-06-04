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
	if PlayerMeta == nil then
		logMessage("FUUUUUU")
	end
	PlayerMeta.__index = PlayerMeta
	setmetatable( GameLogic.playerInstance, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstance, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)
	GameLogic.playerInstance:initializeGameObject()

	--create camera

	distance = 50.0
	distanceDelta = 5.0
	distanceMin = 15.0
	distanceMax = 300000.0


	isoCam = createDefaultCam("IsoCam")
	isoCam.go.cc:look(Vec2(0.0, 20.0))

	setmetatable( isoCam, IsoCamera)
	CreateScriptComponent(isoCam, IsoCamera.init, IsoCamera.update, IsoCamera.destroy)
	logMessage("GameLogic:init()")

	--create Level
	--logMessage("Creating Level")
	--GameLogic.level = CreateEmptyGameObject("TestLevel")
	--setmetatable(GameLogic.level, LevelMeta)
	--CreateScriptComponent(GameLogic.level, LevelMeta.initialize, LevelMeta.update, LevelMeta.destroy)
end

InitializeWorld()