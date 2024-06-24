extends AudioStreamPlayer

@export var bpm := 100  # Beats per minute of the song
@export var measures_count := 4  # Number of beats per measure

# Tracking the beat and song position
var song_position = 0.0  # Current position in the song (in seconds)
var song_position_in_beats = 1  # Current position in the song (in beats)
var sec_per_beat = 60.0 / bpm  # Seconds per beat
var last_reported_beat = 0  # The last reported beat
var beats_before_start = 0  # Number of beats before the song starts
var current_measure = 1  # The current measure in the song

# Determining how close to the beat an event is
var closest = 0  # Closest beat
var time_off_beat = 0.0  # Time off from the closest beat

# Signals
signal beat(position)  # Emitted on each beat
signal measure_signal(position)  # Emitted on each measure

@onready var midi_player = $MIDIPlayer  # Reference to the MIDI player

func _ready():
	sec_per_beat = 60.0 / bpm
	midi_player.connect("midi_event", Callable(self, "_on_midi_event"))  # Connect MIDI events

func _physics_process(_delta):
	if playing:
		# Update song position accounting for audio latency
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		# Handle measure loop
		if current_measure > measures_count:
			current_measure = 1
		emit_signal("beat", song_position_in_beats)  # Emit beat signal
		emit_signal("measure_signal", current_measure)  # Emit measure signal
		last_reported_beat = song_position_in_beats
		current_measure += 1

func play_with_beat_offset(num):
	beats_before_start = num  # Set the number of beats before the song starts
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth)
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	current_measure = beat % measures_count  # Update current measure

func _on_StartTimer_timeout():
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()

# Handle MIDI events
func _on_midi_event(channel, event):
	if event.type == 144:  # Note On event
		spawn_note()  # Call function to spawn a falling note
