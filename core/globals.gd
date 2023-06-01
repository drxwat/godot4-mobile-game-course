extends Node

const location_to_scene = {
	Events.LOCATIONS.GAME: preload("res://scenes/game/game.tscn"),
	Events.LOCATIONS.START: preload("res://scenes/start_screen/start_screen.tscn"),
	Events.LOCATIONS.SHOP: preload("res://scenes/knife_shop/knife_shop.tscn")
}

const MAX_STAGE_APPLES := 3
const MAX_STAGE_KNIVES := 2
const MIN_KNIVES := 5
const MAX_KNIVES := 8

var rng := RandomNumberGenerator.new()

var current_stage := 1
var points := 0
var knives := 6

func _ready():
	rng.randomize()
	print_debug(rng.seed)
	
	Events.location_changed.connect(handle_location_change)

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
