extends CharacterBody2D

var speed := PI

func _physics_process(delta: float):
	rotation += speed * delta
