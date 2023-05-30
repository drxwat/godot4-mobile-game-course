extends Node

const location_to_scene = {
	Events.LOCATIONS.GAME: preload("res://scenes/game/game.tscn"),
	Events.LOCATIONS.START: preload("res://scenes/start_screen/start_screen.tscn"),
	Events.LOCATIONS.SHOP: preload("res://scenes/knife_shop/knife_shop.tscn")
}

var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	print_debug(rng.seed)
	
	Events.location_changed.connect(handle_location_change)

func handle_location_change(location: Events.LOCATIONS):
	get_tree().change_scene_to_packed(location_to_scene.get(location))
