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

function CreateEmptyGameObject( name )
	local go = GameObjectManager:getGameObject(name)
	if IsNull(go) then
	
		local instance = {}
		logMessage("Create new gameObject")
		instance.go = GameObjectManager:createGameObject(name);
		SetGObyGUID(name,instance)
		return instance
	else
	
		logMessage("return existing gameObject"..name)
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
	cam.go.cc:setViewDirection(Vec3(1.0, 0.0, 0.0))
	cam.go.baseViewDir = Vec3(1.0, 0.0, 0.0)
	cam.go.cc:setBaseViewDirection(cam.go.baseViewDir)
	return cam
end

--[[
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
]]

local GameObjects = {}

function GetGObyGUID( guid )
	return GameObjects[guid]
end

function SetGObyGUID( guid , instance )
	GameObjects[guid] = instance
end