-- Help function to simplify code

logMessage("Utils")
function IsNull(x)
	if x==nil then
		return true
	elseif x.__ptr == nil then
		return true
	elseif x.__ptr == null then
		return true
	else
		return false
	end


end

function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function createPhantomCallbackTriggerBox(guid, halfExtends, position)
	local trigger = CreateEmptyGameObject( guid )
	trigger.pc = trigger.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	local boundingShape = PhysicsFactory:createBox(halfExtends)
	local phantomCallbackShape = PhysicsFactory:createPhantomCallbackShape(halfExtends)
	cinfo.shape = PhysicsFactory:createBoundingVolumeShape(boundingShape, phantomCallbackShape)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	trigger.pc.rb = trigger.pc:createRigidBody(cinfo)
	trigger.phantomCallback = phantomCallbackShape

	return trigger
end

function CreateEmptyGameObject( name )
	local go = GameObjectManager:getGameObject(name)
	if IsNull(go) then

		local instance = {}
		logMessage("Create new gameObject with name " .. name)
		instance.go = GameObjectManager:createGameObject(name);
		SetGObyGUID(name,instance)
		return instance
	else

		logMessage("return existing gameObject " .. name )
		return GetGObyGUID(name)
	end


end

function CreateScriptComponent( gameObject, initFunction , updateFunction, destroyFunction )

	gameObject.go.sc = gameObject.go:createScriptComponent();
	gameObject.go.sc:setInitializationFunction( initFunction );
	gameObject.go.sc:setUpdateFunction( updateFunction );
	gameObject.go.sc:setDestroyFunction( destroyFunction );
	return gameObject.go.sc;
end

function CreateRenderComponent( gameObject, path )
	gameObject.go.rc = gameObject.go:createRenderComponent();
	gameObject.go.rc:setPath( path );
	return gameObject.go.rc;
end

function CreatePhysicsComponent( gameObject, phyParams )
	gameObject.go.pc = gameObject.go:createPhysicsComponent();
	gameObject.go.rb = gameObject.go.pc:createRigidBody(phyParams);
	return gameObject.go.rb;
end

function createDefaultCam(guid)
	local cam = CreateEmptyGameObject(guid)
	cam.go.cc = cam.go:createCameraComponent()
	cam.go.cc:setPosition(Vec3(0.0, 0.0, 0.0))
	cam.go.cc:setViewDirection(Vec3(-1.0, 0.0, 0.0))
	cam.go.baseViewDir = Vec3(1.0, 0.0, 0.0)
	cam.go.cc:setBaseViewDirection(cam.go.baseViewDir)
	cam.distance = Config.camera.distance
	return cam
end


function CreateCollisionBox(guid, halfExtends, position)
	local box = GameObjectManager:createGameObject(guid)
	box.pc = box:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(halfExtends)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	box.pc.rb = box.pc:createRigidBody(cinfo)
	return box
end

function CreateCollisionSphere(guid, radius, position)
	local box = GameObjectManager:createGameObject(guid)
	box.pc = box:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(radius)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	box.pc.rb = box.pc:createRigidBody(cinfo)
	return box
end

local GameObjects = {}

function GetGObyGUID( guid )
	return GameObjects[guid]
end

function SetGObyGUID( guid , instance )
	GameObjects[guid] = instance
end

function ResetCamera()
	GameLogic.isoCam.go.cc:setViewDirection(Vec3(-1.0, 0.0, 0.0))
	GameLogic.isoCam.go.cc:look(Config.camera.initLook)	
	GameLogic.isoCam.distance = Config.camera.distance
end

function ChangePlayer( newGo )
	-- inactivate current player
	GameLogic.isoCam.trackingObject.go:setComponentStates(ComponentState.Inactive)

	-- activate newGo player
	newGo.go.rb:setAngularVelocity(GameLogic.isoCam.trackingObject.go.rb:getAngularVelocity())
	newGo.go.rb:setLinearVelocity(GameLogic.isoCam.trackingObject.go.rb:getLinearVelocity())
	newGo.go:setPosition(GameLogic.isoCam.trackingObject.go:getWorldPosition())
	newGo.go:setComponentStates(ComponentState.Active)
	newGo.lastTransformator = GameLogic.isoCam.trackingObject.lastTransformator
	-- change cam-lockAT
	GameLogic.isoCam.trackingObject = newGo

	for k,v in pairs(GameLogic.fractures) do
		v.go:setPosition(GameLogic.isoCam.trackingObject.go:getWorldPosition())
		v.go:setComponentStates(ComponentState.Active)
	end

end