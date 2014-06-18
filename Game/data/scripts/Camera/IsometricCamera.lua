
IsoCamera = {}

--[[CreateEmptyGameObject("camera")
]]

function IsoCamera.update( guid, elapsedTime )
	elapsedTime = elapsedTime/1000
	DebugRenderer:printText(Vec2(-0.9, 0.75), "elapsedTime: "..elapsedTime)
	if (InputHandler:isPressed(Config.keys.keyboard.zoomin) ) then
		Config.camera.initialDistance = Config.camera.initialDistance - Config.camera.distanceDelta*elapsedTime
	elseif (InputHandler:isPressed(Config.keys.keyboard.zoomout)) then
		Config.camera.initialDistance = Config.camera.initialDistance + Config.camera.distanceDelta*elapsedTime
		
	end
	DebugRenderer:printText(Vec2(-0.9, 0.85), "isometric")
	DebugRenderer:printText(Vec2(-0.9, 0.80), "Camera distance:" .. Config.camera.initialDistance)
	local rotationSpeed = Config.camera.rotationSpeedFactor * elapsedTime
	local cameraDelta = InputHandler:getMouseDelta()
	cameraDelta.x = cameraDelta.x * rotationSpeed
	cameraDelta.y = 0.0
	cam = GetGObyGUID(guid)
	if InputHandler:gamepad(0):isConnected() then
		cameraDelta.x = cameraDelta.x + InputHandler:gamepad(0):rightStick().x * Config.camera.rotationSpeedFactorGamePad * elapsedTime
		local zoomvalue = InputHandler:gamepad(0):rightStick().y
		
		Config.camera.initialDistance = Config.camera.initialDistance - zoomvalue*Config.camera.zoomfactorgamepad * elapsedTime		
	end
	cam.go.cc:look(cameraDelta)
	local viewDir = cam.go.cc:getViewDirection()
	Config.camera.initialDistance = math.Clamp(Config.camera.initialDistance,Config.camera.distanceMin,Config.camera.distanceMax)
	viewDir = viewDir:mulScalar(-Config.camera.initialDistance)
	viewDir.z = Config.camera.initialDistance * Config.camera.hightFactor
	--TODO: get guid from player the right way!!
	-- by cam.trackingobject = playerobject in gamelogic.lua
	cam.go.cc:setPosition(GameLogic.isoCam.trackingObject.go:getWorldPosition() + viewDir)
end

function IsoCamera.init( ... )

	logMessage("IsoCamera:init() ")
end

function IsoCamera.destroy( ... )
	-- body
	logMessage("DESTROY!")
end


