local function doLog(mode, args)
	local message = ""
	for _,arg in ipairs(args) do
		message = message .. arg
	end
	print(message)
end

function logMessage(...)
	doLog(nil, {...})
end

function logWarning(...)
	doLog(nil, {...})
end

function logError(...)
	doLog(nil, {...})
end

function prettyPrint(...)
	local args = { ... }
	for _,arg in ipairs(args) do
		if type(arg) == "table" then
			for k,v in pairs(arg) do
				print(k,v)
			end
		else
			print(arg)
		end
	end
end
