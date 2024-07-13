extends Area2D

signal got_hit

@export var speed = 90

# Preload the Beam script
const Beam = preload("res://scripts/beam.gd")

# Preload the Destruction Animation Scene
const DestructionScene = preload("res://destruction.tscn")

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
		play_destruction_animation()
		queue_free()

# Function to handle playing the destruction animation
func play_destruction_animation():
	# Instantiate the destruction animation scene
	var destruction_instance = DestructionScene.instantiate() as AnimatedSprite2D
	# Set the position to the note's position
	destruction_instance.position = position
	# Add the instance to the scene tree
	get_tree().root.add_child(destruction_instance)
	# Play the destruction animation
	destruction_instance.play("destruction")  # Ensure the animation is named "destruction" in the SpriteFrames
	# Connect the animation finished signal to queue_free the instance
	destruction_instance.connect("animation_finished", Callable(destruction_instance, "queue_free"))
