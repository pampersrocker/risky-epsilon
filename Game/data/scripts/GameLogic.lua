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
	
	IsoCamera.update( updateData:getElapsedTime() )
	
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if (InputHandler:isPressed(Key._1) or bit32.btest(buttonsTriggered, Button.X)) then
		local go = GetGObyGUID("playerInstance")
		ChangePlayer(go)
	elseif (InputHandler:isPressed(Key._2) or bit32.btest(buttonsTriggered, Button.Y)) then
		local go = GetGObyGUID("playerInstanceStone")
		ChangePlayer(go)
	elseif (InputHandler:isPressed(Key._3) or bit32.btest(buttonsTriggered, Button.A)) then
		local go = GetGObyGUID("playerInstancePaper")
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
	local red = 1
	local green = 0
	local blue =0
	
	for i=-1,1,0.05 do
		if (i < -0.5) then
			green = green + 0.1
		elseif (i > -0.5 and i <0) then
			red = red - 0.1
		elseif (i > 0 and i <0.5) then
			blue = blue + 0.1
		elseif (i > 0.5 and i <1) then
			green = green - 0.1
		end
		for j=-1,1,0.1 do			
			DebugRenderer:printTextColor(Vec2(j, i), "PAUSE!!! ",Color(red, green, blue, 1.0))
		end
	end
	logMessage("Updating Pause state");
	return EventResult.Handled;
end

function GameLogic.enterPause( updateData )
	-- body
	logMessage("Entering Pause state");
	local go = GameLogic.isoCam.trackingObject
	go.go.pc:setState(ComponentState.Inactive)
	return EventResult.Handled;
end

function GameLogic.leavePause( updateData )
	-- body
	logMessage("Leaving Pause state");

	local go = GameLogic.isoCam.trackingObject
	go.go.pc:setState(ComponentState.Active)
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