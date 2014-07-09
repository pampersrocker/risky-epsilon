
FanMeta = {}

function FanMeta:initializeGameObjectFan1( name, size, pos, active, force)
	logMessage("FanMeta:init() start ")
	self.isTriggered = false
	self.isActive = active
	self.force = force
	self.trigger = FanMeta:createPhantomCallbackTriggerBox(name, size, pos)
	self.trigger.go.phantomCallback:getEnterEvent():registerListener(function(arg)
		self.isTriggered = true
		return EventResult.Handled
	end)
	self.trigger.go.phantomCallback:getLeaveEvent():registerListener(function(arg)
		self.isTriggered = false
		
		return EventResult.Handled
	end)
	
	
	logMessage("FanMeta:init() end")
end


function FanMeta.update( guid, elapsedTime )
	local fan = GetGObyGUID(guid)
		
	if fan.isActive and fan.isTriggered then
		GameLogic.isoCam.trackingObject.go.rb:applyForce(elapsedTime, fan.force)
	end
end

function FanMeta:Activate()
	self.isActive = true

	for _, blade in ipairs(self.blades) do
		blade:Activate()
	end
	self.sound:play()
end

function FanMeta:createPhantomCallbackTriggerBox(guid, halfExtends, position)
	local trigger = GetGObyGUID( guid )
	trigger.go.pc = trigger.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	local boundingShape = PhysicsFactory:createBox(halfExtends)
	local phantomCallbackShape = PhysicsFactory:createPhantomCallbackShape(halfExtends)
	cinfo.shape = PhysicsFactory:createBoundingVolumeShape(boundingShape, phantomCallbackShape)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	cinfo.collisionFilterInfo = 1
	trigger.go.pc.rb = trigger.go.pc:createRigidBody(cinfo)
	trigger.go.phantomCallback = phantomCallbackShape

	return trigger
end

function FanMeta.init( guid )
	-- body
end

function FanMeta.destroy( ... )
	-- body
end