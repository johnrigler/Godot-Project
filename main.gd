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

func spawn_note():
	pass

# note spawn when timer ends
func _on_note_timer_timeout():
	var note_i = randi_range(48, 72)
	print("Note Index: ", (note_i))
	var note = note_scene.instantiate()
	var note_spawn_location = $Piano.get_key(note_i).global_position
	# this needs to be the height of the viewport
	note_spawn_location.y -= 720
	note_spawn_location.x += get_key_rect_x_offset(note_i) + (get_key_width(note_i) / 2)
	note.position = note_spawn_location
	var velocity = Vector2(150.0, 0.0)
	var direction = PI / 2
	note.linear_velocity = velocity.rotated(direction)
	add_child(note)

# get key width for offsets
func get_key_width(key):
	print($Piano.get_key(key).size[0])
	return $Piano.get_key(key).size[0]

# get key x_offset
func get_key_rect_x_offset(key):
	print($Piano.get_key(key).key.position[0])
	return $Piano.get_key(key).key.position[0]

func _on_piano_hit():
	$Label.text = "piano got hit"
	$LabelTimer.start()

func _on_LabelTimer_timeout():
	$Label.text = "(waiting)"


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
	Autoscript.score += 1
