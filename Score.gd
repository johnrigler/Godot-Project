extends Label

signal score_changed

var score: int = 0

func increase_score():
	score += 1
	text = "Score: %s" % score
	print("Score increased to: ", score)  # Debugging statement
	emit_signal("score_changed")
