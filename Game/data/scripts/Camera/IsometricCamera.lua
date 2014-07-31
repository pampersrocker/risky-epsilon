
IsoCamera = {}


function IsoCamera.update( elapsedTime )

		-- draw elapsed time
		if(GameLogic.debugDrawings == true) then
			DebugRenderer:printText(Vec2(-0.9, 0.75), "elapsedTime: "..elapsedTime)
		end

		-- handle zoom input
		if (InputHandler:isPressed(Config.keys.keyboard.zoomin) ) then
			GameLogic.isoCam.distance = GameLogic.isoCam.distance - Config.camera.distanceDelta*elapsedTime
		elseif (InputHandler:isPressed(Config.keys.keyboard.zoomout)) then
			GameLogic.isoCam.distance = GameLogic.isoCam.distance + Config.camera.distanceDelta*elapsedTime
		end

		-- draw camera distance
		if(GameLogic.debugDrawings == true) then
			DebugRenderer:printText(Vec2(-0.9, 0.80), "Camera distance:" .. GameLogic.isoCam.distance)
		end

		-- rotate camera around player
		local rotationSpeed = Config.camera.rotationSpeedFactor * elapsedTime
		local cameraDelta = InputHandler:getMouseDelta()
		GameLogic.isoCam.distance = GameLogic.isoCam.distance - cameraDelta.z
		cameraDelta.x = cameraDelta.x * rotationSpeed
		cameraDelta.y = 0.0
		cam = GameLogic.isoCam
		-- if gamepad is connected add zoom and rotation from gamepad input 
		if InputHandler:gamepad(0):isConnected() then
			cameraDelta.x = cameraDelta.x + InputHandler:gamepad(0):rightStick().x * Config.camera.rotationSpeedFactorGamePad * elapsedTime
			local zoomvalue = InputHandler:gamepad(0):rightStick().y
			GameLogic.isoCam.distance = GameLogic.isoCam.distance - zoomvalue*Config.camera.zoomfactorgamepad * elapsedTime		
		end

		-- set new view direction
		cam.go.cc:look(cameraDelta)
		local viewDir = cam.go.cc:getViewDirection()
		GameLogic.isoCam.distance = math.Clamp(GameLogic.isoCam.distance,Config.camera.distanceMin,Config.camera.distanceMax)
		viewDir = viewDir:mulScalar(-GameLogic.isoCam.distance)
		viewDir.z = GameLogic.isoCam.distance * Config.camera.hightFactor
		cam.go.cc:setPosition(GameLogic.isoCam.trackingObject.go:getWorldPosition() + viewDir)
	
end

function IsoCamera.init( ... )
	
	logMessage("IsoCamera:init() ")
end

function IsoCamera.destroy( ... )
	-- body
	logMessage("DESTROY!")
end


