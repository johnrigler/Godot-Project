class_name LevelManager extends Node

const LevelScene = preload("res://level.tscn")

# want this list to also include properties like background or w/e
const LEVEL_LIST = "res://level_list.csv"
const LEVEL_PATH = "res://levels"
const TAP_PATH = "res://taps"
const MOD_PATH = "user://mods"		#for user generated content


## This class just gets lists of levels from a set of level paths, that's it



# this should get developer levels
static func get_levels() -> PackedStringArray:
	return DirAccess.get_files_at(LEVEL_PATH)


# this should get developer tap exercises
static func get_taps() -> PackedStringArray:
	return DirAccess.get_files_at(TAP_PATH)


# this should get user generated content levels
static func get_mods() -> PackedStringArray:
	return DirAccess.get_files_at(MOD_PATH)
