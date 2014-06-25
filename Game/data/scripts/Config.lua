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
		zoomfactorgamepad = 1.65
	},

	player = {
		maxLinearVelocity = 300.0,
		maxAngularVelocity = 100.0,
		spawnPosition = Vec3(0.0, 0.0, 5.0),
		torqueMulScalar = 2
	},

	materials = {
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

	keys = {
		keyboard = {
			forward = Key.W,
			backward = Key.S,
			left = Key.A,
			right = Key.D,
			pause = Key.P,
			restart = Key.R,
			zoomout = Key.Oem_Minus,
			zoomin = Key.Oem_Plus
		},
		gamepad = {
			restart = Button.Back,
			pause = Button.Start,
			zoomout = Button.LeftShoulder,
			zoomin = Button.RightShoulder
		}
	},

	world = {
		gravity = Vec3(0,0,-9.81)
	}

}




