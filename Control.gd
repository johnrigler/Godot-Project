extends Control

# Lots going on here, I copied this from my 'Control.gd' example file. Probably needs to be elsewhere
# This was made with V3.5 of Godot, but should work here
# Run it and go find where it wrote the file. May be different on Windows
# This generated a valid MID file that played via the signal.vercel.app website

# This is pretty kludgey, but should be helpful. There is surely extra stuff. Read the standard and 
# this should then make more sense. The reader doesn't work yet, just the writer.

# https://www.music.mcgill.ca/~ich/classes/mumt306/StandardMIDIfileformat.html
# Header Chunk
var MThd = [ 0x4d, 0x54, 0x68, 0x64, 0x00, 0x00, 0x00, 0x06, 0x00, 0x01, 0x00, 0x02, 0x01, 0xe0]
#            "M"   "T"   "h"   "d"   [    length = 6      ]    1     2     3     4     5     6
#                                                              ^     ^     ^
#                                                              |     |     \--> Read the spec. for details
#                                                              |     \--------> Number of Tracks: 1
#                                                              \--------------> File Format:      0
var MTrkHdr1 = [ 0x4d, 0x54, 0x72, 0x6b, 0x00, 0x00, 0x00, 0x17, 0x00, 0xff, 0x03, 0x00, 0x00, 0xff, 0x58, 0x04, 0x04, 0x02, 0x18, 0x08, 0x00, 0xff, 0x51, 0x03, 0x07, 0xa1, 0x20, 0x00, 0xff, 0x2f, 0x00]
#                "M"   "T"   "r"   "k"   [ length = 0x00000017 ]
#                                           
#        The length is of the entire Track, in Hex, multiply times 2 to figure this out, right now
#        this is hard-coded, but we will need to calculate it each time.
#           
# The rest of this header stuff is likely not necessary. It is probably special escape codes
# or something. For now I am just leaving this stuff in, of course this is purely for 
# compatibility with https://signal.vercel.app/ and other MID players. 
#                                                 
var MTrkHdr2a = [ 0x4d, 0x54, 0x72, 0x6b, 0x00, 0x00, 0x00, 0x9a, 0x00, 0xb0, 0x79, 0x00, 0x00, 0xff, 0x03, 0x00, 0x00]
#                 "M"   "T"   "r"   "k"   [  length = 0x0000009a  ]                             [ track name?? ]
var MTrkHdr2b = [ 0xb0, 0x26, 0x00, 0x00, 0xb0, 0x64, 0x00, 0x00, 0xb0, 0x06, 0x40, 0x00 ]
# Not sure why second part can be repeated, clearly this is just a hack.
var MTrkHdr2 = MTrkHdr2a + MTrkHdr2b + MTrkHdr2b + MTrkHdr2b + MTrkHdr2b + MTrkHdr2b + [ 0xc0, 0x00 ]

# This next part represents the song itself ( crude scale )

#             D     O     N     V     A (not sure about last, check doc) 
#             E     N     O     E     F
#             L     /     T     L     T
#             A     O     E     O     E
#             Y     F     |     C     R
#             |     F     |     I     T
#             |     |     |     T     C
#             |     |     |     Y     H 
#             |     |     |     |     |     
#             v     v     v     v     v
var sng00 = [ 0x00, 0x90, 0x3c, 0x7f, 0x81 ]
var sng01 = [ 0x70, 0x80, 0x3c, 0x00, 0x81 ]
var sng02 = [ 0x70, 0x90, 0x3d, 0x7f, 0x81 ]
var sng03 = [ 0x70, 0x80, 0x3d, 0x00, 0x81 ]
var sng04 = [ 0x70, 0x90, 0x3e, 0x7f, 0x81 ]
var sng05 = [ 0x70, 0x80, 0x3e, 0x00, 0x81 ]
var sng06 = [ 0x70, 0x90, 0x3f, 0x7f, 0x81 ]
var sng07 = [ 0x70, 0x80, 0x3f, 0x00, 0x81 ]
var sng08 = [ 0x70, 0x90, 0x40, 0x7f, 0x81 ]
var sng09 = [ 0x70, 0x80, 0x40, 0x00, 0x81 ]
var sng10 = [ 0x70, 0x90, 0x41, 0x7f, 0x81 ]
var sng11 = [ 0x70, 0x80, 0x41, 0x00, 0x81 ]
var sng12 = [ 0x70, 0x90, 0x42, 0x7f, 0x81 ] 
var sng13 = [ 0x70, 0x80, 0x42, 0x00, 0x81 ] 
var sng14 = [ 0x70, 0x90, 0x43, 0x7f, 0x81 ]
var sng15 = [ 0x70, 0x80, 0x43, 0x00, 0x00 ]

var close = [ 0xff,0x2f,0x00 ]

# Called when the node enters the scene tree for the first time.
func _ready():
	save(MThd + MTrkHdr1 + MTrkHdr2 + sng00 + sng01 + sng02 + sng03 + sng04 + sng05 + sng06 + sng07 + sng08 + sng09 + sng10 + sng11 + sng12 + sng13 + sng14 + sng15 + close)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save(content):
	var file = File.new()
	#file.open("/Users/john/MID_File/save_game.dat", File.WRITE)
	file.open("user://example.mid", File.WRITE)
# ./Library/Application Support/Godot/app_userdata/MID_File/save_game.dat
	for x in content:
		file.store_8(x)
	
	# It is likely that a midi node on/off maps better to a 'packed' integer object
	# https://docs.godotengine.org/en/stable/classes/class_packedint64array.html
	# but for now file.store_8 works fine
	
	file.close()

func load():
	var file = File.new()
	file.open("user://save_game.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content
