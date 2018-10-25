extends RigidBody

const EXPLOSION = preload("res://explosion.tscn")

var level: Spatial

func _physics_process(delta):
	var is_colliding = len(get_colliding_bodies()) > 0
	if is_colliding:
		var expl = EXPLOSION.instance()
		level.add_child(expl)
		
		expl.translate_object_local(global_transform.origin)
		
		queue_free()

func set_level(level):
	self.level = level

