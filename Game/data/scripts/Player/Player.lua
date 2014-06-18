
PlayerMeta = {}


function PlayerMeta:initializeGameObject( )
	logMessage("PlayerMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(15)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = Config.materials.wood.mass
	cinfo.restitution = Config.materials.wood.restitution
	cinfo.friction = Config.materials.wood.friction
	cinfo.maxLinearVelocity = Config.player.maxLinearVelocity
	cinfo.maxAngularVelocity = Config.player.maxAngularVelocity
	--cinfo.linearDamping = Config.materials.wood.linearDamping
	cinfo.angularDamping = Config.materials.wood.angularDamping
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
	cinfo.shape = PhysicsFactory:createSphere(15)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = Config.materials.stone.mass
	cinfo.restitution = Config.materials.stone.restitution
	cinfo.friction = Config.materials.stone.friction
	cinfo.maxLinearVelocity = Config.player.maxLinearVelocity
	cinfo.maxAngularVelocity = Config.player.maxAngularVelocity
	--cinfo.linearDamping = Config.materials.wood.linearDamping
	cinfo.angularDamping = Config.materials.wood.angularDamping
	cinfo.position = Config.player.spawnPosition
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/Sphere/SphereMarble.thmodel")
	logMessage("PlayerMeta:initStone() end")
end

function PlayerMeta.update( guid, elapsedTime )
	local player = GetGObyGUID(guid)
	local viewDir = GameLogic.isoCam.go.cc:getViewDirection()
	viewDir.z = 0
	viewDir = viewDir:normalized()
	local rightDir = viewDir:cross(Vec3(0.0, 0.0, 1.0))
	local mouseDelta = InputHandler:getMouseDelta()


	if InputHandler:gamepad(0):isConnected() then
		local leftTorque = viewDir:mulScalar(Config.player.torqueMulScalar):mulScalar(InputHandler:gamepad(0):leftStick().x)
		local rightTorque = rightDir:mulScalar(Config.player.torqueMulScalar):mulScalar(-InputHandler:gamepad(0):leftStick().y)
		player.go.rb:applyTorque(elapsedTime, leftTorque + rightTorque)
	else
		if (InputHandler:isPressed(Config.keys.left)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(-moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime, -viewDir:mulScalar(Config.player.torqueMulScalar))
		elseif (InputHandler:isPressed(Config.keys.right)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime,viewDir:mulScalar(Config.player.torqueMulScalar))
		elseif (InputHandler:isPressed(Config.keys.forward)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime,-rightDir:mulScalar(Config.player.torqueMulScalar))
		elseif (InputHandler:isPressed(Config.keys.backward)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime,rightDir:mulScalar(Config.player.torqueMulScalar))
		else
			player.go.angularVelocitySwapped = false
		end
	end
end

function PlayerMeta.init( guid )
	-- body
	local go = GetGObyGUID(guid)
end

function PlayerMeta.destroy( ... )
	-- body
	logMessage("DESTROY!")
end
