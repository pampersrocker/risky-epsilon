
IsoCamera = {}

--[[CreateEmptyGameObject("camera")
]]

function IsoCamera.update( elapsedTime )
		elapsedTime = elapsedTime
		if(GameLogic.debugDrawings == true) then
			DebugRenderer:printText(Vec2(-0.9, 0.75), "elapsedTime: "..elapsedTime)
		end
		if (InputHandler:isPressed(Config.keys.keyboard.zoomin) ) then
			GameLogic.isoCam.distance = GameLogic.isoCam.distance - Config.camera.distanceDelta*elapsedTime
		elseif (InputHandler:isPressed(Config.keys.keyboard.zoomout)) then
			GameLogic.isoCam.distance = GameLogic.isoCam.distance + Config.camera.distanceDelta*elapsedTime
			
		end
		if(GameLogic.debugDrawings == true) then
			DebugRenderer:printText(Vec2(-0.9, 0.80), "Camera distance:" .. GameLogic.isoCam.distance)
		end
		local rotationSpeed = Config.camera.rotationSpeedFactor * elapsedTime
		local cameraDelta = InputHandler:getMouseDelta()
		GameLogic.isoCam.distance = GameLogic.isoCam.distance - cameraDelta.z
		cameraDelta.x = cameraDelta.x * rotationSpeed
		cameraDelta.y = 0.0
		cam = GameLogic.isoCam
		if InputHandler:gamepad(0):isConnected() then
			cameraDelta.x = cameraDelta.x + InputHandler:gamepad(0):rightStick().x * Config.camera.rotationSpeedFactorGamePad * elapsedTime
			local zoomvalue = InputHandler:gamepad(0):rightStick().y
			
			GameLogic.isoCam.distance = GameLogic.isoCam.distance - zoomvalue*Config.camera.zoomfactorgamepad * elapsedTime		
		end
		cam.go.cc:look(cameraDelta)
		local viewDir = cam.go.cc:getViewDirection()
		GameLogic.isoCam.distance = math.Clamp(GameLogic.isoCam.distance,Config.camera.distanceMin,Config.camera.distanceMax)
		viewDir = viewDir:mulScalar(-GameLogic.isoCam.distance)
		viewDir.z = GameLogic.isoCam.distance * Config.camera.hightFactor
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


