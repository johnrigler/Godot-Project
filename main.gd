extends Node2D

@export var note_scene: PackedScene
@export var beam_scene: PackedScene
@onready var score = $score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#starto()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_note(_note):
	var note = note_scene.instantiate()
	var note_spawn_location = $Piano.get_key(_note).global_position
	# this needs to be the height of the viewport
	note_spawn_location[1] -= 480
	note_spawn_location[0] += get_key_rect_x_offset(_note) + (get_key_width(_note) / 2)
	note.position = note_spawn_location
	var velocity = Vector2(150.0, 0.0)
	var direction = PI / 2
	note.linear_velocity = velocity.rotated(direction)
	add_child(note)
	

# note spawn when timer ends // use this for debug now
#func _on_note_timer_timeout():
	#var note_i = randi_range(48, 72)
	## debug print
	##print("Note Index: ", (note_i))
	#var note = note_scene.instantiate()
	#var note_spawn_location = $Piano.get_key(note_i).global_position
	## this needs to be the height of the viewport
	#note_spawn_location[1] -= 720
	#note_spawn_location[0] += get_key_rect_x_offset(note_i) + (get_key_width(note_i) / 2)
	#note.position = note_spawn_location
	#var velocity = Vector2(150.0, 0.0)
	#var direction = PI / 2
	#note.linear_velocity = velocity.rotated(direction)
	#add_child(note)

# get key width for offsets
func get_key_width(key):
	# debug print
	#print($Piano.get_key(key).size[0])
	return $Piano.get_key(key).size[0]

# get key x_offset
func get_key_rect_x_offset(key):
	# need rect "key" position to determine initial offset from left
	# debug print
	#print($Piano.get_key(key).key.position[0])
	return $Piano.get_key(key).key.position[0]

func _on_piano_hit():
	$Label.text = "piano got hit"
	$LabelTimer.start()

func _on_LabelTimer_timeout():
	$Label.text = "(waiting)"


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
		spawn_note(event.note)
#  This function is for beam spawn
func spawn_beam(global_position, h_offset):
	var beam = beam_scene.instantiate()
	beam.position = global_position
	beam.position.x += h_offset
	beam.position.y -= 10
	add_child(beam)
	beam.connect("beam_collided", Callable(self, "_on_beam_collided"))

func _on_beam_collided(note):
	note.queue_free()
	$ScoreLabel.increase_score()


func _on_score_label_score_changed():
	pass # Replace with function body.
