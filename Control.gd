extends Control

# https://docs.godotengine.org/en/3.5/about/list_of_features.html#file-formats

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# var c = [0x41,0xff,0xff]
# https://www.music.mcgill.ca/~ich/classes/mumt306/StandardMIDIfileformat.html
var NoName =    [ 0xff, 0x03, 0x00, 0x00]
var TimeSig =   [ 0xff, 0x58, 0x04, 0x04, 0x02, 0x18, 0x08 ]
#                                     nn    dd    cc    bb
var Tempo =     [ 0xff, 0x51, 0x03, 0x07, 0xa1, 0x20 ]
var Close =     [ 0xff, 0x2f, 0x00 ]
# Header Chunk
var Length1 = [ 0x00, 0x00, 0x00, 0x06 ]
var MThd = [ 0x4d, 0x54, 0x68, 0x64 ] + Length1 + [ 0x00, 0x01, 0x00, 0x02, 0x01, 0xe0]
#            "M"   "T"   "h"   "d"                     1     2     3     4     5     6
#                                                              ^     ^     ^
#                                                              |     |     \--> Read the spec. for details
#                                                              |     \--------> Number of Tracks: 1
#                                                              \--------------> File Format:      0
var MTrk = [ 0x4d, 0x54, 0x72, 0x6b ] # MTrk
var Length2 = [ 0x00, 0x00, 0x00, 0x17 ]
var MTrkHdr1 = MTrk + Length2 + [ 0x00 ] + NoName + TimeSig + [ 0x00] + Tempo + [ 0x00 ] + Close
#              
# The rest of this header stuff is likely not necessary. It is probably special escape codes
# or something. For now I am just leaving this stuff in, of course this is purely for 
# compatibility with https://signal.vercel.app/ and other MID players. 
#                               
var Length3 = [ 0x00, 0x00, 0x00, 0x9a ]                  
var MTrkHdr2a = MTrk + Length3 + [ 0x00, 0xb0, 0x79, 0x00, 0x00 ]
var MTrkHdr2b = [ 0xb0, 0x26, 0x00, 0x00, 0xb0, 0x64, 0x00, 0x00, 0xb0, 0x06, 0x40, 0x00 ]
# Not sure why second part can be repeated, clearly this is just a hack. I think there
# are 16 groups of 4 8bytes that all start with 0xb0, I think they are midi channels
# I made most of them the same with the above snippet. Very much a work in progress.
var MTrkHdr2 = MTrkHdr2a + NoName + MTrkHdr2b + MTrkHdr2b + MTrkHdr2b + MTrkHdr2b + MTrkHdr2b + [ 0xc0, 0x00 ]

# This next part represents the song itself ( crude scale )

#              [[[     PRESS KEY     ]]]          [[[    RELEASE KEY    ]]]
#              -------------------------          -------------------------
#              R     O     N     V     A          R     O     N     V     A
#              E     N     O     E     F          E     F     O     E     F
#              S     |     T     L     T          S     F     T     L     T
#              T     |     E     O     E          T     |     E     O     E
#              |     |     |     C     R          |     |     |     C     R
#              |     |     |     I     T          |     |     |     I     T
#              |     |     |     T     C          |     |     |     T     C 
#              |     |     |     Y     H          |     |     |     Y     H
#              |     |     |     |     |          |     |     |     |     |
#              v     v     v     v     v          v     v     v     v     v
var Note00 = [ 0x00, 0x90, 0x3c, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x3c, 0x00, 0x81 ]
var Note01 = [ 0x70, 0x90, 0x3d, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x3d, 0x00, 0x81 ]
var Note02 = [ 0x70, 0x90, 0x3e, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x3e, 0x00, 0x81 ]
var Note03 = [ 0x70, 0x90, 0x3f, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x3f, 0x00, 0x81 ]
var Note04 = [ 0x70, 0x90, 0x40, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x40, 0x00, 0x81 ]
var Note05 = [ 0x70, 0x90, 0x41, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x41, 0x00, 0x81 ]
var Note06 = [ 0x70, 0x90, 0x42, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x42, 0x00, 0x81 ] 
var Note07 = [ 0x70, 0x90, 0x43, 0x7f, 0x81 ] + [ 0x70, 0x80, 0x43, 0x00, 0x00 ]

var Song = Note00 + Note01 + Note02 + Note03 + Note04 + Note05 + Note06 + Note07

# Called when the node enters the scene tree for the first time.
func _ready():
	save(MThd + MTrkHdr1 + MTrkHdr2 + Song + Close)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save(content):
	var file = File.new()
	file.open("user://example.mid", File.WRITE)
#   Macbook -> ./Library/Application Support/Godot/app_userdata/MID_File/save_game.dat
	for x in content:
		file.store_8(x)
	
	# The note always seems to have 5 8-byte parts. The cleanest way
	# to handle that would be with a store_40 function. But such
	# a thing doesn't exist, so this is probably fine for now.
	
	# https://docs.godotengine.org/en/stable/classes/class_packedint64array.html
	
	file.close()

func load():
	var file = File.new()
	file.open("user://save_game.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content
