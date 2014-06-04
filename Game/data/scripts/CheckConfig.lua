CheckConfig = {}


function CheckConfigValues()
	if( Config.camera.hightFactor > 1 or Config.camera.hightFactor < 0) then
		logError("CheckConfig: Invalid value of Config.camera.hightFactor")
	end
		if( Config.camera.distanceDelta  < 0) then
		logWarning("CheckConfig: Negative value of Config.camera.distanceDelta")
	end
end

CheckConfigValues()

