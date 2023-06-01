extends Node2D

var restart_overlya_scene := preload("res://elements/ui/restart_overlay/restart_overlay.tscn")

@onready var knife_shooter := $KnifeShooter
@onready var target_position := $TargetPosition

var target

func _ready():
	Events.game_over.connect(end_game)
	Events.stage_changed.connect(place_target)
	Globals.change_stage(1)

func place_target(stage: Stage):
	if target:
		target.queue_free()
	target = stage.target_scene_resource.instantiate()
	add_child(target)
	target.add_default_items(stage.knives, stage.apples)
	target.global_position = target_position.global_position

func end_game():
	knife_shooter.is_enabled = false
	show_restart_overlay()
	Globals.reset_points()

func show_restart_overlay():
	add_child(restart_overlya_scene.instantiate())
	Hud.update_hud_restart()
