extends Control

onready var health : Label = $MarginContainer/VBoxContainer/health

func _ready():
	get_tree().connect("screen_resized", self, "resize")
	resize()

func _on_Player_health_changed(current, total):
	health.text = "Health: " + str(current) + " / " + str(total)

func resize():
	var s = OS.get_window_size()
	rect_position = Vector2(0, s.y - rect_min_size.y)