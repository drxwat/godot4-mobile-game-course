extends Node2D

var is_hited := false

func _on_area_2d_body_entered(body):
	if not is_hited:
		is_hited = true
		queue_free()
