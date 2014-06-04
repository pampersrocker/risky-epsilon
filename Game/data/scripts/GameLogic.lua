GameLogic = CreateEmptyGameObject("GameLogic123")

function GameLogic.update( guid, elapsedTime )
end

function GameLogic.init( ... )
	-- body
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.81)
	cinfo.worldSize = 4000.0
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)

	--create Level
	logMessage("Creating Level")
	GameLogic.level = CreateEmptyGameObject("TestLevel")
	setmetatable(GameLogic.level, LevelMeta)
	CreateScriptComponent(GameLogic.level, LevelMeta.initialize, LevelMeta.update, LevelMeta.destroy)

	-- create player
	GameLogic.playerInstance = CreateEmptyGameObject("playerInstance")
	setmetatable( GameLogic.playerInstance, PlayerMeta)
	CreateScriptComponent(GameLogic.playerInstance, PlayerMeta.init, PlayerMeta.update, PlayerMeta.destroy)

	--create camera

	distance = 50.0
	distanceDelta = 5.0
	distanceMin = 15.0
	distanceMax = 200.0


	isoCam = createDefaultCam("IsoCam")
	isoCam.go.cc:look(Vec2(0.0, 20.0))

	setmetatable( isoCam, IsoCamera)
	CreateScriptComponent(isoCam, IsoCamera.init, IsoCamera.update, IsoCamera.destroy)
	logMessage("GameLogic:init()")
end


function GameLogic.destroy( ... )
	-- body
	logMessage("DESTROY!")
end

-------------------------------------------------------
-- Running State
-------------------------------------------------------
function GameLogic.updateRunning( updateData )
	return EventResult.Handled;
end

function GameLogic.enterRunning( updateData )
	-- body
	logMessage("Entering running state");
	return EventResult.Handled;
end

function GameLogic.leaveRunning( updateData )
	-- body
	logMessage("Leaving running state");
	return EventResult.Handled;
end


-------------------------------------------------------
-- Pause State
-------------------------------------------------------

function GameLogic.updatePause( updateData )
	-- body
	logMessage("Updating Pause state");
	return EventResult.Handled;
end

function GameLogic.enterPause( updateData )
	-- body
	logMessage("Entering Pause state");
	return EventResult.Handled;
end

function GameLogic.leavePause( updateData )
	-- body
	logMessage("Leaving Pause state");
	return EventResult.Handled;
end



-------------------------------------------------------
-- Transitions
-------------------------------------------------------
function GameLogic.checkPause()
	return false;
end

function GameLogic.checkUnPause()
	return false;
end

function GameLogic.canLeave()
	return false;
end


StateMachine{
	name = "GameStateMachine",
	parent = "/game/gameRunning",
	states =
	{
		{
			name = "Running",
			eventListeners =
			{
				update = { GameLogic.updateRunning },
				enter = { GameLogic.enterRunning },
				leave = { GameLogic.leaveRunning }
			}
		},
		{
			name = "Pause",
			eventListeners =
			{
				update = { GameLogic.updatePause },
				enter = { GameLogic.enterPause },
				leave = { GameLogic.leavePause }
			}
		}
	},
	transitions =
	{
		{ from = "__enter", to = "Running" },
		{ from = "Running", to = "Pause", condition = GameLogic.checkPause },
		{ from = "Pause", to = "Running", condition = GameLogic.checkUnPause },
		{ from = "Pause", to = "__leave", condition = GameLogic.canLeave }
	}
}

StateTransitions{
	parent = "/game/gameRunning",
	{ from = "__enter", to = "GameStateMachine" }
}
CreateScriptComponent(GameLogic, GameLogic.init, GameLogic.update, GameLogic.destroy)