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
	DebugRenderer:printText(Vec2(0.8, 0.9), "F1 - help")
	if (GameLogic.debugDrawings == true)then
		DebugRenderer:printText(Vec2(-0.9, 0.9), "State: running")
	end
	IsoCamera.update( updateData:getElapsedTime() )
	GameLogic.totalElapsedTime = GameLogic.totalElapsedTime + updateData:getElapsedTime()
	if (GameLogic.debugDrawings == true)then
		DebugRenderer:printText(Vec2(-0.9, 0.1), "totalElapsedTime: "..GameLogic.totalElapsedTime)
	end
	
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
	if (InputHandler:wasTriggered(Key.F2) ) then
		if not GameLogic.debugDrawings then
			GameLogic.debugDrawings = true
		else
			GameLogic.debugDrawings = false
		end
	end	
	if (InputHandler:wasTriggered(Key.F1) ) then
		if not GameLogic.showHelp then
			GameLogic.showHelp = true
		else
			GameLogic.showHelp = false
		end
	end	
	
	-- show help screen
	if (GameLogic.showHelp == true) then
		DebugRenderer:printText(Vec2(0.0, 0.5), "Switches could only be triggered with a stone sphere.")
		DebugRenderer:printText(Vec2(0.0, 0.45), "Some fans need to be turned on.")
		DebugRenderer:printText(Vec2(0.0, 0.4), "Backspace - Start at last transformator.")
		DebugRenderer:printText(Vec2(0.0, 0.35), "R - Restart level.")
		DebugRenderer:printText(Vec2(0.0, 0.3), "F2 - Debug drawings.")
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

function GameLogic.restart()
	GameLogic.isoCam.trackingObject.go:setPosition(Config.player.spawnPosition)
	GameLogic.isoCam.trackingObject.go.rb:setAngularVelocity(Vec3(0,0,0))
	GameLogic.isoCam.trackingObject.go.rb:setLinearVelocity(Vec3(0,0,0))
	GameLogic.totalElapsedTime = 0
	GameLogic.isoCam.trackingObject.lastTransformator = Config.player.lastTransformator
	GameLogic.finished = false
	local go = GetGObyGUID("playerInstance")
	if not(GameLogic.isoCam.trackingObject == go) then
		ChangePlayer(go)
	end
	ResetCamera()
end

function GameLogic.lastTransformator()
	GameLogic.isoCam.trackingObject.go:setPosition(GameLogic.isoCam.trackingObject.lastTransformator)
	GameLogic.isoCam.trackingObject.go.rb:setAngularVelocity(Vec3(0,0,0))
	GameLogic.isoCam.trackingObject.go.rb:setLinearVelocity(Vec3(0,0,0))
	
end


-------------------------------------------------------
-- Pause State
-------------------------------------------------------

function GameLogic.updatePause( updateData )
	-- body
	if (GameLogic.debugDrawings == true)then
		DebugRenderer:printText(Vec2(-0.9, 0.9), "State: pause")
	end
	local red = 1
	local green = 0
	local blue =0
	
	for i=-0.5,0.5,0.05 do
		if (i < -0.25) then
			green = green + 0.2
		elseif (i > -0.25 and i <0) then
			red = red - 0.2
		elseif (i > 0 and i <0.25) then
			blue = blue + 0.2
		elseif (i > 0.25 and i <0.5) then
			green = green - 0.2
		end
		for j=-1,1,0.1 do			
			DebugRenderer:_printText2D(Vec2(j, i), "PAUSE!!! ",Color(red, green, blue, 1.0))
		end
	end
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
-- End State
-------------------------------------------------------

function GameLogic.updateEnd( updateData )
	-- body
	if (GameLogic.debugDrawings == true)then
		DebugRenderer:printText(Vec2(-0.9, 0.9), "State: End")
	end
	local red = 1
	local green = 0
	local blue =0
	
	for i=-0.5,0.5,0.05 do
		if (i < -0.25) then
			green = green + 0.2
		elseif (i > -0.25 and i <0) then
			red = red - 0.2
		elseif (i > 0 and i <0.25) then
			blue = blue + 0.2
		elseif (i > 0.25 and i <0.5) then
			green = green - 0.2
		end
		for j=-0.5,0.5,0.05 do	
			DebugRenderer:_printText2D(Vec2(j, i), "End!!! ",Color(red, green, blue, 1.0))
		end
	end
	DebugRenderer:_printText2D(Vec2(0.0, 0.6), "Your time: "..GameLogic.totalElapsedTime,Color(1, 1, 1, 1.0))
	
	if(InputHandler:isPressed(Config.keys.keyboard.restart)) then
		GameLogic.restart()
	end
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if InputHandler:gamepad(0):isConnected() then
		if (bit32.btest(buttonsTriggered, Config.keys.gamepad.restart) ) then
			GameLogic.restart()
		end
	end
	return EventResult.Handled;
end

function GameLogic.enterEnd( updateData )
	-- body
	logMessage("Entering End state");
	local go = GameLogic.isoCam.trackingObject
	go.go.pc:setState(ComponentState.Inactive)
	return EventResult.Handled;
end

function GameLogic.leaveEnd( updateData )
	-- body
	logMessage("Leaving End state");

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

function GameLogic.checkEnd()
	return GameLogic.finished
end

function GameLogic.newStartLvl()
	return (InputHandler:wasTriggered(Config.keys.keyboard.restart) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Config.keys.gamepad.restart)) 
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
		},
		{
			name = "End",
			eventListeners =
			{
				update = { GameLogic.updateEnd },
				enter = { GameLogic.enterEnd },
				leave = { GameLogic.leaveEnd }
			}
		}
	},
	transitions =
	{
		{ from = "__enter", to = "Running" },
		{ from = "Running", to = "Pause", condition = GameLogic.checkPause },
		{ from = "Pause", to = "Running", condition = GameLogic.checkUnPause },
		{ from = "Pause", to = "__leave", condition = GameLogic.canLeave },
		{ from = "Running", to = "End", condition = GameLogic.checkEnd },
		{ from = "End", to = "__leave", condition = GameLogic.canLeave },
		{ from = "End", to = "Running", condition =  GameLogic.newStartLvl}
	}
}

StateTransitions{
	parent = "/game/gameRunning",
	{ from = "__enter", to = "GameStateMachine" }
}
CreateScriptComponent(GameLogic, GameLogic.init, GameLogic.update, GameLogic.destroy)