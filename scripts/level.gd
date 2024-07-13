class_name Level extends Node2D

@export var note_scene: PackedScene
@export var beam_scene: PackedScene
@export var level_name: String
#@export var level_difficulty: String	# maybe implement? for sorting purposes in level select

signal level_end


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelNameLabel.text = level_name
	#_start_track() # TODO: implement a pre-level menu with start button?


func get_level_name():
	return level_name


#func get_level_difficulty():
	#return level_difficulty


func _start_track():
	#print("entering level.start_track")
	#print("Level track: %s" %$MidiPlayer.file)
	#print("level color: %s" %$Background.color)
	$StartDelayTimer.start()
	#$MidiPlayer.play() # re-implement this if getting rid of StartDelayTimer


func _on_start_delay_timer_timeout():
	$MidiPlayer.play()


# get key width for offsets
func _get_key_width(key):
	# debug print
	#print($Piano.get_key(key).size[0])
	return $Piano.get_key(key).size[0]


# get key x_offset because some keys are off by a few pixels from the left
func _get_key_rect_x_offset(key):
	# need rect "key" position to determine initial offset from left
	# debug print
	#print($Piano.get_key(key).key.position[0])
	return $Piano.get_key(key).key.position[0]


func spawn_note(in_note):
	var note = note_scene.instantiate()
	# this ensures notes spawn at the top of the screen
	var note_spawn_location = $NoteSpawnpoint.global_position
	# this ensures spawn in line with the appropriate key
	note_spawn_location[0] += $Piano.get_key(in_note).global_position[0] + _get_key_rect_x_offset(in_note) + (_get_key_width(in_note) / 2)
	note.position = note_spawn_location
	#var velocity = Vector2(150.0, 0.0)
	#var direction = PI / 2
	#note.linear_velocity = velocity.rotated(direction)
	add_child(note)


func _input(event):
	if not (event is InputEventMIDI):
		return
	elif event.message == 8:
		return
	else:
		spawn_beam(event.pitch)


#  This function is for beam spawning
func spawn_beam(input_note):
	var beam = beam_scene.instantiate()
	beam.position.x = $Piano.get_key(input_note).global_position[0] + _get_key_rect_x_offset(input_note) + (_get_key_width(input_note) / 2)
	beam.position.y = $Piano.get_key(input_note).global_position[1] - 10
	add_child(beam)
	beam.connect("beam_collided", Callable(self, "_on_beam_collided"))


# for destroying notes
func _on_beam_collided(note):
	note.queue_free()
	$ScoreLabel.increase_score()


func _get_score():
	return $ScoreLabel.get_score()


# ends level when midi stops AND there are no fallingNotes in the tree
func _on_midi_player_finished():
	var still_playing : bool = true
	while still_playing:
		still_playing = has_notes()
	level_end.emit(level_name, _get_score())


func has_notes():
	return has_node("fallingNote")


func switch_level(new_level):
	get_tree().change_scene_to_file(new_level)


# listener for note spawning
####################
# this listener can detect any of midi event types found in addons/midi/SMF.gd
# number codes for events that might be important:
# 144 = NOTE_ON		/ useful for spawning a note / this comes with .note attr
# 128 = NOTE_OFF	/ useful for controlling the "length" of a note on screen this comes with .note attr
####################
func _on_midi_player_midi_event(_channel, event):
	if event.type == 144:
		# debug print
		#print(event.note)
		if event.note in range(48, 73):
			spawn_note(event.note)

