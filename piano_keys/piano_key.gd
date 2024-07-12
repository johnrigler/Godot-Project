class_name PianoKey
extends Control

var pitch_scale: float
@export var volume_db: float = -30.0  # Adjust the default volume in decibels
@export var max_play_duration: float = 3  # Maximum playback duration in seconds

@onready var key: ColorRect = $Key
@onready var start_color: Color = key.color
@onready var color_timer: Timer = $ColorTimer
@onready var key_particles: GPUParticles2D = $KeyParticles  # Using GPUParticles2D

func setup(pitch_index: int):
	name = "PianoKey" + str(pitch_index)
	var exponent := (pitch_index - 69.0) / 12.0
	pitch_scale = pow(2, exponent)

func activate():
	key.color = (Color.YELLOW + start_color) / 2
	var audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = preload("res://piano_keys/Piano_test4.wav")
	audio.pitch_scale = pitch_scale
	audio.volume_db = volume_db  # Set the volume
	audio.play()

	# Play the particle effect
	key_particles.emitting = true

	# Stop the audio after max_play_duration seconds
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = max_play_duration
	add_child(timer)
	timer.start()
	timer.connect("timeout", Callable(audio, "stop"))

	color_timer.start()
	await get_tree().create_timer(8.0).timeout
	audio.queue_free()

func deactivate():
	key.color = start_color
	# Stop the particle effect
	key_particles.emitting = false
