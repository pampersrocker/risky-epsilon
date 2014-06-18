Config = {
	camera = {
		initialDistance = 50.0, -- initial distance of camera
		distanceDelta = 5.0, -- delta of distance change
		distanceMin = 35.0,
		distanceMax = 30000.0,
		hightFactor = 0.5, -- 0..1 factor for hight of camera
		initLook = Vec2(0.0, 20.0),
		rotationSpeedFactor = 0.05,
		rotationSpeedFactorGamePad = 0.2
	},

	player = {
		maxLinearVelocity = 300.0,
		maxAngularVelocity = 100.0,
		spawnPosition = Vec3(0.0, 0.0, 20.0),
		torqueMulScalar = 1000
	},

	materials = {
		wood = {
			mass = 100.0,
			friction = 10.0,
			angularDamping = 1.0,
			linearDamping = 1.0,
			restitution = 0.0
		},
		stone = {
			mass = 3000.0,
			friction = 100.0,
			angularDamping = 1.0,
			linearDamping = 1.0,
			restitution = 0.0
		}
	},

	keys = {
		forward = Key.W,
		backward = Key.S,
		left = Key.A,
		right = Key.D,
		pause = Key.P
	},

	world = {
		gravity = Vec3(0,0,-9.81)
	}

}




