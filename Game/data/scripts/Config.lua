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
		linearVelocityScalar = 100,
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
				friction = 20.0,
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
			lastTransformator = Key.F4
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
			stoneonly =  Vec3(5000.0,0.0,0.0),
			paperonly = Vec3(0.0,0.0,650.0)
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
		active = false
		--active = true
		},
		fan3 = {
		position = Vec3(51,-150,-13),
		size = Vec3(27.5,5,20),
		name = "fan3",
		active = false
		--active = true
		},

	},

	fanblades = {
		fanblade1 = {
			position = Vec3(-191,-70,-26),
			rotationaxis = Vec3(-1, 0, 0),
			baserotation = Quaternion(Vec3(0,0,0), 0),
			name = "fanblade1",
			active = true
		},
		fanblade2 = {
			position = Vec3(-185,-150,-32.1),
			rotationaxis = Vec3(-1, 0, 0),
			baserotation = Quaternion(Vec3(0,1,0), 90),
			name = "fanblade2",
			active = false
		},
		fanblade3 = {
			position = Vec3(27,-150,-32.1),
			rotationaxis = Vec3(-1, 0, 0),
			baserotation = Quaternion(Vec3(0,1,0), 90),
			name = "fanblade3",
			active = false
		},
		fanblade4 = {
			position = Vec3(42.6,-150,-32.1),
			rotationaxis = Vec3(-1, 0, 0),
			baserotation = Quaternion(Vec3(0,1,0), 90),
			name = "fanblade4",
			active = false
		},
		fanblade5 = {
			position = Vec3(57.6,-150,-32.1),
			rotationaxis = Vec3(-1, 0, 0),
			baserotation = Quaternion(Vec3(0,1,0), 90),
			name = "fanblade5",
			active = false
		},
		fanblade6 = {
			position = Vec3(72.7,-150,-32.1),
			rotationaxis = Vec3(-1, 0, 0),
			baserotation = Quaternion(Vec3(0,1,0), 90),
			name = "fanblade6",
			active = false
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
			position = Vec3(-312.4,-105,-30),
			name = "trigger1"
		},
		trigger2 = {
			position = Vec3(-17.2,-202.5,0.8),
			name = "trigger2"
		},
		endtrigger = {
			position = Vec3(100,0,-20),
			name = "endtrigger"
		}

	},
	triggerplates =
	{
		trigger1 = Vec3(-312.5,-105,-31.2),
		trigger2 = Vec3(-17.6,-202.5,-0.2),
	},
	fractures =
	{
		fracture01 =
		{
			name = "fracture01",
			collFile = "data/collision/fracture_01.hkx",
			model = "data/models/Sphere/Sphere_Fracture_01.thModel",
			mass = 5,
		},
		fracture02 =
		{
			name = "fracture02",
			collFile = "data/collision/fracture_02.hkx",
			model = "data/models/Sphere/Sphere_Fracture_02.thModel",
			mass = 5,
		},
		fracture03 =
		{
			name = "fracture03",
			collFile = "data/collision/fracture_03.hkx",
			model = "data/models/Sphere/Sphere_Fracture_03.thModel",
			mass = 5,
		},
		fracture04 =
		{
			name = "fracture04",
			collFile = "data/collision/fracture_04.hkx",
			model = "data/models/Sphere/Sphere_Fracture_04.thModel",
			mass = 5,
		},
		fracture05 =
		{
			name = "fracture05",
			collFile = "data/collision/fracture_05.hkx",
			model = "data/models/Sphere/Sphere_Fracture_05.thModel",
			mass = 5,
		},
		fracture06 =
		{
			name = "fracture06",
			collFile = "data/collision/fracture_06.hkx",
			model = "data/models/Sphere/Sphere_Fracture_06.thModel",
			mass = 5,
		},
		fracture07 =
		{
			name = "fracture07",
			collFile = "data/collision/fracture_07.hkx",
			model = "data/models/Sphere/Sphere_Fracture_07.thModel",
			mass = 5,
		},
		fracture08 =
		{
			name = "fracture08",
			collFile = "data/collision/fracture_08.hkx",
			model = "data/models/Sphere/Sphere_Fracture_08.thModel",
			mass = 5,
		},
		fracture09 =
		{
			name = "fracture09",
			collFile = "data/collision/fracture_09.hkx",
			model = "data/models/Sphere/Sphere_Fracture_09.thModel",
			mass = 5,
		},
		fracture10 =
		{
			name = "fracture10",
			collFile = "data/collision/fracture_10.hkx",
			model = "data/models/Sphere/Sphere_Fracture_10.thModel",
			mass = 5,
		},
		fracture11 =
		{
			name = "fracture11",
			collFile = "data/collision/fracture_11.hkx",
			model = "data/models/Sphere/Sphere_Fracture_11.thModel",
			mass = 5,
		},
		fracture12 =
		{
			name = "fracture12",
			collFile = "data/collision/fracture_12.hkx",
			model = "data/models/Sphere/Sphere_Fracture_01.thModel",
			mass = 5,
		},
		fracture13 =
		{
			name = "fracture13",
			collFile = "data/collision/fracture_13.hkx",
			model = "data/models/Sphere/Sphere_Fracture_13.thModel",
			mass = 5,
		},
		fracture01 =
		{
			name = "fracture01",
			collFile = "data/collision/fracture_01.hkx",
			model = "data/models/Sphere/Sphere_Fracture_01.thModel",
			mass = 5,
		},
	}


}




