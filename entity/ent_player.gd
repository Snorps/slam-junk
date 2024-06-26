extends CharacterBody3D

@onready var body = $Body
@onready var head = $Body/Head
@onready var camera = $Body/Head/CameraMarker3D/Camera3D
@onready var camera_target = $Body/Head/CameraMarker3D
@onready var head_position: Vector3 = head.position
@onready var hands = $Body/Head/Hands
@onready var pointGet = $Body/Head/CameraMarker3D/Camera3D/CanvasLayer/PointGet

@export_file var default_reticle

var mouse_sensitivity: float = 0.1

var ACCELERATION_DEFAULT: float = 7.0
var ACCELERATION_AIR: float = 1.0
var SPEED_DEFAULT: float = 7.0
var SPEED_ON_STAIRS: float = 5.0

var acceleration: float = ACCELERATION_DEFAULT
var speed: float = SPEED_DEFAULT

var gravity: float = 9.8
var jump: float = 5.0
var direction: Vector3 = Vector3.ZERO
var main_velocity: Vector3 = Vector3.ZERO
var gravity_direction: Vector3 = Vector3.ZERO
var movement: Vector3 = Vector3.ZERO

const STAIRS_FEELING_COEFFICIENT: float = 2.5
const WALL_MARGIN: float = 0.001
const STEP_DOWN_MARGIN: float = 0.01
const STEP_HEIGHT_DEFAULT: Vector3 = Vector3(0, 0.6, 0)
const STEP_HEIGHT_IN_AIR_DEFAULT: Vector3 = Vector3(0, 0.6, 0)
const STEP_MAX_SLOPE_DEGREE: float = 40.0
const STEP_CHECK_COUNT: int = 2
const SPEED_CLAMP_AFTER_JUMP_COEFFICIENT = 0.4
const SPEED_CLAMP_SLOPE_STEP_UP_COEFFICIENT = 0.4

var step_height_main: Vector3
var step_incremental_check_height: Vector3
var is_enabled_stair_stepping_in_air: bool = true
var is_jumping: bool = false
var is_in_air: bool = false

var head_offset: Vector3 = Vector3.ZERO
var camera_target_position : Vector3 = Vector3.ZERO
var camera_lerp_coefficient: float = 1.0
var time_in_air: float = 0.0
var update_camera = false
var camera_gt_previous : Transform3D
var camera_gt_current : Transform3D

var speedlines
var speedlines1 = load("res://speedlines/Speedlines1.png")
var speedlines2 = load("res://speedlines/Speedlines2.png")
var speedlines3 = load("res://speedlines/Speedlines3.png")
var speedlines4 = load("res://speedlines/Speedlines4.png")
var speedlineCheck = false
var previousPos
var rng = RandomNumberGenerator.new()

var RETICLE : Control

var jump_sounds = [
	load("res://audio/jump1.wav"),
	load("res://audio/jump2.wav"),
	load("res://audio/jump3.wav"),
]


class StepResult:
	var diff_position: Vector3 = Vector3.ZERO
	var normal: Vector3 = Vector3.ZERO
	var is_step_up: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$Body/enemyplayer1.hide()
	
	camera_target_position = camera.global_transform.origin
	camera.set_as_top_level(true)
	camera.global_transform = camera_target.global_transform
	
	camera_gt_previous = camera_target.global_transform
	camera_gt_current = camera_target.global_transform
	
	speedlines = get_tree().get_root().get_node("Body/Head/CameraMarker3D/Camera3D/CanvasLayer/Speedlines")
	pointGet.hide()
	
	
	update_fov()
	
	if default_reticle:
		change_reticle(default_reticle)
		
func change_reticle(reticle):
	if RETICLE:
		RETICLE.queue_free()
	
	RETICLE = load(reticle).instantiate()
	RETICLE.character = self
	$UserInterface.add_child(RETICLE)

func PointGet():
	pointGet.show()

func update_fov():
	$Body/Head/CameraMarker3D/Camera3D.set_fov(75 + (25 * Flags.get_upgrade("performosport").equipped))
	
func die():
	$Body/enemyplayer1.rotation.x = -90
	$Body/enemyplayer1.position.y += 0.6
	var cam = load("res://death_camera.tscn").instantiate()
	cam.global_position = global_position
	$Body/enemyplayer1.show()
	get_tree().current_scene.add_child(cam)

func update_camera_transform():
	camera_gt_previous = camera_gt_current
	camera_gt_current = camera_target.global_transform
	
func _process(delta: float) -> void:
	if update_camera:
		update_camera_transform()
		update_camera = false

	var interpolation_fraction = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)

	var camera_xform = camera_gt_previous.interpolate_with(camera_gt_current, interpolation_fraction)
	camera.global_transform = camera_xform

	var head_xform : Transform3D = head.get_global_transform()
	
	camera_target_position = lerp(camera_target_position, head_xform.origin, delta * speed * STAIRS_FEELING_COEFFICIENT * camera_lerp_coefficient)

	##sets speeline texture if user is on performo and is moving
	if not is_instance_valid(GameStateManager.player): return
	if(Flags.get_upgrade("performosport").equipped > 0 && GameStateManager.player.velocity.length() > 0.5):
		if(speedlineCheck == true):
			var random = rng.randi_range(1,Flags.get_upgrade("performosport").equipped)
			match random:
				
				2:
					#Where speedline 2 goes
					get_node("Body/Head/CameraMarker3D/Camera3D/CanvasLayer/Speedlines").texture = speedlines2
					speedlineCheck = false
				3:
					#Where speedline 3 goes
					get_node("Body/Head/CameraMarker3D/Camera3D/CanvasLayer/Speedlines").texture = speedlines3
					speedlineCheck = false
				4:
					#Where speedline 4 goes
					get_node("Body/Head/CameraMarker3D/Camera3D/CanvasLayer/Speedlines").texture = speedlines4
					speedlineCheck = false
				_:
					get_node("Body/Head/CameraMarker3D/Camera3D/CanvasLayer/Speedlines").texture = speedlines1
					speedlineCheck = false
	else:
		get_node("Body/Head/CameraMarker3D/Camera3D/CanvasLayer/Speedlines").texture = null
	previousPos = position
	if is_on_floor():
		time_in_air = 0.0
		camera_lerp_coefficient = 1.0
		camera.position.y = camera_target_position.y
	else:
		time_in_air += delta
		if time_in_air > 1.0:
			camera_lerp_coefficient += delta
			camera_lerp_coefficient = clamp(camera_lerp_coefficient, 2.0, 4.0)
		else: 
			camera_lerp_coefficient = 2.0

		camera.position.y = camera_target_position.y

func _input(event):
	if event is InputEventMouseMotion:
		body.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	elif event.is_action_pressed("interact"):
		if hands:
			hands.try_grabthrow()
	if(Input.is_key_pressed(KEY_Q)):
		Flags.purge_upgrades()
	if(Input.is_key_pressed(KEY_G)):
		Flags.add_money(2)
	if(Input.is_action_just_pressed("Fullscreen")):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func _physics_process(delta):
	update_camera = true
	var is_step: bool = false
	
	var input = Input.get_vector("left", "right", "forward", "backward")
	direction = (body.global_transform.basis * Vector3(input.x, 0, input.y)).normalized()

	if is_on_floor():
		is_jumping = false
		is_in_air = false
		acceleration = ACCELERATION_DEFAULT
		gravity_direction = Vector3.ZERO
	else:
		is_in_air = true
		acceleration = ACCELERATION_AIR
		gravity_direction += Vector3.DOWN * gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		is_in_air = false
		gravity_direction = Vector3.UP * jump
		
		$AudioPlayer.stream = jump_sounds[rng.randi_range(0, jump_sounds.size() - 1)]
		$AudioPlayer.play()

	main_velocity = main_velocity.lerp(direction * speed, acceleration * delta)

	var step_result : StepResult = StepResult.new()
	
	is_step = step_check(delta, is_jumping, step_result)
	
	if is_step:
		var is_enabled_stair_stepping: bool = true
		if step_result.is_step_up:
			if is_in_air:
				if is_enabled_stair_stepping_in_air:
					main_velocity *= SPEED_CLAMP_AFTER_JUMP_COEFFICIENT
					gravity_direction *= SPEED_CLAMP_AFTER_JUMP_COEFFICIENT
				else:
					is_enabled_stair_stepping = false
			else:
				if direction.dot(step_result.normal) > 0:
					global_transform.origin += main_velocity * delta
					main_velocity *= SPEED_CLAMP_SLOPE_STEP_UP_COEFFICIENT
					gravity_direction *= SPEED_CLAMP_SLOPE_STEP_UP_COEFFICIENT

		if is_enabled_stair_stepping:
			global_transform.origin += step_result.diff_position
			head_offset = step_result.diff_position
			speed = SPEED_ON_STAIRS
	else:
		head_offset = head_offset.lerp(Vector3.ZERO, delta * speed * STAIRS_FEELING_COEFFICIENT)
		
		if abs(head_offset.y) <= 0.01:
			speed = SPEED_DEFAULT

	movement = main_velocity + gravity_direction

	set_velocity(movement)
	set_max_slides(6)
	move_and_slide()
	
	if is_jumping:
		is_jumping = false
		is_in_air = true

func step_check(delta: float, is_jumping_: bool, step_result: StepResult):
	var is_step: bool = false
	
	step_height_main = STEP_HEIGHT_DEFAULT
	step_incremental_check_height = STEP_HEIGHT_DEFAULT / STEP_CHECK_COUNT
	
	if is_in_air and is_enabled_stair_stepping_in_air:
		step_height_main = STEP_HEIGHT_IN_AIR_DEFAULT
		step_incremental_check_height = STEP_HEIGHT_IN_AIR_DEFAULT / STEP_CHECK_COUNT
		
	if gravity_direction.y >= 0:
		for i in range(STEP_CHECK_COUNT):
			var test_motion_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
			
			var step_height: Vector3 = step_height_main - i * step_incremental_check_height
			var transform3d: Transform3D = global_transform
			var motion: Vector3 = step_height
			var test_motion_params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			var is_player_collided: bool = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)

			if is_player_collided and test_motion_result.get_collision_normal().y < 0:
				continue

			transform3d.origin += step_height
			motion = main_velocity * delta
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
			if not is_player_collided:
				transform3d.origin += motion
				motion = -step_height
				test_motion_params.from = transform3d
				test_motion_params.motion = motion
				
				is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
				
				if is_player_collided:
					if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
						is_step = true
						step_result.is_step_up = true
						step_result.diff_position = -test_motion_result.get_remainder()
						step_result.normal = test_motion_result.get_collision_normal()
						break
			else:
				var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal()
				transform3d.origin += wall_collision_normal * WALL_MARGIN
				motion = (main_velocity * delta).slide(wall_collision_normal)
				test_motion_params.from = transform3d
				test_motion_params.motion = motion
				
				is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
				
				if not is_player_collided:
					transform3d.origin += motion
					motion = -step_height
					test_motion_params.from = transform3d
					test_motion_params.motion = motion
					
					is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
					
					if is_player_collided:
						if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
							is_step = true
							step_result.is_step_up = true
							step_result.diff_position = -test_motion_result.get_remainder()
							step_result.normal = test_motion_result.get_collision_normal()
							break

	if not is_jumping_ and not is_step and is_on_floor():
		step_result.is_step_up = false
		var test_motion_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
		var transform3d: Transform3D = global_transform
		var motion: Vector3 = main_velocity * delta
		var test_motion_params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
		test_motion_params.from = transform3d
		test_motion_params.motion = motion
		test_motion_params.recovery_as_collision = true

		var is_player_collided: bool = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
		if not is_player_collided:
			transform3d.origin += motion
			motion = -step_height_main
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
			if is_player_collided and test_motion_result.get_travel().y < -STEP_DOWN_MARGIN:
				if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
					is_step = true
					step_result.diff_position = test_motion_result.get_travel()
					step_result.normal = test_motion_result.get_collision_normal()
		elif is_zero_approx(test_motion_result.get_collision_normal().y):
			var wall_collision_normal: Vector3 = test_motion_result.get_collision_normal()
			transform3d.origin += wall_collision_normal * WALL_MARGIN
			motion = (main_velocity * delta).slide(wall_collision_normal)
			test_motion_params.from = transform3d
			test_motion_params.motion = motion
			
			is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
			
			if not is_player_collided:
				transform3d.origin += motion
				motion = -step_height_main
				test_motion_params.from = transform3d
				test_motion_params.motion = motion
				
				is_player_collided = PhysicsServer3D.body_test_motion(self.get_rid(), test_motion_params, test_motion_result)
				
				if is_player_collided and test_motion_result.get_travel().y < -STEP_DOWN_MARGIN:
					if test_motion_result.get_collision_normal().angle_to(Vector3.UP) <= deg_to_rad(STEP_MAX_SLOPE_DEGREE):
						is_step = true
						step_result.diff_position = test_motion_result.get_travel()
						step_result.normal = test_motion_result.get_collision_normal()

	return is_step

func _func_godot_apply_properties(properties: Dictionary):
	#if 'targetname' in properties:
	#	targetname = properties.targetname
	if "spawn_point" in GameStateManager.map:
		var spawn_point = GameStateManager.map.spawn_point
		var delete = true
		if 'spawnname' in properties:
			if properties.spawnname == spawn_point:
				delete = false
		if delete:
			queue_free()
			return
	GameStateManager.player = self
	Flags.refresh_upgrades_effects()



func _on_speedline_timer_timeout():
	speedlineCheck = true
