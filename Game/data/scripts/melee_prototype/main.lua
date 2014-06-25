
-- physics world
local cinfo = WorldCInfo()
cinfo.gravity = Vec3(0, 0, -9.81)
cinfo.worldSize = 2000
local world = PhysicsFactory:createWorld(cinfo)
world:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
PhysicsSystem:setWorld(world)
PhysicsSystem:setDebugDrawingEnabled(true)

-- random seed
math.randomseed(os.time())

-- ground
ground = createCollisionBox("ground", Vec3(1000, 1000, 20), Vec3(0, 0, -20))
-- walls
walls = {}
walls[1] = createCollisionBox("wall1", Vec3(20, 1000, 200), Vec3(-980, 0, 200))
walls[2] = createCollisionBox("wall2", Vec3(20, 1000, 200), Vec3(980, 0, 200))
walls[3] = createCollisionBox("wall3", Vec3(960, 20, 200), Vec3(0, -980, 200))
walls[4] = createCollisionBox("wall4", Vec3(960, 20, 200), Vec3(0, 980, 200))
-- spheres
spheres = {}
spheres[1] = createCollisionSphere("sphere1", 100, Vec3(300, 300, 200))
spheres[2] = createCollisionSphere("sphere2", 100, Vec3(-300, 300, 200))
spheres[3] = createCollisionSphere("sphere3", 100, Vec3(300, -300, 200))
spheres[4] = createCollisionSphere("sphere4", 100, Vec3(-300, -300, 200))
-- debug cam
debugCam = createDebugCam("debugCam")
-- 3rd person cam
cam = GameObjectManager:createGameObject("cam")
cam.cc = cam:createCameraComponent()
cam.rotation = 0
-- character
character = GameObjectManager:createGameObject("character")
character.rc = character:createRenderComponent()
character.rc:setPath("data/models/barbarian/barbarianAnimated.thModel")
character.ac = character:createAnimationComponent()
character.ac:setSkeletonFile("data/animations/Barbarian/Barbarian.hkt")
character.ac:setSkinFile("data/animations/Barbarian/Barbarian.hkt")
character.ac:addAnimationFile("Idle", "data/animations/Barbarian/Barbarian_Idle.hkt")
character.ac:addAnimationFile("Walk", "data/animations/Barbarian/Barbarian_Walk.hkt")
character.ac:addAnimationFile("Run", "data/animations/Barbarian/Barbarian_Run.hkt")
character.ac:addAnimationFile("Attack", "data/animations/Barbarian/Barbarian_Attack.hkt")
character.pc = character:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.collisionFilterInfo = 0x1
local sphere = PhysicsFactory:createSphere(50)
cinfo.shape = PhysicsFactory:createConvexTranslateShape(sphere, Vec3(0, 0, 50))
cinfo.motionType = MotionType.Dynamic
cinfo.position = Vec3(0, 0, 5)
cinfo.mass = 100
cinfo.restitution = 0
cinfo.friction = 0
cinfo.linearDamping = 2.5
cinfo.angularDamping = 1
cinfo.gravityFactor = 25
character.pc.rb = character.pc:createRigidBody(cinfo)
character.pc.rb:setUserData(character)
character:setBaseViewDirection(Vec3(0, -1, 0):normalized())
character.attacking = false
character.walkSpeed = 0
character.maxWalkSpeed = 35000
character.relativeSpeed = 0
character.rotationSpeed = 0
character.maxRotationSpeed = 250
-- axe
axe = GameObjectManager:createGameObject("axe")
axe.rc = axe:createRenderComponent()
axe.rc:setPath("data/models/barbarian/barbarian_axe.thModel")
axe.pc = axe:createPhysicsComponent()
do
	local cinfo = RigidBodyCInfo()
	local box = PhysicsFactory:createBox(Vec3(5, 30, 50))
	cinfo.collisionFilterInfo = 0x0 --0x2
	cinfo.shape = PhysicsFactory:createConvexTranslateShape(box, Vec3(0, 50, -10))
	cinfo.motionType = MotionType.Keyframed
	cinfo.isTriggerVolume = true
	axe.pc.rb = axe.pc:createRigidBody(cinfo)
	axe.pc.rb:setUserData(axe)
	axe.pc.rb:getTriggerEvent():registerListener(function(args)
		local go = args:getRigidBody():getUserData()
		if args:getEventType() == TriggerEventType.Entered then
			timedStatusDisplay("Hit " .. go:getName())
			local hitDir = axe:getViewDirection()
			go.pc.rb:applyLinearImpulse(hitDir:mulScalar(-100000.0))
		elseif args:getEventType() == TriggerEventType.Left then
			timedStatusDisplay("Not hitting " .. go:getName() .. " anymore.")
		end
		return EventResult.Handled
	end)
end

-- global state flags
debugCamEnabled = false

function defaultEnter(enterData)

	character.rc:setState(ComponentState.Inactive)
	character.ac:setBoneDebugDrawingEnabled(true)

	-- set the initial animation states
	character.ac:setReferencePoseWeightThreshold(0.1)
	character.ac:easeIn("Idle", 0.0)
	character.ac:setMasterWeight("Idle", 0.1)
	character.ac:easeIn("Walk", 0.0)
	character.ac:setMasterWeight("Walk", 0.0)
	character.ac:easeIn("Run", 0.0)
	character.ac:setMasterWeight("Run", 0.0)
	character.ac:easeOut("Attack", 0.0)
	character.ac:setMasterWeight("Attack", 1.0)
	character.ac:setPlaybackSpeed("Attack", 1.5)

	-- parent the axe to the character's hand
	local bone = character.ac:getBoneByName("right_attachment_jnt")
	local rot = Quaternion(Vec3(1, 0, 0), 90) * Quaternion(Vec3(0, 1, 0), 180)
	axe:setParent(bone)
	axe:setRotation(rot)

--	axeCollider:setParent(axe)

	return EventResult.Handled
end

function defaultUpdate(updateData)

	local elapsedTime = updateData:getElapsedTime() / 1000.0

	if (InputHandler:wasTriggered(Key.C) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.Start)) then
		debugCamEnabled = not debugCamEnabled
	end

	if (debugCamEnabled) then
		debugCam:setComponentStates(ComponentState.Active)
		debugCam:update(elapsedTime)
	else
		cam:setComponentStates(ComponentState.Active)
	end

	-- virtual analog stick (WASD)
	local virtualStick = Vec2(0, 0)
	if (InputHandler:isPressed(Key.A)) then virtualStick.x = virtualStick.x - 1 end
	if (InputHandler:isPressed(Key.D)) then virtualStick.x = virtualStick.x + 1 end
	if (InputHandler:isPressed(Key.W)) then virtualStick.y = virtualStick.y + 1 end
	if (InputHandler:isPressed(Key.S)) then virtualStick.y = virtualStick.y - 1 end
	virtualStick = virtualStick:normalized()
	-- gamepad input
	local gamepad = InputHandler:gamepad(0)
	local leftStick = gamepad:leftStick()
	local rightStick = gamepad:rightStick()
	-- mose input
	local mouseDelta = InputHandler:getMouseDelta()
	
	-- combined move vector
	local moveVector = virtualStick + leftStick
	
--	local moveVector3 = Vec3(moveVector.x, moveVector.y, 0)
--	moveVector3 = cam.cc:getWorldRotation():toMat3():mulVec3(moveVector3)
--	DebugRenderer:drawArrow(character:getPosition(), character:getPosition() + moveVector3:mulScalar(250))
	
	-- update axe collider
--	local axeColliderPos = axeCollider:getPosition()
--	local axeHeadPos = axe:getWorldPosition()-- + axe:getViewDirection():mulScalar(50)
--	DebugRenderer:drawArrow(axeColliderPos, axeHeadPos)
--	axeCollider:setPosition(axeHeadPos)

	-- start attack
	if (not character.attacking) then
		if (InputHandler:wasTriggered(Key.Space) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.X)) then
			character.attacking = true
			character.walkSpeed = 0
			character.rotationSpeed = 0
			character.ac:easeOut("Walk", 0.2)
			character.ac:easeOut("Run", 0.2)
			character.ac:easeIn("Attack", 0.2)
			character.ac:setLocalTimeNormalized("Attack", 0.0)
		end
	end

	character.relativeSpeed = character.walkSpeed / character.maxWalkSpeed
	if (character.relativeSpeed < 0) then
		character.relativeSpeed = -character.relativeSpeed
	end	
	
	-- while attacking
	if (character.attacking) then
		local localTimeNormalized = character.ac:getLocalTimeNormalized("Attack")

		-- hitting stuff
		if (localTimeNormalized >= 0.35 and localTimeNormalized <= 0.55) then
			axe.pc.rb:setCollisionFilterInfo(0x2)
		--	local charPos = character:getPosition()
		--	local charDir = character:getViewDirection()
		--	local axePos = charPos + charDir:mulScalar(150)
		--	axePos.z = 100
		--	DebugRenderer:drawArrow(charPos, axePos)
		--	for i, v in ipairs(spheres) do
		--		local spherePos = v:getPosition()
		--		local distVec = spherePos - axePos
		--		if (distVec:length() <= 110) then
		--			local impulseDir = character:getViewDirection()
		--			impulseDir.z = 0.75
		--			impulseDir = impulseDir:normalized()
		--			v.pc.rb:applyLinearImpulse(impulseDir:mulScalar(500000))
		--			v.pc.rb:setAngularVelocity(Vec3(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)))
		--		end
		--	end
		else
			axe.pc.rb:setCollisionFilterInfo(0x0)
		end

		-- attack ends
		if (localTimeNormalized >= 0.90) then
			character.attacking = false
			character.ac:easeIn("Walk", 0.2)
			character.ac:easeIn("Run", 0.2)
			character.ac:easeOut("Attack", 0.2)
		end

	-- idle, walking, and running
	else

		-- walking
		character.walkSpeed = character.maxWalkSpeed * moveVector.y
		if (character.walkSpeed < 0) then
			character.walkSpeed = character.walkSpeed * 0.75
			character.ac:setPlaybackSpeed("Walk", -0.75)
			character.ac:setPlaybackSpeed("Run", -0.75)
		else
			character.ac:setPlaybackSpeed("Walk", 1.5)
			character.ac:setPlaybackSpeed("Run", 1.5)
		end
		DebugRenderer:printText(Vec2(-0.9, 0.70), "character.walkSpeed " .. string.format("%5.2f", character.walkSpeed))

		-- turning
		character.rotationSpeed = character.maxRotationSpeed * -moveVector.x * elapsedTime
		DebugRenderer:printText(Vec2(-0.9, 0.65), "character.rotationSpeed " .. string.format("%5.2f", character.rotationSpeed))

		-- walk and run animation weights
		local maxWeight = 1.0
		local threshold = 0.65
		local walkWeight = 0.0
		local runWeight = 0.0
		if (character.relativeSpeed <= threshold) then
			walkWeight = maxWeight * (character.relativeSpeed / threshold)
		else
			walkWeight = maxWeight * (1.0 - ((character.relativeSpeed - threshold) / (1.0 - threshold)))
			runWeight = maxWeight - walkWeight
		end
		character.ac:setMasterWeight("Walk", walkWeight)
		DebugRenderer:printText(Vec2(-0.9, 0.60), "walkWeight " .. string.format("%6.3f", walkWeight))
		character.ac:setMasterWeight("Run", runWeight)
		DebugRenderer:printText(Vec2(-0.9, 0.55), "runWeight " .. string.format("%6.3f", runWeight))
	end

	-- set forces
	local viewDirection = character:getViewDirection()
	character.pc.rb:applyLinearImpulse(viewDirection:mulScalar(character.walkSpeed))
	character.pc.rb:setAngularVelocity(Vec3(0, 0, character.rotationSpeed))

	-- third person cam
	cam.rotation = cam.rotation + (mouseDelta.x * 50 * elapsedTime) + (rightStick.x * -200 * elapsedTime)
	if (cam.rotation > 180) then
		cam.rotation = cam.rotation - 360
	end
	if (cam.rotation < -180) then
		cam.rotation = cam.rotation + 360
	end
	cam.rotation = cam.rotation * (1 - 1.5 * character.relativeSpeed * elapsedTime)
	DebugRenderer:printText(Vec2(-0.9, 0.50), "cam.rotation " .. string.format("%5.2f", cam.rotation))
	local invDir = character:getViewDirection():mulScalar(-350)
	local rotQuat = Quaternion(Vec3(0.0, 0.0, 1.0), cam.rotation)
	local rotMat = rotQuat:toMat3()
	local rotInvDir = rotMat:mulVec3(invDir)
	local camPos = character:getPosition() + rotInvDir
	camPos.z = 250
	local camAim = character:getPosition()
	camAim.z = 50
	local realCamPos = cam.cc:getPosition()
	local newCamPos = realCamPos + (camPos - realCamPos):mulScalar(5 * elapsedTime)
	cam.cc:setPosition(newCamPos)
	cam.cc:lookAt(camAim)

	return EventResult.Handled
end

-- global state machine
State{
	name = "default",
	parent = "/game/gameRunning",
	eventListeners = {
		enter = { defaultEnter },
		update = { defaultUpdate }
	}
}
StateTransitions{
	parent = "/game/gameRunning",
	{ from = "__enter", to = "default" }
}
StateTransitions{
	parent = "/game",
	{ from = "gameRunning", to = "__leave", condition = function() return bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.Back) end }
}

timedStatusDisplayStart()
