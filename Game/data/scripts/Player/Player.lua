
PlayerMeta = {}

----------------------------
-- initialize player wood --
----------------------------
function PlayerMeta:initializeGameObjectWood( )
	logMessage("PlayerMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	local materialTable = Config.materials.sphere.wood
	cinfo.shape = PhysicsFactory:createSphere(materialTable.radius)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = materialTable.mass
	cinfo.restitution = materialTable.restitution
	cinfo.friction = materialTable.friction
	cinfo.maxLinearVelocity = Config.player.maxLinearVelocity
	cinfo.maxAngularVelocity = Config.player.maxAngularVelocity
	cinfo.angularDamping = materialTable.angularDamping
	cinfo.position = Config.player.spawnPosition
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/Sphere/SphereWood.thmodel")
	
	self.lastTransformator = Config.player.lastTransformator
	logMessage("PlayerMeta:init() end")
end

-----------------------------
-- initialize player stone --
-----------------------------
function PlayerMeta:initializeGameObjectStone( )
	logMessage("PlayerMeta:initStone() start ")
	local cinfo = RigidBodyCInfo()
	local materialTable = Config.materials.sphere.stone
	cinfo.shape = PhysicsFactory:createSphere(materialTable.radius)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = materialTable.mass 
	cinfo.restitution = materialTable.restitution
	cinfo.friction = materialTable.friction
	cinfo.maxLinearVelocity = Config.player.maxLinearVelocity 
	cinfo.maxAngularVelocity = Config.player.maxAngularVelocity
	--cinfo.linearDamping = materialTable.linearDamping
	cinfo.angularDamping = materialTable.angularDamping 
	cinfo.position = Config.player.spawnPosition
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/Sphere/SphereMarble.thmodel")
	self.lastTransformator = Config.player.lastTransformator
	logMessage("PlayerMeta:initStone() end")
end

-----------------------------
-- initialize player paper --
-----------------------------
function PlayerMeta:initializeGameObjectPaper( )
	logMessage("PlayerMeta:initPaper() start ")
	local cinfo = RigidBodyCInfo()
	local materialTable = Config.materials.sphere.paper
	cinfo.shape = PhysicsFactory:createSphere(materialTable.radius)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = materialTable.mass 
	cinfo.restitution = materialTable.restitution
	cinfo.friction = materialTable.friction
	cinfo.maxLinearVelocity = Config.player.maxLinearVelocity 
	cinfo.maxAngularVelocity = Config.player.maxAngularVelocity
	--cinfo.linearDamping = materialTable.linearDamping
	cinfo.angularDamping = materialTable.angularDamping 
	cinfo.position = Config.player.spawnPosition
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/Sphere/SpherePaper.thmodel")
	self.lastTransformator = Config.player.lastTransformator
	logMessage("PlayerMeta:initPaper() end")
end




function PlayerMeta.update( guid, elapsedTime )

	local player = GetGObyGUID(guid)
	local pos = GameLogic.isoCam.trackingObject.go:getWorldPosition()

	-- draw position and velocity of player
	if(GameLogic.debugDrawings == true) then
		DebugRenderer:printText(Vec2(-0.9, 0.65), "Velocity:" .. player.go.rb:getLinearVelocity():length())
		DebugRenderer:printText(Vec2(-0.9, 0.55), "X:" .. pos.x)
		DebugRenderer:printText(Vec2(-0.9, 0.50), "Y:" .. pos.y)
		DebugRenderer:printText(Vec2(-0.9, 0.45), "Z:" .. pos.z)
	end

	local viewDir = GameLogic.isoCam.go.cc:getViewDirection()
	viewDir.z = 0
	viewDir = viewDir:normalized()
	local rightDir = viewDir:cross(Vec3(0.0, 0.0, 1.0))
	local mouseDelta = InputHandler:getMouseDelta()

	local movementDirection = Vec3(0,0,0)
	local buttonpressed = false

	-- restart game if according keys are pressed
	if(InputHandler:isPressed(Config.keys.keyboard.restart)) then
		GameLogic.restart()
	end
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if InputHandler:gamepad(0):isConnected() then
		if (bit32.btest(buttonsTriggered, Config.keys.gamepad.restart) ) then
			GameLogic.restart()
		end
	end

	-- set position to last transformator if according keys are pressed
	if(InputHandler:isPressed(Config.keys.keyboard.lastTransformator)) then
		GameLogic.lastTransformator()
	end
	if InputHandler:gamepad(0):isConnected() then
		if (bit32.btest(buttonsTriggered, Config.keys.gamepad.lastTransformator) ) then
			GameLogic.lastTransformator()
		end
	end


	-- handle player input for movement
	if (InputHandler:isPressed(Config.keys.keyboard.left)) then
		buttonpressed = true
		player.go.angularVelocitySwapped = false
		movementDirection = movementDirection:add(-viewDir)
	end
	if (InputHandler:isPressed(Config.keys.keyboard.right)) then
		buttonpressed = true
		player.go.angularVelocitySwapped = false
		movementDirection = movementDirection:add(viewDir)
	end

	if (InputHandler:isPressed(Config.keys.keyboard.forward)) then
		buttonpressed = true
		player.go.angularVelocitySwapped = false
		movementDirection = movementDirection:add(-rightDir)
	end
	if (InputHandler:isPressed(Config.keys.keyboard.backward)) then
		buttonpressed = true
		player.go.angularVelocitySwapped = false
		movementDirection = movementDirection:add(rightDir)
	end

	if InputHandler:gamepad(0):isConnected() then
		buttonpressed = true
		movementDirection = movementDirection:add(viewDir:mulScalar(InputHandler:gamepad(0):leftStick().x))
		movementDirection = movementDirection:add(rightDir:mulScalar(-InputHandler:gamepad(0):leftStick().y))
	end


	-- DEBUG: jump-to-transformator-section
	if (InputHandler:isPressed(Key.Numpad1) or InputHandler:isPressed(Key.J)) then
		jumpToPosition(Config.transformators.transformator1.position)
	end
	if (InputHandler:isPressed(Key.Numpad2)or InputHandler:isPressed(Key.K)) then
		jumpToPosition(Config.transformators.transformator2.position)
	end
	if (InputHandler:isPressed(Key.Numpad3) or InputHandler:isPressed(Key.L)) then
		jumpToPosition(Config.transformators.transformator3.position)
	end
	if (InputHandler:isPressed(Key.Numpad4)or InputHandler:isPressed(Key.U)) then
		jumpToPosition(Config.transformators.transformator4.position)
	end

	if buttonpressed then
		local linearVelocity = Vec3(movementDirection.y,-movementDirection.x,movementDirection.z)
		player.go.rb:applyLinearImpulse(linearVelocity:mulScalar(Config.player.linearVelocityScalar*elapsedTime))
		player.go.rb:applyTorque(elapsedTime, movementDirection:mulScalar(Config.player.torqueMulScalar))
	end
end

function jumpToPosition( pos )
	GameLogic.isoCam.trackingObject.go:setPosition(pos)
	GameLogic.isoCam.trackingObject.go.rb:setAngularVelocity(Vec3(0,0,0))
	GameLogic.isoCam.trackingObject.go.rb:setLinearVelocity(Vec3(0,0,0))
end



function PlayerMeta.init( guid )
	-- body
	logMessage("PlayerMeta.init!")
end

function PlayerMeta.destroy( ... )
	-- body
	logMessage("PlayerMeta.destroy!")
end
