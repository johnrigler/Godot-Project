class_name Level extends Node2D

@export var note_scene: PackedScene
@export var beam_scene: PackedScene

@onready var level_track: String
@onready var level_name: String
@onready var level_color: String

signal level_end


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setup(new_name, new_track, new_color):
	_set_level_name(new_name)
	_set_level_track(new_track)
	_set_level_bg_color(new_color)


func _set_level_name(new_name : String) -> bool:
	if new_name is String:
		level_name = new_name
		return true
	printerr("TypeError: new_name %s is not type String" %new_name)
	return false
	
	
func _set_level_track(new_track: String) -> bool:
	if new_track is String:
		level_track = new_track
		$MidiPlayer.set_file(level_track)
		return true
	printerr("TypeError: new_track %s is not type String" %new_track)
	return false


func _set_level_bg_color(new_color : String) -> bool:
	if new_color is String:
		level_color = new_color
		$Background.color = level_color
		return true
	printerr("TypeError: new_color %s is not type String" %new_color)
	return false


func start_track():
	print("entering level.start_track")
	print("Level track: %s" %$MidiPlayer.file)
	print("level color: %s" %$Background.color)
	$MidiPlayer.play()


func _get_note_spawnpoint_position():
	return $NoteSpawnpoint.global_position
	
	
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
	var velocity = Vector2(150.0, 0.0)
	var direction = PI / 2
	note.linear_velocity = velocity.rotated(direction)
	add_child(note)
	
	
#  This function is for beam spawn
func spawn_beam(pos, h_offset):
	var beam = beam_scene.instantiate()
	beam.position = pos
	beam.position.x += h_offset
	beam.position.y -= 10
	add_child(beam)
	beam.connect("beam_collided", Callable(self, "_on_beam_collided"))


# for destroying notes
func _on_beam_collided(note):
	note.queue_free()
	$ScoreLabel.increase_score()


func _get_score():
	return $ScoreLabel.get_score()


func _on_midi_player_finished():
	level_end.emit(level_name, _get_score())


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

