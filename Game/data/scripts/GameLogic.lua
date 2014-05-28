
GameLogic = CreateEmptyGameObject("GameLogic")

function GameLogic:update( guid, elapsedTime )
	logMessage("UPDATE!")
end

function GameLogic:init( ... )
	-- body
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.81)
	cinfo.worldSize = 4000.0
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)
end

function GameLogic:destroy( ... )
	-- body
	logMessage("DESTROY!")
end

-------------------------------------------------------
-- Running State
-------------------------------------------------------
function GameLogic:updateRunning( updateData )
	-- body
	logMessage("Updating running state");
	return EventResult.Handled;
end

function GameLogic:enterRunning( updateData )
	-- body
	logMessage("Entering running state");
	return EventResult.Handled;
end

function GameLogic:leaveRunning( updateData )
	-- body
	logMessage("Leaving running state");
	return EventResult.Handled;
end


-------------------------------------------------------
-- Pause State
-------------------------------------------------------

function GameLogic:updatePause( updateData )
	-- body
	logMessage("Updating Pause state");
	return EventResult.Handled;
end

function GameLogic:enterPause( updateData )
	-- body
	logMessage("Entering Pause state");
	return EventResult.Handled;
end

function GameLogic:leavePause( updateData )
	-- body
	logMessage("Leaving Pause state");
	return EventResult.Handled;
end



-------------------------------------------------------
-- Transitions
-------------------------------------------------------
function GameLogic:checkPause()
	return false;
end

function GameLogic:checkUnPause()
	return false;
end

function GameLogic:canLeave()
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

CreateScriptComponent(GameLogic, GameLogic.init, GameLogic.update, GameLogic.destroy)