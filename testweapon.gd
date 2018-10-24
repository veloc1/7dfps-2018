extends Spatial

const DECAL = preload("res://decal.tscn")

onready var shoot_timer = $Timer
onready var animation = $AnimationPlayer
onready var raycast = $RayCast

var level

func can_shoot():
	return shoot_timer.time_left == 0

func shoot():
	if can_shoot():
		animation.play("shoot")
		
		if raycast.is_colliding():
			if raycast.get_collider() is StaticBody:
				var decal = DECAL.instance()
				decal.translate_object_local(raycast.get_collision_point())
				
				var normal = raycast.get_collision_normal()
				decal.look_at_from_position(raycast.get_collision_point(), raycast.get_collision_point() + normal, Vector3(0, 0, 1))
				
				level.add_child(decal)
			
		shoot_timer.start()

func set_level(level):
	self.level = level