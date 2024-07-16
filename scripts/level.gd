class_name Level extends Node2D

@export var note_scene: PackedScene
@export var beam_scene: PackedScene
@export var level_name: String
#@export var level_difficulty: String	# maybe implement? for sorting purposes in level select
@onready var keyboard_audio_player: AudioStreamPlayer = $ADSR

signal level_end

# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelNameLabel.text = level_name
	_start_track() # TODO: implement a pre-level menu with start button?


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

# Reset audio settings for consistent behavior
func _reset_audio_settings():
	if keyboard_audio_player:
		keyboard_audio_player.volume_db = -80.0  # Set to desired default volume level
		keyboard_audio_player.stream_paused = false
		keyboard_audio_player.stop()  # Ensure any ongoing audio is stopped
		keyboard_audio_player.stream = null  # Reset the audio stream

# get key width for offsets
func _get_key_width(key):
	return $Piano.get_key(key).size[0]

# get key x_offset because some keys are off by a few pixels from the left
func _get_key_rect_x_offset(key):
	return $Piano.get_key(key).key.position[0]

func spawn_note (in_note):
	var note = note_scene.instantiate()
	var note_spawn_location = $NoteSpawnpoint.global_position
	note_spawn_location.x += $Piano.get_key(in_note).global_position.x + _get_key_rect_x_offset(in_note) + (_get_key_width(in_note) / 2)
	note.position = note_spawn_location
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
	beam.position.x = $Piano.get_key(input_note).global_position.x + _get_key_rect_x_offset(input_note) + (_get_key_width(input_note) / 2)
	beam.position.y = $Piano.get_key(input_note).global_position.y - 10
	add_child(beam)
	beam.connect("beam_collided", Callable(self, "_on_beam_collided"))

func _on_beam_collided(note):
	note.queue_free()
	$ScoreLabel.increase_score()

func _get_score():
	return $ScoreLabel.get_score()

func _has_notes():
	return get_tree().has_group("notes")

func _on_end_level_timer_timeout():
	if get_tree().has_group("notes"):
		$EndLevelTimer.start()
	else:
		level_end.emit(level_name, _get_score())

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
		if event.note in range(48, 73):
			spawn_note(event.note)
