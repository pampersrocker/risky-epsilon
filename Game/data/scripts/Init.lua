logMessage("Init is being executed!")

function LoadScripts()
	Scripting:registerScript("Utils.lua")
	Scripting:registerScript("Player/Player.lua")
	Scripting:registerScript("Camera/IsometricCamera.lua")
	Scripting:registerScript("GameLogic.lua")


	Scripting:registerScript("Levels/MaterialTest.lua")
end

LoadScripts()