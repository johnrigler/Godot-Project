extends Label

# may not need
signal score_changed

var score: int = 0

func increase_score():
	score += 1
	text = "Score: %s" % score
	# debug print
	#print("Score increased to: ", score)
	emit_signal("score_changed")
	

func get_score():
	return score
