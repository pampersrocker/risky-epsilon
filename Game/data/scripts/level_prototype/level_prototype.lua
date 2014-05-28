logMessage("Initializing level_prototype/level_prototype.lua ...")

--
-- physics world
--
local cinfo = WorldCInfo()
cinfo.gravity = Vec3(0, 0, -9.81)
cinfo.worldSize = 4000.0
local world = PhysicsFactory:createWorld(cinfo)
PhysicsSystem:setWorld(world)
PhysicsSystem:setDebugDrawingEnabled(true)

function createCollisionBox(guid, halfExtends, position)
	local box = GameObjectManager:createGameObject(guid)
	box.pc = box:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(halfExtends)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	box.pc.rb = box.pc:createRigidBody(cinfo)
	return box
end

--
-- scene
--
scene = {}
scene.plane = GameObjectManager:createGameObject("plane")
scene.plane.rc = scene.plane:createRenderComponent()
scene.plane.rc:setPath("data/models/LevelElements/plane.thModel")
scene.ground = createCollisionBox("ground", Vec3(166.0, 192.0, 3.0), Vec3(0.0, 0.0, 0.0))

function createDefaultCam(guid)
	local cam = GameObjectManager:createGameObject(guid)
	cam.cc = cam:createCameraComponent()
	cam.cc:setPosition(Vec3(0.0, 0.0, 0.0))
	cam.cc:setViewDirection(Vec3(1.0, 0.0, 0.0))
	cam.baseViewDir = Vec3(1.0, 0.0, 0.0)
	cam.cc:setBaseViewDirection(cam.baseViewDir)
	return cam
end

--
-- debugCam
--
debugCam = createDefaultCam("debugCam")

function debugCamEnter(enterData)
	debugCam:setComponentStates(ComponentState.Active)
	return EventResult.Handled
end

function debugCamUpdate(updateData)
	DebugRenderer:printText(Vec2(-0.9, 0.85), "debugCamUpdate")

	local mouseDelta = InputHandler:getMouseDelta()
	local rotationSpeed = 0.1 * updateData:getElapsedTime()
	local lookVec = mouseDelta:mulScalar(rotationSpeed)
	debugCam.cc:look(lookVec)
	
	local moveVec = Vec3(0.0, 0.0, 0.0)
	local moveSpeed = 0.2 * updateData:getElapsedTime()
	if (InputHandler:isPressed(Key.Shift)) then
		moveSpeed = moveSpeed * 5
	end
	if (InputHandler:isPressed(Key.Up)) then
		moveVec.y = moveSpeed
	elseif (InputHandler:isPressed(Key.Down)) then
		moveVec.y = -moveSpeed
	end
	if (InputHandler:isPressed(Key.Left)) then
		moveVec.x = -moveSpeed
	elseif (InputHandler:isPressed(Key.Right)) then
		moveVec.x = moveSpeed
	end
	debugCam.cc:move(moveVec)
	
	local pos = debugCam.cc:getPosition()
	DebugRenderer:printText(Vec2(-0.9, 0.80), "  pos: " .. string.format("%5.2f", pos.x) .. ", " .. string.format("%5.2f", pos.y) .. ", " .. string.format("%5.2f", pos.z))
	local dir = debugCam:getViewDirection()
	DebugRenderer:printText(Vec2(-0.9, 0.75), "  dir: " .. string.format("%5.2f", dir.x) .. ", " .. string.format("%5.2f", dir.y) .. ", " .. string.format("%5.2f", dir.z))
	
	return EventResult.Handled
end

State{
	name = "debugCam",
	parent = "/game/gameRunning",
	eventListeners = {
		update = { debugCamUpdate },
		enter = { debugCamEnter }
	}
}

--
-- normalCam
--
normalCam = {}

normalCam.firstPerson = createDefaultCam("firstPerson")

function normalCamFirstPersonEnter(enterData)
	normalCam.firstPerson:setComponentStates(ComponentState.Active)
	player.firstPersonMode = true
	return EventResult.Handled
end

function normalCamFirstPersonUpdate(updateData)
	DebugRenderer:printText(Vec2(-0.9, 0.85), "firstPerson")
	local camPos = player:getPosition() + Vec3(0.0, 0.0, 10.0)
	normalCam.firstPerson.cc:setPosition(camPos)
	normalCam.firstPerson.cc:lookAt(camPos + player:getViewDirection():mulScalar(100.0) + Vec3(0.0, 0.0, player.viewUpDown))
	return EventResult.Handled
end

function normalCamFirstPersonLeave(leaveData)
	player.firstPersonMode = false
	return EventResult.Handled
end

distance = 50.0
distanceDelta = 5.0
distanceMin = 15.0
distanceMax = 200.0

normalCam.thirdPerson = createDefaultCam("thirdPerson")
normalCam.thirdPerson.pc = normalCam.thirdPerson:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createSphere(0.5)
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 50.0
cinfo.restitution = 0.0
cinfo.friction = 0.0
cinfo.maxLinearVelocity = 3000
cinfo.linearDamping = 5.0
cinfo.gravityFactor = 0.0
normalCam.thirdPerson.pc.rb = normalCam.thirdPerson.pc:createRigidBody(cinfo)
normalCam.thirdPerson.pc:setState(ComponentState.Inactive)
normalCam.thirdPerson.calcPosTo = function()
	return player:getPosition() + player:getViewDirection():mulScalar(-distance) + Vec3(0.0, 0.0, distance/3 )
end

function normalCamThirdPersonEnter(enterData)
	normalCam.thirdPerson:setPosition(normalCam.thirdPerson.calcPosTo())
	normalCam.thirdPerson:setComponentStates(ComponentState.Active)
	return EventResult.Handled
end

function normalCamThirdPersonUpdate(updateData)
	if (InputHandler:isPressed(Key.Oem_Minus)) then
		if ( distance > distanceMin) then
			distance = distance - distanceDelta
		end
	elseif (InputHandler:isPressed(Key.Oem_Plus)) then
		if ( distance < distanceMax) then
			distance = distance + distanceDelta
		end
	end
	DebugRenderer:printText(Vec2(-0.9, 0.85), "thirdPerson")
	local camPosTo = normalCam.thirdPerson.calcPosTo()
	local camPosIs = normalCam.thirdPerson:getPosition()
	local camPosVel = camPosTo - camPosIs
	if (camPosVel:length() > 1.0 ) then
		normalCam.thirdPerson.pc.rb:setLinearVelocity(camPosVel:mulScalar(2.5))
	end
	normalCam.thirdPerson.cc:lookAt(player:getPosition() + Vec3(0.0, 0.0, 5.0))
	return EventResult.Handled
end

normalCam.isometric = createDefaultCam("isometric")
normalCam.isometric.cc:look(Vec2(0.0, 20.0))

function normalCamIsometricEnter(enterData)
	normalCam.isometric:setComponentStates(ComponentState.Active)
	return EventResult.Handled
end

function normalCamIsometricUpdate(updateData)
	if (InputHandler:isPressed(Key.Oem_Minus)) then
		if ( distance > distanceMin) then
			distance = distance - distanceDelta
		end
	elseif (InputHandler:isPressed(Key.Oem_Plus)) then
		if ( distance < distanceMax) then
			distance = distance + distanceDelta
		end
	end
	DebugRenderer:printText(Vec2(-0.9, 0.85), "isometric")
	local rotationSpeed = 0.05 * updateData:getElapsedTime()
	local mouseDelta = InputHandler:getMouseDelta()
	mouseDelta.x = mouseDelta.x * rotationSpeed
	mouseDelta.y = 0.0
	normalCam.isometric.cc:look(mouseDelta)
	local viewDir = normalCam.isometric.cc:getViewDirection()
	viewDir = viewDir:mulScalar(-distance)
	viewDir.z = distance/2
	normalCam.isometric.cc:setPosition(player:getPosition() + viewDir)
	return EventResult.Handled
end

StateMachine{
	name = "normalCam(fsm)",
	parent = "/game/gameRunning",
	states = {
		{
			name = "firstPerson",
			eventListeners = {
				update = { normalCamFirstPersonUpdate },
				enter = { normalCamFirstPersonEnter },
				leave = { normalCamFirstPersonLeave }
			},
		},
		{
			name = "thirdPerson",
			eventListeners = {
				update = { normalCamThirdPersonUpdate },
				enter = { normalCamThirdPersonEnter }
			},
		},
		{
			name = "isometric",
			eventListeners = {
				update = { normalCamIsometricUpdate },
				enter = { normalCamIsometricEnter }
			},
		},
	},
	transitions = {
		{ from = "__enter", to = "firstPerson" },
		{ from = "firstPerson", to = "thirdPerson", condition = function() return InputHandler:wasTriggered(Key.V) end },
		{ from = "thirdPerson", to = "isometric", condition = function() return InputHandler:wasTriggered(Key.V) end },
		{ from = "isometric", to = "firstPerson", condition = function() return InputHandler:wasTriggered(Key.V) end }
	}
}

StateTransitions{
	parent = "/game/gameRunning",
	{ from = "__enter", to = "debugCam" },
	{ from = "debugCam", to = "normalCam(fsm)", condition = function() return InputHandler:wasTriggered(Key.C) end },
	{ from = "normalCam(fsm)", to = "debugCam", condition = function() return InputHandler:wasTriggered(Key.C) end }
}

StateTransitions{
	parent = "/game",
	{ from = "gameRunning", to = "__leave", condition = function() return InputHandler:wasTriggered(Key.Escape) end }
}

--
-- player
--
function playerUpdate(guid, elapsedTime)
	local position = player:getPosition()
	local viewDir = player:getViewDirection()
	local rightDir = player:getRightDirection()
	DebugRenderer:drawArrow(position, position + viewDir:mulScalar(25.0))
	local moveSpeed = 50.0
	if (InputHandler:isPressed(Key.Shift)) then
		moveSpeed = moveSpeed * 2.5
	end
	if (InputHandler:isPressed(Key.Space)) then
		player.pc.rb:applyLinearImpulse(Vec3(0.0,0.0,20.0))
	elseif (InputHandler:isPressed(Key.W)) then
		player.pc.rb:applyTorque(elapsedTime, -player.currentAngularVelocityForward)
	elseif (InputHandler:isPressed(Key.S)) then
		player.pc.rb:applyTorque(elapsedTime, player.currentAngularVelocityForward)
	end
	
	
	
	if (player.firstPersonMode) then
		DebugRenderer:printText(Vec2(-0.01, 0.05), "X")
		local rightDir = viewDir:cross(Vec3(0.0, 0.0, 1.0))
		if (InputHandler:isPressed(Key.A) and InputHandler:isPressed(Key.D)) then
			-- no sideways walking
		elseif (InputHandler:isPressed(Key.A)) then
			player.angularVelocitySwapped = false
			player.pc.rb:applyTorque( elapsedTime, player.currentAngularVelocityLeft)
		elseif (InputHandler:isPressed(Key.D)) then
			player.angularVelocitySwapped = false
			player.pc.rb:applyTorque(elapsedTime, -player.currentAngularVelocityLeft)
		end
		local mouseDelta = InputHandler:getMouseDelta()
		local angularVelocity = Vec3(0.0, 0.0, mouseDelta.x * -0.05 * elapsedTime)
		player.pc.rb:setAngularVelocity(angularVelocity)
		player.viewUpDown = player.viewUpDown + mouseDelta.y * -0.05 * elapsedTime
		local viewUpDownMax = 100
		if (player.viewUpDown > viewUpDownMax) then
			player.viewUpDown = viewUpDownMax
		end
		if (player.viewUpDown < -viewUpDownMax) then
			player.viewUpDown = -viewUpDownMax
		end
	else
		if (InputHandler:isPressed(Key.A)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(-moveSpeed))
			player.angularVelocitySwapped = false
			player.pc.rb:applyTorque(elapsedTime, player.currentAngularVelocityLeft)
		elseif (InputHandler:isPressed(Key.D)) then
			--player.pc.rb:applyLinearImpulse(rightDir:mulScalar(moveSpeed))
			player.angularVelocitySwapped = false
			player.pc.rb:applyTorque(elapsedTime,-player.currentAngularVelocityLeft)
		else
			player.angularVelocitySwapped = false
		end
	end
end

player = GameObjectManager:createGameObject("player")
player.rc = player:createRenderComponent()
player.rc:setPath("data/models/Sphere/Sphere.thModel")
player.pc = player:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createSphere(1)
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 100.0
cinfo.restitution = 0.0
cinfo.friction = 10.0
cinfo.maxLinearVelocity = 300.0
cinfo.maxAngularVelocity = 2.0
--cinfo.linearDamping = 1.0
cinfo.angularDamping = 10.0
cinfo.position = Vec3(0.0, 0.0, 2.0)
player.pc.rb = player.pc:createRigidBody(cinfo)
player.sc = player:createScriptComponent()
player.sc:setUpdateFunction(playerUpdate)
player:setBaseViewDirection(Vec3(1.0, 0.0, 0.0))
-- additional members
player.firstPersonMode = false
player.currentAngularVelocity = Vec3()
player.angularVelocitySwapped = false
player.viewUpDown = 0.0

player.currentAngularVelocityLeft = Vec3(0.0, 0.0, 2.5)
player.currentAngularVelocityForward = Vec3(20.5,0.0,0.0)

logMessage("... finished initializing level_prototype/level_prototype.lua.")

logWarning("Dummy warning")
logError("Dummy error")
