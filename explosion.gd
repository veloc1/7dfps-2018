extends Spatial

onready var animation : AnimationPlayer = $AnimationPlayer

func _ready():
	animation.play("expl")
	animation.connect("animation_finished", self, "on_animation_end")

func on_animation_end(a):
	queue_free()