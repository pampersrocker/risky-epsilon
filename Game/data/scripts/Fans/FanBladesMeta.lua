FanBladesMeta = {}

---------------------------
-- initialize a fanblade --
--------------------------- 
function FanBladesMeta:initializeGameObjectFanBlade( name, pos, active, rotationaxis, baserotation)
	logMessage("FanMeta:init() start ")
	self.isActive = active	
	self.rotationaxis = rotationaxis
	CreateRenderComponent(self, "data/models/LevelElements/track_fan.thModel")
	self.go:setPosition(pos)
	self.go:setRotation(baserotation)
	logMessage("FanBladesMeta:init() end")
end

-----------------------
-- update a fanblade --
----------------------- 
function FanBladesMeta.update( guid, elapsedTime )
	local fan = GetGObyGUID(guid)
	
	-- if fan is active rotate the fanblade in order to make the activation of the fan visible. 
	if fan.isActive then
		fan.go:setRotation(fan.go:getRotation() * Quaternion(fan.rotationaxis, 9 * elapsedTime * 60))
	end
end

-------------------------
-- activate a fanblade --
------------------------- 
function FanBladesMeta:Activate()
	self.isActive = true
end

---------------------------
-- deactivate a fanblade --
--------------------------- 
function FanBladesMeta:Deactivate()
	self.isActive = false
end

function FanBladesMeta.init( guid )
	-- body
end

function FanBladesMeta.destroy( ... )
	-- body
end