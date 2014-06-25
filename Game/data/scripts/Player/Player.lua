
PlayerMeta = {}


function PlayerMeta:initializeGameObjectWood( )
	logMessage("PlayerMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	local materialTable = Config.materials.wood
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
	CreateRenderComponent(self, "data/models/Sphere/SphereWood.thmodel")
	logMessage("PlayerMeta:init() end")

	--self.ac = self.go:createAnimationComponent()
	--self.ac:setSkinFile("data/animations/barbarian/barbarian.hkt")
	--self.ac:setSkeletonFile("data/animations/barbarian/barbarian.hkt")

	--self.ac:addAnimationFile("FOO","data/animations/barbarian/barbarian_walk.hkt")
end


function PlayerMeta:initializeGameObjectStone( )
	logMessage("PlayerMeta:initStone() start ")
	local cinfo = RigidBodyCInfo()
	local materialTable = Config.materials.stone
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
	logMessage("PlayerMeta:initStone() end")
end

function PlayerMeta:initializeGameObjectPaper( )
	logMessage("PlayerMeta:initPaper() start ")
	local cinfo = RigidBodyCInfo()
	local materialTable = Config.materials.paper
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
	logMessage("PlayerMeta:initPaper() end")
end

function PlayerMeta.update( guid, elapsedTime )

	local player = GetGObyGUID(guid)
	
	DebugRenderer:printText(Vec2(-0.9, 0.65), "Velocity:" .. player.go.rb:getLinearVelocity():length())
	local viewDir = GameLogic.isoCam.go.cc:getViewDirection()
	viewDir.z = 0
	viewDir = viewDir:normalized()
	local rightDir = viewDir:cross(Vec3(0.0, 0.0, 1.0))
	local mouseDelta = InputHandler:getMouseDelta()

	if(InputHandler:isPressed(Config.keys.keyboard.restart)) then
		PlayerMeta.restart()
	end
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if InputHandler:gamepad(0):isConnected() then
		if(bit32.btest(buttonsTriggered, Config.keys.gamepad.restart) ) then
			PlayerMeta.restart()
		end
		local leftTorque = viewDir:mulScalar(Config.player.torqueMulScalar):mulScalar(InputHandler:gamepad(0):leftStick().x)
		local rightTorque = rightDir:mulScalar(Config.player.torqueMulScalar):mulScalar(-InputHandler:gamepad(0):leftStick().y)
		player.go.rb:applyTorque(elapsedTime, leftTorque + rightTorque)
	end
	if (InputHandler:isPressed(Config.keys.keyboard.left)) then
		--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(-moveSpeed))
		player.go.angularVelocitySwapped = false
		player.go.rb:applyTorque(elapsedTime, -viewDir:mulScalar(Config.player.torqueMulScalar))
	elseif (InputHandler:isPressed(Config.keys.keyboard.right)) then
		--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
		player.go.angularVelocitySwapped = false
		player.go.rb:applyTorque(elapsedTime,viewDir:mulScalar(Config.player.torqueMulScalar))
	elseif (InputHandler:isPressed(Config.keys.keyboard.forward)) then
		--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
		player.go.angularVelocitySwapped = false
		player.go.rb:applyTorque(elapsedTime,-rightDir:mulScalar(Config.player.torqueMulScalar))
	elseif (InputHandler:isPressed(Config.keys.keyboard.backward)) then
		--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
		player.go.angularVelocitySwapped = false
		player.go.rb:applyTorque(elapsedTime,rightDir:mulScalar(Config.player.torqueMulScalar))
	else
		player.go.angularVelocitySwapped = false
	end
end

function PlayerMeta.restart()
	GameLogic.isoCam.trackingObject.go:setPosition(Config.player.spawnPosition)
	GameLogic.isoCam.trackingObject.go.rb:setAngularVelocity(Vec3(0,0,0))
	GameLogic.isoCam.trackingObject.go.rb:setLinearVelocity(Vec3(0,0,0))
end

function PlayerMeta.init( guid )
	-- body
	local go = GetGObyGUID(guid)
end

function PlayerMeta.destroy( ... )
	-- body
	logMessage("DESTROY!")
end
