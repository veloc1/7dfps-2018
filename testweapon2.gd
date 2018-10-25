extends Spatial

const BOMB = preload("res://bomb.tscn")

onready var shoot_timer = $Timer
onready var animation = $AnimationPlayer
onready var bomb_spawner = $bomb_spawner
onready var bomb_target = $bomb_target

var level

func can_shoot():
	return shoot_timer.time_left == 0

func shoot():
	if can_shoot():
		animation.play("shoot")
		var bomb : RigidBody = BOMB.instance()
		bomb.set_level(level)
		level.add_child(bomb)
		
		bomb.translate_object_local(bomb_spawner.global_transform.origin)
		bomb.look_at(bomb_target.global_transform.origin, Vector3.UP)
		bomb.apply_impulse(Vector3(), bomb.global_transform.basis.z * 30)
		
		#print(global_transform.basis)
		#bomb.global_transform.basis = Basis(Quat(global_transform.basis))
		#bomb.look_at(global_transform.origin + Vector3(0, 0, 10), Vector3(0, 1, 0))
		#bomb.global_transform.origin = global_transform.origin * 1
		
		#bomb.look_at(global_transform.origin + Vector3(0, 0, 10), Vector3(0, 1, 0))
		#bomb.rotation = 
		#bomb.look_at_from_position(global_transform.scaled(Vector3(0, 0, 10)).origin, global_transform.origin, )
		
		
		
		shoot_timer.start()

func set_level(level):
	self.level = level