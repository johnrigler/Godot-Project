extends Node2D

@export var note_scene: PackedScene
@export var beam_scene: PackedScene
@onready var score = $score
@onready var level_track: String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_note_spawnpoint_position():
	return $NoteSpawnpoint.global_position
	
	
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
	
	
#  This function is for beam spawn
func spawn_beam(global_position, h_offset):
	var beam = beam_scene.instantiate()
	beam.position = global_position
	beam.position.x += h_offset
	beam.position.y -= 10
	add_child(beam)
	beam.connect("beam_collided", Callable(self, "_on_beam_collided"))


# for destroying notes
func _on_beam_collided(note):
	note.queue_free()
	$ScoreLabel.increase_score()
