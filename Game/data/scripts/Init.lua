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
	-- logMessage("Creating Level")
	-- GameLogic.level = CreateEmptyGameObject("TestLevel")
	-- setmetatable(GameLogic.level, LevelMeta)
	-- CreateScriptComponent(GameLogic.level, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	-- GameLogic.level:initializeGameObject()

	logMessage("Creating Track Ice")
	GameLogic.level = CreateEmptyGameObject("Track_ice")
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.level:initializeTrack_ice()

	logMessage("Creating Track Wood")
	GameLogic.level = CreateEmptyGameObject("Track_wood")
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.init, LevelMeta.update, LevelMeta.destroy)
	GameLogic.level:initializeTrack_wood()

	--create Fanblades
	FanBladesMeta.__index = FanBladesMeta

	logMessage("Creating FanBlade")
	local fanblade = Config.fanblades.fanblade1
	GameLogic.fanblade1 = CreateEmptyGameObject(fanblade.name)
	setmetatable(GameLogic.fanblade1, FanBladesMeta)
	CreateScriptComponent(GameLogic.fanblade1, FanBladesMeta.init, FanBladesMeta.update, FanBladesMeta.destroy)
	GameLogic.fanblade1:initializeGameObjectFanBlade(fanblade.name, fanblade.position, fanblade.active, fanblade.rotationaxis, fanblade.baserotation)

	logMessage("Creating FanBlade")
	local fanblade = Config.fanblades.fanblade2
	GameLogic.fanblade2 = CreateEmptyGameObject(fanblade.name)
	setmetatable(GameLogic.fanblade2, FanBladesMeta)
	CreateScriptComponent(GameLogic.fanblade2, FanBladesMeta.init, FanBladesMeta.update, FanBladesMeta.destroy)
	GameLogic.fanblade2:initializeGameObjectFanBlade(fanblade.name, fanblade.position, fanblade.active, fanblade.rotationaxis, fanblade.baserotation)

	logMessage("Creating FanBlade")
	local fanblade = Config.fanblades.fanblade3
	GameLogic.fanblade3 = CreateEmptyGameObject(fanblade.name)
	setmetatable(GameLogic.fanblade3, FanBladesMeta)
	CreateScriptComponent(GameLogic.fanblade3, FanBladesMeta.init, FanBladesMeta.update, FanBladesMeta.destroy)
	GameLogic.fanblade3:initializeGameObjectFanBlade(fanblade.name, fanblade.position, fanblade.active, fanblade.rotationaxis, fanblade.baserotation)

	logMessage("Creating FanBlade")
	local fanblade = Config.fanblades.fanblade4
	GameLogic.fanblade4 = CreateEmptyGameObject(fanblade.name)
	setmetatable(GameLogic.fanblade4, FanBladesMeta)
	CreateScriptComponent(GameLogic.fanblade4, FanBladesMeta.init, FanBladesMeta.update, FanBladesMeta.destroy)
	GameLogic.fanblade4:initializeGameObjectFanBlade(fanblade.name, fanblade.position, fanblade.active, fanblade.rotationaxis, fanblade.baserotation)

	logMessage("Creating FanBlade")
	local fanblade = Config.fanblades.fanblade5
	GameLogic.fanblade5 = CreateEmptyGameObject(fanblade.name)
	setmetatable(GameLogic.fanblade5, FanBladesMeta)
	CreateScriptComponent(GameLogic.fanblade5, FanBladesMeta.init, FanBladesMeta.update, FanBladesMeta.destroy)
	GameLogic.fanblade5:initializeGameObjectFanBlade(fanblade.name, fanblade.position, fanblade.active, fanblade.rotationaxis, fanblade.baserotation)

	logMessage("Creating FanBlade")
	local fanblade = Config.fanblades.fanblade6
	GameLogic.fanblade6 = CreateEmptyGameObject(fanblade.name)
	setmetatable(GameLogic.fanblade6, FanBladesMeta)
	CreateScriptComponent(GameLogic.fanblade6, FanBladesMeta.init, FanBladesMeta.update, FanBladesMeta.destroy)
	GameLogic.fanblade6:initializeGameObjectFanBlade(fanblade.name, fanblade.position, fanblade.active, fanblade.rotationaxis, fanblade.baserotation)

	--create Fans
	FanMeta.__index = FanMeta
	
	logMessage("Creating Fan")
	local fan = Config.fans.fan1
	GameLogic.fan1 = CreateEmptyGameObject(fan.name)
	setmetatable(GameLogic.fan1, FanMeta)
	CreateScriptComponent(GameLogic.fan1, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan1.go.au = GameLogic.fan1.go:createAudioComponent()
	GameLogic.fan1.sound = GameLogic.fan1.go.au:createSoundInstance("fan", "/fan/fan")
	GameLogic.fan1.blades = {GameLogic.fanblade1}
	GameLogic.fan1:initializeGameObjectFan1(fan.name, fan.size, fan.position, fan.active, Config.fans.forces.stoneonly)
	GameLogic.fan1.sound:play()

	logMessage("Creating Fan")
	local fan = Config.fans.fan2
	GameLogic.fan2 = CreateEmptyGameObject(fan.name)
	setmetatable(GameLogic.fan2, FanMeta)
	GameLogic.fan2.go.au = GameLogic.fan2.go:createAudioComponent()
	GameLogic.fan2.sound = GameLogic.fan2.go.au:createSoundInstance("fan", "/fan/fan")
	GameLogic.fan2.blades = {GameLogic.fanblade2}
	CreateScriptComponent(GameLogic.fan2, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan2:initializeGameObjectFan1(fan.name, fan.size, fan.position, fan.active, Config.fans.forces.paperonly)
	
	logMessage("Creating Fan")
	local fan = Config.fans.fan3
	GameLogic.fan3 = CreateEmptyGameObject(fan.name)
	setmetatable(GameLogic.fan3, FanMeta)
	GameLogic.fan3.go.au = GameLogic.fan3.go:createAudioComponent()
	GameLogic.fan3.sound = GameLogic.fan3.go.au:createSoundInstance("fan", "/fan/fan")
	GameLogic.fan3.blades = {GameLogic.fanblade3, GameLogic.fanblade4, GameLogic.fanblade5, GameLogic.fanblade6}
	CreateScriptComponent(GameLogic.fan3, FanMeta.init, FanMeta.update, FanMeta.destroy)
	GameLogic.fan3:initializeGameObjectFan1(fan.name, fan.size, fan.position, fan.active, Config.fans.forces.woodonly)

	
	-- create transformators
	local transformator = Config.transformators.transformator1
	GameLogic.transformator1 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator1.au = GameLogic.transformator1.go:createAudioComponent()
	GameLogic.transformator1.sound = GameLogic.transformator1.au:createSoundInstance("transformator1", "/Cancel")
	GameLogic.transformator1.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
			GameLogic.transformator1.sound:play()
		end
		return EventResult.Handled
	end)
	GameLogic.transformator1.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	local transformator = Config.transformators.transformator2
	GameLogic.transformator2 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator2.au = GameLogic.transformator2.go:createAudioComponent()
	GameLogic.transformator2.sound = GameLogic.transformator2.au:createSoundInstance("transformator2", "/Cancel")
	GameLogic.transformator2.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
			GameLogic.transformator2.sound:play()
		end
		return EventResult.Handled
	end)
	GameLogic.transformator2.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	local transformator = Config.transformators.transformator3
	GameLogic.transformator3 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator3.au = GameLogic.transformator3.go:createAudioComponent()
	GameLogic.transformator3.sound = GameLogic.transformator3.au:createSoundInstance("transformator3", "/Cancel")
	GameLogic.transformator3.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
			GameLogic.transformator3.sound:play()
		end
		return EventResult.Handled
	end)
	GameLogic.transformator3.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	local transformator = Config.transformators.transformator4
	GameLogic.transformator4 = createPhantomCallbackTriggerBox(transformator.name, Config.transformators.transformatorsize, transformator.position)
	GameLogic.transformator4.au = GameLogic.transformator4.go:createAudioComponent()
	GameLogic.transformator4.sound = GameLogic.transformator4.au:createSoundInstance("transformator4", "/Cancel")
	GameLogic.transformator4.phantomCallback:getEnterEvent():registerListener(function(arg)		
		local go = GetGObyGUID(transformator.transformTo)
		if not(GameLogic.isoCam.trackingObject == go) then
			GameLogic.isoCam.trackingObject.lastTransformator = transformator.position
			ChangePlayer(go)
			GameLogic.transformator4.sound:play()
		end
		return EventResult.Handled
	end)
	GameLogic.transformator4.phantomCallback:getLeaveEvent():registerListener(function(arg)
		return EventResult.Handled
	end)
	
	-- create trigger plates
	
	GameLogic.triggerPlate1 = CreateEmptyGameObject("triggerPlate1")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(1.2,1.2,0.45))
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.track.wood.restitution
	cinfo.friction = Config.materials.track.wood.friction
	cinfo.position = Config.triggerplates.trigger1
	CreatePhysicsComponent( GameLogic.triggerPlate1 , cinfo )
	CreateRenderComponent(GameLogic.triggerPlate1, "data/models/LevelElements/track_switch_01.thModel")
	
	GameLogic.triggerPlate2 = CreateEmptyGameObject("triggerPlate2")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(1.2,1.2,0.45))
	cinfo.motionType = MotionType.Fixed
	cinfo.restitution = Config.materials.track.ice.restitution
	cinfo.friction = Config.materials.track.ice.friction
	cinfo.position = Config.triggerplates.trigger2
	CreatePhysicsComponent( GameLogic.triggerPlate2 , cinfo )
	CreateRenderComponent(GameLogic.triggerPlate2, "data/models/LevelElements/track_switch_01.thModel")	
	
	--create Triggers
	local triggerC = Config.triggers.trigger1
	local gotrigger = CreateEmptyGameObject(triggerC.name)
	GameLogic.trigger1 = FanMeta:createPhantomCallbackTriggerBox(triggerC.name, Config.triggers.triggersize, triggerC.position)
	GameLogic.trigger1.triggered = false
	GameLogic.trigger1.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		local go = GetGObyGUID("playerInstanceStone")
		if (GameLogic.isoCam.trackingObject == go and not GameLogic.trigger1.triggered) then
			GameLogic.trigger1.triggered = true
			GameLogic.fan2:Activate()	
			GameLogic.fan2.sound:play()
			GameLogic.trigger1.sound:play()
			local position = GameLogic.triggerPlate1.go:getWorldPosition()
			GameLogic.triggerPlate1.go:setPosition(Vec3(position.x,position.y,position.z - 0.1))
		end
		
		return EventResult.Handled
	end)
	GameLogic.trigger1.go.au = GameLogic.trigger1.go:createAudioComponent()
	GameLogic.trigger1.sound = GameLogic.trigger1.go.au:createSoundInstance("fan", "/trigger/Doorknob")
	
	local triggerC = Config.triggers.trigger2
	local gotrigger = CreateEmptyGameObject(triggerC.name)
	GameLogic.trigger2 = FanMeta:createPhantomCallbackTriggerBox(triggerC.name, Config.triggers.triggersize, triggerC.position)
	GameLogic.trigger2.triggered = false
	GameLogic.trigger2.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		local go = GetGObyGUID("playerInstanceStone")
		if (GameLogic.isoCam.trackingObject == go and not GameLogic.trigger2.triggered) then
			GameLogic.trigger2.triggered = true
			GameLogic.fan3:Activate() 	
			GameLogic.fan3.sound:play()
			GameLogic.trigger2.sound:play()
			local position = GameLogic.triggerPlate2.go:getWorldPosition()
			GameLogic.triggerPlate2.go:setPosition(Vec3(position.x,position.y,position.z - 0.1))
		end
		
		return EventResult.Handled
	end)
	GameLogic.trigger2.go.au = GameLogic.trigger2.go:createAudioComponent()
	GameLogic.trigger2.sound = GameLogic.trigger2.go.au:createSoundInstance("fan", "/trigger/Doorknob")
	
	
	--create EndTrigger
	local triggerC = Config.triggers.endtrigger
	local endtrigger = CreateEmptyGameObject(triggerC.name)
	triggerEnd = FanMeta:createPhantomCallbackTriggerBox(triggerC.name, Config.triggers.triggersize, triggerC.position)
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