extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	# Disconnect the signal to avoid triggering the callback during initialization
	value_changed.disconnect(Callable(self, "_on_value_changed"))
	# Set the slider value to match the current bus volume
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100
	# Reconnect the signal after initialization
	value_changed.connect(Callable(self, "_on_value_changed"))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 1))
