extends Node

const location_to_scene = {
	Events.LOCATIONS.GAME: preload("res://scenes/game/game.tscn"),
	Events.LOCATIONS.START: preload("res://scenes/start_screen/start_screen.tscn"),
	Events.LOCATIONS.SHOP: preload("res://scenes/knife_shop/knife_shop.tscn")
}

const SAVE_GAME_FILE := "user://savegame.save"
const SAVE_VARIABLES := ["apples", "active_knife_index", "unlocked_knives"]

const MAX_STAGE_APPLES := 3
const MAX_STAGE_KNIVES := 2
const MIN_KNIVES := 5
const MAX_KNIVES := 8

var rng := RandomNumberGenerator.new()

var current_stage := 1
var points := 0
var knives := 0
var apples := 0

var active_knife_index := 0
var unlocked_knives := 0b000000001

func _ready():
	load_game()
	rng.randomize()
	print_debug(rng.seed)
	
	Events.location_changed.connect(handle_location_change)

func unlock_knife(knife_index: int):
	unlocked_knives |= (1 << knife_index)
	
func is_knife_unlocked(knife_index: int) -> bool:
	return unlocked_knives & (1 << knife_index) != 0

func change_knife(knife_index: int):
	active_knife_index = knife_index
	Events.active_knife_changed.emit(active_knife_index)

func save_game():
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.WRITE)
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return
	var game_data := {}
	for variable in SAVE_VARIABLES:
		game_data[variable] = get(variable)
	var json_object := JSON.new()
	save_game_file.store_line(json_object.stringify(game_data))

func load_game():
	if not FileAccess.file_exists(SAVE_GAME_FILE):
		return
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.READ)
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return
	var json_object = JSON.new()
	var error = json_object.parse(save_game_file.get_line())
	if error != OK:
		return
	var game_data = json_object.get_data()
	for variable in SAVE_VARIABLES:
		if variable in game_data:
			set(variable, game_data[variable])

func add_apples(amount: int):
	apples += amount
	Events.apples_changed.emit(apples)

func change_stage(stage_i: int):
	current_stage = stage_i
	var stage := get_common_stage()
	knives = rng.randi_range(MIN_KNIVES, MAX_KNIVES)
	Events.knived_changed.emit(knives)
	Events.stage_changed.emit(stage)

func get_common_stage() -> Stage:
	var stage := Stage.new()
	stage.apples = rng.randi_range(0, MAX_STAGE_APPLES)
	stage.knives = rng.randi_range(0, MAX_STAGE_KNIVES)
	return stage

func remove_knife():
	knives -= 1
	Events.knived_changed.emit(knives)

func add_point():
	points += 1
	Events.points_changed.emit(points)
	
func reset_points():
	points = 0
	Events.points_changed.emit(points)

func handle_location_change(location: Events.LOCATIONS):
	get_tree().change_scene_to_packed(location_to_scene.get(location))
