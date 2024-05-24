extends RigidBody2D

signal got_hit

@export var speed = 400

# Preload the Beam script
const Beam = preload("res://beam.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body is PianoKey:
		emit_signal("play_me", body)
		queue_free()
	elif body is Beam:
		queue_free()
