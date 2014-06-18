GameLogic = CreateEmptyGameObject("GameLogic123")

function GameLogic.update( guid, elapsedTime )
end

function GameLogic.init( ... )

end


function GameLogic.destroy( ... )
	-- body
	logMessage("DESTROY!")
end

-------------------------------------------------------
-- Running State
-------------------------------------------------------
function GameLogic.updateRunning( updateData )
	DebugRenderer:printText(Vec2(-0.9, 0.9), "State: running")
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if (InputHandler:isPressed(Key._1) or bit32.btest(buttonsTriggered, Button.X)) then
		local go = GetGObyGUID("playerInstance")
		ChangePlayer(go)
	elseif (InputHandler:isPressed(Key._2) or bit32.btest(buttonsTriggered, Button.Y)) then
		local go = GetGObyGUID("playerInstanceStone")
		ChangePlayer(go)
	end
	
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
	DebugRenderer:printText(Vec2(-0.9, 0.9), "State: pause")
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
	return (InputHandler:wasTriggered(Config.keys.keyboard.pause) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Config.keys.gamepad.pause))
end

function GameLogic.checkUnPause()
	return (InputHandler:wasTriggered(Config.keys.keyboard.pause) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Config.keys.gamepad.pause))
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