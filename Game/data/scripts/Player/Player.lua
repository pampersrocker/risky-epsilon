
PlayerMeta = {}


function PlayerMeta:initializeGameObject( )
	logMessage("PlayerMeta:init() start ")
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(15)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 100.0
	cinfo.restitution = 0.0
	cinfo.friction = 10.0
	cinfo.maxLinearVelocity = 300.0
	cinfo.maxAngularVelocity = 2.0
	--cinfo.linearDamping = 1.0
	cinfo.angularDamping = 10.0
	cinfo.position = Vec3(0.0, 0.0, 20.0)
	CreatePhysicsComponent( self , cinfo )
	CreateRenderComponent(self, "data/models/Sphere/sphere.thmodel")
	logMessage("PlayerMeta:init() end")

	--self.ac = self.go:createAnimationComponent()
	--self.ac:setSkinFile("data/animations/barbarian/barbarian.hkt")
	--self.ac:setSkeletonFile("data/animations/barbarian/barbarian.hkt")

	--self.ac:addAnimationFile("FOO","data/animations/barbarian/barbarian_walk.hkt")

end

function PlayerMeta.update( guid, elapsedTime )
	local player = GetGObyGUID(guid)
	local viewDir = GameLogic.isoCam.go.cc:getViewDirection()
	viewDir.z = 0
	viewDir = viewDir:normalized()
	local rightDir = viewDir:cross(Vec3(0.0, 0.0, 1.0))
	local mouseDelta = InputHandler:getMouseDelta()
	if (InputHandler:isPressed(Key.A)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(-moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime, -viewDir:mulScalar(1000))
		elseif (InputHandler:isPressed(Key.D)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime,viewDir:mulScalar(1000))
		elseif (InputHandler:isPressed(Key.W)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime,-rightDir:mulScalar(1000))
		
		elseif (InputHandler:isPressed(Key.S)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.go.angularVelocitySwapped = false
			player.go.rb:applyTorque(elapsedTime,rightDir:mulScalar(1000))
		else
			player.go.angularVelocitySwapped = false
		end
end

function PlayerMeta.init( guid )
	-- body
	local go = GetGObyGUID(guid)
	go.currentAngularVelocityForward = Vec3(0.0, 250, 0.0)
	go.currentAngularVelocityLeft = Vec3(-250,0.0,0.0)
end

function PlayerMeta.destroy( ... )
	-- body
	logMessage("DESTROY!")
end
