class_name json_note_player

static func get_notes():
	var json = JSON.new()
	var noteList = json.parse_string(FileAccess.get_file_as_string("res://Assets/audio/Alouette.json"))
	print(noteList)
	#for elem in noteList:
		#for i in range(len(elem)):
			#elem[i] = elem[i].hex_to_int()
	return noteList
