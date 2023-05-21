extends CharacterBody2D

var is_flying := false
var speed := 4500.0

func _physics_process(delta: float):
	if is_flying:
		var collision = move_and_collide(Vector2.UP * speed * delta)

func throw():
	is_flying = true
