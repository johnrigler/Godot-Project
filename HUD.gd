extends CanvasLayer

var scoreCollected = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreCount.text = "Score: " + str(scoreCollected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_falling_note_body_entered(body):
	scoreCollected = scoreCollected + 1
	$ScoreCount.text = "Score: " + str(scoreCollected)
