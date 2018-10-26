extends Spatial

onready var animation : AnimationPlayer = $AnimationPlayer

func _ready():
	animation.play("expl")
	animation.connect("animation_finished", self, "on_animation_end")

func on_animation_end(a):
	queue_free()

func _on_Area_body_entered(body):
	if body.has_method("explosion_action"):
		body.explosion_action(global_transform.origin)
