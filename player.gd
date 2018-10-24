extends KinematicBody

const GRAVITY = -24

const MAX_SPEED = 20
const JUMP_SPEED = 10
const ACCEL = 4.5
const ACCEL_BACKWARD = 4.5
const MAX_SLOPE_ANGLE = deg2rad(40)

const MOUSE_SENSITIVITY = 0.5

const WEAPONS = [
	preload("res://testweapon.tscn")
]

var velocity = Vector3()

var direction = Vector3()
var recoil_direction = Vector3()
var is_jumping : bool = false

var current_weapon = -1
var weapon = null

onready var rotation_point = $rotation
onready var weapon_holder : Spatial = $rotation/weapon_holder
onready var weapon_change_timer : Timer = $weapon_change_timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	direction = Vector3()
	recoil_direction = Vector3()
	
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
	
	var target = direction + recoil_direction * delta
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
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == BUTTON_WHEEL_UP:
		change_weapon()

func change_weapon():
	if weapon_change_timer.time_left > 0:
		return
	weapon_change_timer.start()
	
	current_weapon += 1
	if current_weapon == len(WEAPONS):
		current_weapon = -1
		weapon_holder.remove_child(weapon_holder.get_child(0))
		weapon = null
	else:
		weapon = WEAPONS[current_weapon].instance()
		weapon.set_level(get_parent())
		weapon_holder.add_child(weapon)
	
func shoot():
	if weapon and weapon.can_shoot():
		weapon.shoot()
		
		# recoil
		var cam_xform = rotation_point.get_global_transform()
		recoil_direction += cam_xform.basis.z.normalized() * 100
		
		rotation_point.rotate_x(deg2rad(1))