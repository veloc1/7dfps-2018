extends KinematicBody

const GRAVITY = -24

const MAX_SPEED = 20
const JUMP_SPEED = 10
const ACCEL = 4.5
const ACCEL_BACKWARD = 4.5
const MAX_SLOPE_ANGLE = deg2rad(40)

const MOUSE_SENSITIVITY = 0.5

var velocity = Vector3()

var direction = Vector3()
var is_jumping : bool = false

onready var camera : Camera = $rotation/Camera
onready var rotation_point = $rotation
onready var shoot_animation = $rotation/shoot_animation
onready var shoot_timer : Timer = $shoot_timer
onready var raycast : RayCast = $rotation/RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	direction = Vector3()
	
	var cam_xform = rotation_point.get_global_transform()
	
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x = 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	direction += -cam_xform.basis.z.normalized() * input_movement_vector.y
	direction += cam_xform.basis.x.normalized() * input_movement_vector.x
	
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			is_jumping = true
	
	if Input.is_mouse_button_pressed(1):
		shoot()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	direction.y = 0
	direction = direction.normalized()
	
	if is_jumping:
		velocity.y += JUMP_SPEED
		is_jumping = false
	else:
		velocity.y += GRAVITY * delta
	
	var hvel = velocity
	hvel.y = 0
	
	var target = direction
	target *= MAX_SPEED
	
	var accel
	if direction.dot(hvel) > 0:
	    accel = ACCEL
	else:
	    accel = ACCEL_BACKWARD
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	velocity = move_and_slide(velocity, Vector3(0,1,0), false, 4, MAX_SLOPE_ANGLE)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_point.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_point.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_point.rotation_degrees = camera_rot

func shoot():
	if shoot_timer.time_left == 0:
		shoot_animation.play("shoot")
		
		if raycast.is_colliding():
			print(raycast.get_collision_point())
			
		shoot_timer.start()