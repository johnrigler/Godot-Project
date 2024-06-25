extends Area2D

signal got_hit

@export var speed = 400


# Preload the Beam script
const Beam = preload("res://beam.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Beam:
		got_hit.emit()
		queue_free()
