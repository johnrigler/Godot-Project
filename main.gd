extends Node2D

@export var note_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#starto()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	
#func starto():
	#await get_tree().create_timer(1.0).timeout
	#for k in $Piano.piano_key_dict.keys():
		#await _on_note_timer_timeout(k)


# note spawn when timer ends
func _on_note_timer_timeout():
	var note = note_scene.instantiate()
	#var note_spawn_location = $Node2D/Piano/piano_key_dict[key].NoteSpawner
	var note_spawn_location = $NoteSpawnerBKUP
	#print(note_spawn_location)
	var velocity = Vector2(200.0, 0.0)
	var direction = PI / 2
	note.position = note_spawn_location.position
	note.linear_velocity = velocity.rotated(direction)
	add_child(note)
	

func _on_piano_hit():
	$Label.text = "piano got hit"
	$LabelTimer.start()

func _on_LabelTimer_timeout():
	$Label.text = "(waiting)"

