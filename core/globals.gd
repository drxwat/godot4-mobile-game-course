extends Node

var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	print_debug(rng.seed)
