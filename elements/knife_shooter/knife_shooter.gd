extends Node2D

var knife_scene := preload("res://elements/knife/knife.tscn")

@onready var knife := $Knife
@onready var timer := $Timer

func create_new_knife():
	knife = knife_scene.instantiate()
	add_child(knife)

func _input(event: InputEvent):
	if event is InputEventScreenTouch and event.is_pressed() and timer.time_left <= 0:
		knife.throw()
		timer.start()


func _on_timer_timeout():
	create_new_knife()
