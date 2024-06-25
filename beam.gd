extends Node2D

signal beam_collided

@export var speed = 1400 # Speed of beam
@export var lifespan = 6.0  # Lifespan in seconds


# Preload the FallingNote script
const FallingNote = preload("res://fallingNote.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_area_entered"))
	var timer = Timer.new()
	timer.wait_time = lifespan
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
	if position.y < 0:
		#queue_free()
		pass

func _on_area_entered(area):
	if area is FallingNote:
		emit_signal("beam_collided", area)
		queue_free()
