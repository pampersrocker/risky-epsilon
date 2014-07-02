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
	DebugRenderer:printText(Vec2(-0.2, 0.9), "totalElapsedTime: "..GameLogic.totalElapsedTime)	
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
		DebugRenderer:printText(Vec2(-0.2, 0.55), "Game Mechanics.")
		DebugRenderer:printText(Vec2(0.0, 0.55), "Switches could only be triggered with a stone sphere.")
		DebugRenderer:printText(Vec2(0.0, 0.5), "Some fans need to be turned on.")

		DebugRenderer:printText(Vec2(-0.2, 0.4), "Keyboard Usage:")
		DebugRenderer:printText(Vec2(0.0, 0.4), KeyCodes[Config.keys.keyboard.pause] .." - Pause the game")
		DebugRenderer:printText(Vec2(0.0, 0.35), KeyCodes[Config.keys.keyboard.lastTransformator] .." - Start at last transformator")
		DebugRenderer:printText(Vec2(0.0, 0.3), KeyCodes[Config.keys.keyboard.restart] .." - Restart level")
		DebugRenderer:printText(Vec2(0.0, 0.25), "F2 - Debug drawings")

		DebugRenderer:printText(Vec2(-0.2, 0.15), "Gamepad Usage:")
		DebugRenderer:printText(Vec2(0.0, 0.15), KeyCodes[Config.keys.gamepad.pause] .." - Pause the game")
		DebugRenderer:printText(Vec2(0.0, 0.1), KeyCodes[Config.keys.gamepad.lastTransformator] .." - Start at last transformator")
		DebugRenderer:printText(Vec2(0.0, 0.05), KeyCodes[Config.keys.gamepad.restart] .." - Restart level")
		DebugRenderer:printText(Vec2(0.0, 0.0), "F2 - Debug drawings")



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
	GameLogic.deathCount = 0
	local go = GetGObyGUID("playerInstance")
	if not(GameLogic.isoCam.trackingObject == go) then
		ChangePlayer(go)
	end
	ResetCamera()
end

function GameLogic.lastTransformator()
	GameLogic.deathCount = GameLogic.deathCount + 1
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
	DebugRenderer:_printText2D(Vec2(0.0, 0.7), "Input your name: "..GameLogic.Name ,Color(1, 1, 1, 1.0))
	
	if(InputHandler:isPressed(Config.keys.keyboard.restart)) then
		GameLogic.restart()
	end
	local buttonsTriggered = InputHandler:gamepad(0):buttonsTriggered()
	if InputHandler:gamepad(0):isConnected() then
		if (bit32.btest(buttonsTriggered, Config.keys.gamepad.restart) ) then
			GameLogic.restart()
		end
	end
	if(InputHandler:wasTriggered(Key.A)) then
		GameLogic.Name = GameLogic.Name .. "A"
	end
	if(InputHandler:wasTriggered(Key.B)) then
		GameLogic.Name = GameLogic.Name .. "B"
	end
	if(InputHandler:wasTriggered(Key.C)) then
		GameLogic.Name = GameLogic.Name .. "C"
	end
	if(InputHandler:wasTriggered(Key.D)) then
		GameLogic.Name = GameLogic.Name .. "D"
	end
	if(InputHandler:wasTriggered(Key.E)) then
		GameLogic.Name = GameLogic.Name .. "E"
	end
	if(InputHandler:wasTriggered(Key.F)) then
		GameLogic.Name = GameLogic.Name .. "F"
	end
	if(InputHandler:wasTriggered(Key.G)) then
		GameLogic.Name = GameLogic.Name .. "G"
	end
	if(InputHandler:wasTriggered(Key.H)) then
		GameLogic.Name = GameLogic.Name .. "H"
	end
	if(InputHandler:wasTriggered(Key.I)) then
		GameLogic.Name = GameLogic.Name .. "I"
	end
	if(InputHandler:wasTriggered(Key.J)) then
		GameLogic.Name = GameLogic.Name .. "J"
	end
	if(InputHandler:wasTriggered(Key.K)) then
		GameLogic.Name = GameLogic.Name .. "K"
	end
	if(InputHandler:wasTriggered(Key.L)) then
		GameLogic.Name = GameLogic.Name .. "L"
	end
	if(InputHandler:wasTriggered(Key.M)) then
		GameLogic.Name = GameLogic.Name .. "M"
	end
	if(InputHandler:wasTriggered(Key.N)) then
		GameLogic.Name = GameLogic.Name .. "N"
	end
	if(InputHandler:wasTriggered(Key.O)) then
		GameLogic.Name = GameLogic.Name .. "O"
	end
	if(InputHandler:wasTriggered(Key.P)) then
		GameLogic.Name = GameLogic.Name .. "P"
	end
	if(InputHandler:wasTriggered(Key.Q)) then
		GameLogic.Name = GameLogic.Name .. "Q"
	end
	if(InputHandler:wasTriggered(Key.R)) then
		GameLogic.Name = GameLogic.Name .. "R"
	end
	if(InputHandler:wasTriggered(Key.S)) then
		GameLogic.Name = GameLogic.Name .. "S"
	end
	if(InputHandler:wasTriggered(Key.T)) then
		GameLogic.Name = GameLogic.Name .. "T"
	end
	if(InputHandler:wasTriggered(Key.U)) then
		GameLogic.Name = GameLogic.Name .. "U"
	end
	if(InputHandler:wasTriggered(Key.V)) then
		GameLogic.Name = GameLogic.Name .. "V"
	end
	if(InputHandler:wasTriggered(Key.W)) then
		GameLogic.Name = GameLogic.Name .. "W"
	end
	if(InputHandler:wasTriggered(Key.X)) then
		GameLogic.Name = GameLogic.Name .. "X"
	end
	if(InputHandler:wasTriggered(Key.Y)) then
		GameLogic.Name = GameLogic.Name .. "Y"
	end
	if(InputHandler:wasTriggered(Key.Z)) then
		GameLogic.Name = GameLogic.Name .. "Z"
	end
	if(InputHandler:wasTriggered(Key.Back)) then
		GameLogic.Name = string.sub(GameLogic.Name, 1, -2)
	end
	if(InputHandler:wasTriggered(Key.Return)) then
		if (GameLogic.notSaved == true) then
			SaveHighscore()
		end
	end
	
	return EventResult.Handled;
end

function GameLogic.enterEnd( updateData )
	-- body
	logMessage("Entering End state");
	local go = GameLogic.isoCam.trackingObject
	go.go.pc:setState(ComponentState.Inactive)
	GameLogic.Name = ""
	GameLogic.notSaved = true
	return EventResult.Handled;
end

function GameLogic.leaveEnd( updateData )
	-- body
	logMessage("Leaving End state");

	local go = GameLogic.isoCam.trackingObject
	go.go.pc:setState(ComponentState.Active)
	return EventResult.Handled;
end

function SaveHighscore()
	local f,err = io.open("highscores.txt","a")
	if not f then return print(err) end
	f:write(GameLogic.Name .. " :")
	f:write("\n")
	f:write("Time: "..GameLogic.totalElapsedTime)
	f:write("\n")
	f:write("Death count: "..GameLogic.deathCount)
	f:write("\n")	
	f:write("---------------------------------------------------")
	f:write("\n")	
	f:close()
	GameLogic.notSaved = false
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