
IsoCamera = {}

--[[CreateEmptyGameObject("camera")
]]

function IsoCamera.update( guid, elapsedTime )
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
	local rotationSpeed = 0.05 * elapsedTime
	local mouseDelta = InputHandler:getMouseDelta()
	mouseDelta.x = mouseDelta.x * rotationSpeed
	mouseDelta.y = 0.0
	cam = GetGObyGUID(guid)
	cam.go.cc:look(mouseDelta)
	local viewDir = cam.go.cc:getViewDirection()
	viewDir = viewDir:mulScalar(-distance)
	viewDir.z = distance/2
	--TODO: get guid from player the right way!!
	-- by cam.trackingobject = playerobject in gamelogic.lua
	cam.go.cc:setPosition(GetGObyGUID("playerInstance").go:getWorldPosition() + viewDir)
end

function IsoCamera.init( ... )
end

function IsoCamera.destroy( ... )
	-- body
end

