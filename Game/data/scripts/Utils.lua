-- Help function to simplify code

logMessage("Utils")

function CreateEmptyGameObject( name )
	local go = GameObjectManager:createGameObject(name);
	return go;
end

function CreateScriptComponent( gameObject, initFunction , updateFunction, destroyFunction )
	gameObject.sc = gameObject:createScriptComponent();
	gameObject.sc:setInitializationFunction( initFunction );
	gameObject.sc:setUpdateFunction( updateFunction );
	gameObject.sc:setDestroyFunction( destroyFunction );
	return gameObject.sc;
end

function CreateRenderComponent( gameObject, path )
	gameObject.rc = gameObject:createRenderComponent();
	gameObject.rc:setPath( path );
	return gameObject.rc;
end

function CreatePhysicsComponent( gameObject, phyParams )
	gameObject.pc = gameObject:createPhysicsComponent();
	gameObject.rb = gameObject.pc:createRigidBody(phyParams);
	return gameObject.rb;
end
