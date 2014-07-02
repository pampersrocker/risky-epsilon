function InitializeWorld(  )

	-- body
	local cinfo = WorldCInfo()
	cinfo.gravity = Config.world.gravity
	cinfo.worldSize = Config.world.worldSize
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(false)

	PlayerMeta.__index = PlayerMeta
	GameLogic.totalElapsedTime = 0
	GameLogic.deathCount = 0
	GameLogic.finished = false
	GameLogic.debugDrawings = false
	GameLogic.showHelp = false
	
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

	
	-- sound banks
	SoundSystem:loadLibrary(".\\data\\sound\\Master Bank.bank")
	SoundSystem:loadLibrary(".\\data\\sound\\Master Bank.bank.strings")
	--SoundSystem:loadLibrary(".\\data\\sound\\trigger.bank")
	SoundSystem:loadLibrary(".\\data\\sound\\fan.bank")
	


	--create Level Tracks
     
	LevelMeta.__index = LevelMeta
	logMessage("Creating Level")
	GameLogic.level = CreateEmptyGameObject("TestLevel")
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.level:initializeGameObject()
--[[
	logMessage("Creating Track1")
	local name = "track1"
	GameLogic.track1 = CreateEmptyGameObject(name)
	setmetatable(GameLogic.track1, LevelMeta)
	CreateScriptComponent(GameLogic.track1, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.track1:initializeTrack1()

	logMessage("Creating Track2")
	local name = "track2"
	GameLogic.track2 = CreateEmptyGameObject(name)
	setmetatable(GameLogic.track2, LevelMeta)
	CreateScriptComponent(GameLogic.track2, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.track2:initializeTrack2()

	logMessage("Creating Track3")
	local name = "track3"
	GameLogic.track3 = CreateEmptyGameObject(name)
	setmetatable(GameLogic.track3, LevelMeta)
	CreateScriptComponent(GameLogic.track3, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.track3:initializeTrack3()

	logMessage("Creating Track4")
	local name = "track4"
	GameLogic.track4 = CreateEmptyGameObject(name)
	setmetatable(GameLogic.track4, LevelMeta)
	CreateScriptComponent(GameLogic.track4, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.track4:initializeTrack4()
	]]




	--create Fans
	FanMeta.__index = FanMeta
	
	logMessage("Creating Fan")
	local fan = Config.fans.fan1
	GameLogic.fan1 = CreateEmptyGameObject(fan.name)
	setmetatable(GameLogic.fan1, FanMeta)
	CreateScriptComponent(GameLogic.fan1, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan1.go.au = GameLogic.fan1.go:createAudioComponent()
	GameLogic.fan1.sound = GameLogic.fan1.go.au:createSoundInstance("fan", "/fan/fan")
	GameLogic.fan1:initializeGameObjectFan1(fan.name, fan.size, fan.position, fan.active, Config.fans.forces.stoneonly)
	GameLogic.fan1.sound:play()

	
	
	logMessage("Creating Fan")
	local fan = Config.fans.fan2
	GameLogic.fan2 = CreateEmptyGameObject(fan.name)
	setmetatable(GameLogic.fan2, FanMeta)
	GameLogic.fan2.go.au = GameLogic.fan2.go:createAudioComponent()
	GameLogic.fan2.sound = GameLogic.fan2.go.au:createSoundInstance("fan", "/fan/fan")
	CreateScriptComponent(GameLogic.fan2, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan2:initializeGameObjectFan1(fan.name, fan.size, fan.position, fan.active, Config.fans.forces.paperonly)
	
	logMessage("Creating Fan")
	local fan = Config.fans.fan3
	GameLogic.fan3 = CreateEmptyGameObject(fan.name)
	setmetatable(GameLogic.fan3, FanMeta)
	GameLogic.fan3.go.au = GameLogic.fan3.go:createAudioComponent()
	GameLogic.fan3.sound = GameLogic.fan3.go.au:createSoundInstance("fan", "/fan/fan")
	CreateScriptComponent(GameLogic.fan3, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan3:initializeGameObjectFan1(fan.name, fan.size, fan.position, fan.active, Config.fans.forces.woodonly)

	
	-- create transformators
	local transformator = Config.transformators.transformator1
	GameLogic.transformator1 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator1.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.transformator1.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	local transformator = Config.transformators.transformator2
	GameLogic.transformator2 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator2.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.transformator2.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	local transformator = Config.transformators.transformator3
	GameLogic.transformator3 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator3.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.transformator3.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	local transformator = Config.transformators.transformator4
	GameLogic.transformator4 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator4.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
		end
		return EventResult.Handled
	end)
	GameLogic.transformator4.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	--create Triggers
	local trigger = Config.triggers.trigger1
	local gotrigger = CreateEmptyGameObject(trigger.name)
	trigger = FanMeta:createPhantomCallbackTriggerBox(trigger.name, Config.triggers.triggersize, trigger.position)
	trigger.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		local go = GetGObyGUID("playerInstanceStone")
		if (GameLogic.isoCam.trackingObject == go) then
			GameLogic.fan2:Activate()	
			GameLogic.fan2.sound:play()
		end
		
		return EventResult.Handled
	end)
	local trigger = Config.triggers.trigger2
	local gotrigger = CreateEmptyGameObject(trigger.name)
	trigger = FanMeta:createPhantomCallbackTriggerBox(trigger.name, Config.triggers.triggersize, trigger.position)
	trigger.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		local go = GetGObyGUID("playerInstanceStone")
		if (GameLogic.isoCam.trackingObject == go) then
			GameLogic.fan3:Activate() 	
			GameLogic.fan3.sound:play()
		end
		
		return EventResult.Handled
	end)

	
	
	--create EndTrigger
	local trigger = Config.triggers.endtrigger
	local endtrigger = CreateEmptyGameObject(trigger.name)
	triggerEnd = FanMeta:createPhantomCallbackTriggerBox(trigger.name, Config.triggers.triggersize, trigger.position)
	triggerEnd.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		logMessage(GameLogic.isoCam.trackingObject.lastTransformator)
		logMessage(GameLogic.transformator3.position)
		local go = GetGObyGUID("playerInstance")
		if (GameLogic.isoCam.trackingObject == go) then
			GameLogic.finished = true
		end
		
		return EventResult.Handled
	end)
	
	--create trigger for groundfall
	local gotrigger = CreateEmptyGameObject("trigger for groundfall")
	trigger = FanMeta:createPhantomCallbackTriggerBox("trigger for groundfall", Vec3(Config.world.worldSize/2.0,Config.world.worldSize/2.0,3.0), Vec3(0.0,0.0,-Config.world.worldSize/2.5))
	trigger.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		GameLogic.restart()		
		return EventResult.Handled
	end)
	
		
	
end

InitializeWorld()