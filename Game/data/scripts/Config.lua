Config = {
	camera = {
		distance = 5.0, -- initial distance of camera
		distanceDelta = 3, -- delta of distance change
		distanceMin = 2.0,
		distanceMax = 3000.0,
		hightFactor = 0.5, -- 0..1 factor for hight of camera
		initLook = Vec2(0.0, 20.0),
		rotationSpeedFactor = 50,
		rotationSpeedFactorGamePad = 200,
		--zoomfactorgamepad = 1.65
		zoomfactorgamepad = 5.65
	},

	player = {
		maxLinearVelocity = 300.0,
		maxAngularVelocity = 100.0,
		spawnPosition = Vec3(0.0, 0.0, 3.0),
		torqueMulScalar = 2000,
		lastTransformator = Vec3(0.0,0.0,3.0)
	},

	materials = {
		sphere = {
			wood = {
				mass = 200.0,
				friction = 20.0,
				angularDamping = 4.0,
				linearDamping = 0.0,
				restitution = 0.0,
				radius = 0.5
			},
			stone = {
				mass = 1370.0,
				friction = 30.0,
				angularDamping = 0.3,
				linearDamping = 0.0,
				restitution = 0.0,
				radius = 0.5
			},
			paper = {
				mass = 30.09,
				friction = 30.0,
				angularDamping = 10.0,
				linearDamping = 3.0,
				restitution = 0.0,
				radius = 0.5
			}
		},
		track = {
			wood = {
				friction = 20.0,
				restitution = 0.75,
			},
			ice = {
				friction = 0.01, 
				restitution = 0.0
			}
		}

		
	},

	keys = {
		keyboard = {
			forward = Key.W,
			backward = Key.S,
			left = Key.A,
			right = Key.D,
			pause = Key.P,
			restart = Key.F3,
			zoomout = Key.Oem_Minus,
			zoomin = Key.Oem_Plus,
			lastTransformator = Key.Back
		},
		gamepad = {
			restart = Button.Back,
			pause = Button.Start,
			lastTransformator = Button.LeftShoulder
		}
	},

	world = {
		gravity = Vec3(0,0,-9.81), 
		worldSize = 4000
	},
	
	fans = {
		forces = {
			woodonly = Vec3(0.0,0.0,3123.0),
			stoneonly =  Vec3(4123.0,0.0,0.0),
			paperonly = Vec3(0.0,0.0,513.0)
		},
		
		fan1 = {
		position = Vec3(-170,-70,-30),
		size = Vec3(20,5,5),
		name = "fan1",
		active = true	
		},
		fan2 = {
		position = Vec3(-185,-150,-25),
		size = Vec3(5,5,7),
		name = "fan2",
		--active = false
		active = true
		},
		fan3 = {
		position = Vec3(51,-150,-13),
		size = Vec3(27.5,5,20),
		name = "fan3",
		--active = false
		active = true	
		},
		
	},
	
	transformators = {
		transformatorsize = Vec3(0.7,0.7,0.7),
		transformator1 = {
			name = "transformator1",
			position = Vec3(-69.9,-77.2,1),
			transformTo = "playerInstanceStone"		
		},
		transformator2 = {
			name = "transformator2",
			position = Vec3(-177.3,-135,-30),
			transformTo = "playerInstancePaper"		
		},
		transformator3 = {
			name = "transformator3",
				position = Vec3(22.3,-163,0.8),
				transformTo = "playerInstance"		
		},
		transformator4 = {
			name = "transformator4",
				position = Vec3(12,-118,0.8),
				transformTo = "playerInstanceStone"		
		},
	},	
	triggers = {
		triggersize = Vec3(0.7,0.7,0.7),
		trigger1 = {
			position = Vec3(0,0,0),
			name = "trigger1"
		},
		trigger2 = {
			position = Vec3(0,0,0),
			name = "trigger2"
		},
		endtrigger = {
			position = Vec3(100,0,-20),
			name = "endtrigger"
		}
	
	}
		
	
}




