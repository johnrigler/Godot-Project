extends Node2D

@export var note_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
# note spawn when timer ends
func _on_note_timer_timeout():
	var note = note_scene.instantiate()
	
	var note_spawn_location = $NoteSpawner
	
	note.position = note_spawn_location.position
	
	var direction = PI / 2
	
	var velocity = Vector2(200.0, 0.0)
	note.linear_velocity = velocity.rotated(direction)
	
	add_child(note)

func _on_piano_hit():
	$Label.text = "something hit the piano"
	$LabelTimer.start()

func _on_LabelTimer_timeout():
	$Label.text = "(waiting)"
