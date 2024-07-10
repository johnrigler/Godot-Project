class_name Level extends Node2D

@export var note_scene: PackedScene
@export var beam_scene: PackedScene

@onready var level_track: String
@onready var level_name: String
@onready var background_instance: Node = null

signal level_end

# Preload the single background scene for testing
const BACKGROUND_SCENE = preload("res://mountain_background.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if background_instance:
		add_child(background_instance)

func setup(new_name, new_track):
	_set_level_name(new_name)
	_set_level_track(new_track)
	_set_background()

func _set_level_name(new_name: String) -> bool:
	if new_name is String:
		level_name = new_name
		return true
	printerr("TypeError: new_name %s is not type String" % new_name)
	return false
	
func _set_level_track(new_track: String) -> bool:
	if new_track is String:
		level_track = new_track
		$MidiPlayer.set_file(level_track)
		return true
	printerr("TypeError: new_track %s is not type String" % new_track)
	return false

func _set_background() -> bool:
	background_instance = BACKGROUND_SCENE.instantiate()
	if background_instance:
		add_child(background_instance)
		return true
	printerr("Failed to load background from preloaded scene")
	return false

func start_track():
	print("entering level.start_track")
	print("Level track: %s" % $MidiPlayer.file)
	$MidiPlayer.play()

# get key width for offsets
func _get_key_width(key):
	return $Piano.get_key(key).size[0]

# get key x_offset because some keys are off by a few pixels from the left
func _get_key_rect_x_offset(key):
	return $Piano.get_key(key).key.position[0]

func spawn_note(in_note):
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

func _on_midi_player_finished():
	level_end.emit(level_name, _get_score())

func _on_midi_player_midi_event(_channel, event):
	if event.type == 144:
		if event.note in range(48, 73):
			spawn_note(event.note)
