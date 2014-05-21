local function extractParentStateMachine(cinfo)
	local parent = cinfo.parent
	cinfo.parent = nil
	if type(parent) == "string" then
		return Game:getStateMachineFactory():get(parent)
	end
	return parent
end

local function checkName(cinfo)
	assert(cinfo.name:find("/") == nil, "Your state name may not contain forward slashes '/'! name = " .. cinfo.name)
end

local function printInvalidKeys(invalidKeys)
	local message = "Detected invalid keys in state cinfo:"
	for _, invalidKey in ipairs(invalidKeys) do
		message = message ..  "\n\t" .. invalidKey
	end
	logWarning(message)
end

-- used by the state and state machine creator function
local function setAllEventListeners(instance, cinfo)
	-- if no listeners are specified, return
	if not cinfo.eventListeners then return end

	local event = nil
	local eventNames = {
		{ name = "enter", getter = "getEnterEvent" },
		{ name = "leave", getter = "getLeaveEvent" },
		{ name = "update", getter = "getUpdateEvent" },
	}

	for _, eventName in ipairs(eventNames) do
		local listeners = cinfo.eventListeners[eventName.name]
		if listeners then
			event = instance[eventName.getter](instance)
			for _, listener in ipairs(listeners) do
				assert(listener, "The listener must not be nil!")
				assert(type(listener) == "function", "A listener must be a function!")
				event:registerListener(listener)
			end
		end
	end
end

-- used by the state machine creator function
local function createAllStates(instance, cinfo)
	-- if there are no states, return
	if not cinfo.states then
		logWarning("No inner states in the state machine")
		return
	end

	for _, stateCInfo in ipairs(cinfo.states) do
		-- Creates the state instance add it to the state machine
		if stateCInfo.parent ~= nil then
			logWarning("Inner states should not have a parent set!")
		end
		stateCInfo.parent = instance
		State(stateCInfo)
	end
end

State = {}
setmetatable(State, State)
function State:__call(cinfo)
	local invalidKeys = checkTableKeys(cinfo, { "name",
												"parent",
												"eventListeners", })
	checkName(cinfo)

	if not isEmpty(invalidKeys) then
		printInvalidKeys(invalidKeys)
	end

	assert(cinfo.parent, "A State MUST have a parent state machine!")
	local parent = extractParentStateMachine(cinfo)
	local instance = parent:createState(cinfo.name)
	instance.__type = "state"

	setAllEventListeners(instance, cinfo)

	return instance
end

-- state machine creation helper
StateMachine = {}
setmetatable(StateMachine, StateMachine)
function StateMachine:__call(cinfo)
	local invalidKeys = checkTableKeys(cinfo, { "name",
												"parent",
												"eventListeners",
												"states",
												"transitions", })
	checkName(cinfo)

	if not isEmpty(invalidKeys) then
		printInvalidKeys(invalidKeys)
	end

	local parent = extractParentStateMachine(cinfo)
	local instance = nil
	if parent then
		instance = parent:createStateMachine(cinfo.name)
	else
		instance = Game:getStateMachineFactory():create(cinfo.name)
	end
	instance.__type = "stateMachine"

	setAllEventListeners(instance, cinfo)
	createAllStates(instance, cinfo)

	-- create transitions
	local transitions = cinfo.transitions
	transitions.parent = instance
	StateTransitions(transitions)

	return instance
end

-- state transition creation helper
StateTransitions = {}
setmetatable(StateTransitions, StateTransitions)
function StateTransitions:__call(cinfo)
	assert(cinfo.parent, "StateTransitions MUST have a parent")
	local parent = extractParentStateMachine(cinfo)

	if not isPureArray(cinfo) then
		logWarning("The transition cinfo is not a pure array! It should not contain any explicit keys.")
	end

	for _,transition in ipairs(cinfo) do
		-- If there is no condition, make one that always returns true
		local condition = transition.condition or function() return true end
		parent:addTransition(transition.from,
							   transition.to,
							   condition)
	end
end
