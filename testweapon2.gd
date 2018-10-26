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
		
		shoot_timer.start()

func set_level(level):
	self.level = level