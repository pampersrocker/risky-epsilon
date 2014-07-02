
FanMeta = {}

function FanMeta:initializeGameObjectFan1( name, size, pos, active, force)
	logMessage("FanMeta:init() start ")
	self.isTriggered = false
	self.isActive = active
	self.force = force
	self.trigger = FanMeta:createPhantomCallbackTriggerBox(name, size, pos)
	self.trigger.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		self.isTriggered = true
		return EventResult.Handled
	end)
	self.trigger.go.phantomCallback:getLeaveEvent():registerListener(function(arg)
		self.isTriggered = false
		
		return EventResult.Handled
	end)
	--self.sound:play()
	
	logMessage("FanMeta:init() end")
end


function FanMeta.update( guid, elapsedTime )
	local fan = GetGObyGUID(guid)
		
	if fan.isActive and fan.isTriggered then
		GameLogic.isoCam.trackingObject.go.rb:applyForce(elapsedTime, fan.force)
	end
	
	
	--[[local player = GetGObyGUID(guid)
	
	DebugRenderer:printText(Vec2(-0.9, 0.65), "Velocity:" .. player.go.rb:getLinearVelocity():length())
	local viewDir = GameLogic.isoCam.go.cc:getViewDirection()
	viewDir.z = 0
	viewDir = viewDir:normalized()
	local rightDir = viewDir:cross(Vec3(0.0, 0.0, 1.0))
	local mouseDelta = InputHandler:getMouseDelta()

	if(InputHandler:isPressed(Config.keys.keyboard.restart)) then
		FanMeta.restart()
	end
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if InputHandler:gamepad(0):isConnected() then
		if(bit32.btest(buttonsTriggered, Config.keys.gamepad.restart) ) then
			FanMeta.restart()
		end
		local leftTorque = viewDir:mulScalar(Config.player.torqueMulScalar):mulScalar(InputHandler:gamepad(0):leftStick().x)
		local rightTorque = rightDir:mulScalar(Config.player.torqueMulScalar):mulScalar(-InputHandler:gamepad(0):leftStick().y)
		player.go.rb:applyTorque(elapsedTime, leftTorque + rightTorque)
	end
	if (InputHandler:isPressed(Config.keys.keyboard.left)) then
		--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(-moveSpeed))
		logMessage("PlayerUpdate")
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
	end]]
end
function FanMeta:createPhantomCallbackTriggerBox(guid, halfExtends, position)
	local trigger = GetGObyGUID( guid )
	trigger.go.pc = trigger.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	local boundingShape = PhysicsFactory:createBox(halfExtends)
	local phantomCallbackShape = PhysicsFactory:createPhantomCallbackShape(halfExtends)
	cinfo.shape = PhysicsFactory:createBoundingVolumeShape(boundingShape, phantomCallbackShape)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	trigger.go.pc.rb = trigger.go.pc:createRigidBody(cinfo)
	trigger.go.phantomCallback = phantomCallbackShape

	return trigger
end

function FanMeta.init( guid )
	-- body
end

function FanMeta.destroy( ... )
	-- body
end