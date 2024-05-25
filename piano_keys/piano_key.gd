class_name PianoKey
extends Control

var pitch_scale: float

@onready var key: ColorRect = $Key
@onready var start_color: Color = key.color
@onready var color_timer: Timer = $ColorTimer
@export var beam_scene: PackedScene

func _ready():
	key.connect("gui_input", Callable(self, "_on_gui_input"))


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		activate(0)


func setup(pitch_index: int):
	name = "PianoKey" + str(pitch_index)
	var exponent := (pitch_index - 69.0) / 12.0
	pitch_scale = pow(2, exponent)


func activate(beam_offset):
	key.color = (Color.YELLOW + start_color) / 2
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = preload("res://piano_keys/A440.wav")
	audio.pitch_scale = pitch_scale
	audio.play()
	color_timer.start()
	spawn_beam(beam_offset)
	await get_tree().create_timer(8.0).timeout
	audio.queue_free()


func deactivate():
	key.color = start_color


func spawn_beam(h_offset):
	var beam = beam_scene.instantiate()
	beam.position = global_position
	beam.position[0] += h_offset
	get_parent().add_child(beam)
	beam.connect("beam_collided", Callable(self, "_on_beam_collided"))

func _on_beam_collided(note):
	note.queue_free()
