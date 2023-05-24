extends CharacterBody2D
class_name Target

const EXPLOSION_TIME := 1.0
const GENERATION_LIMIT := 10
const KNIFE_POSITION = Vector2(0, 180)
const APLLE_POSITION = Vector2(0, 176)
const OBJECT_MARGIN := PI / 6

var knife_scene : PackedScene = load("res://elements/knife/knife.tscn")
var apple_scene : PackedScene = load("res://elements/apple/apple.tscn")

var speed := PI

@onready var items_container := $ItemsContainer
@onready var sprite := $Sprite2D
@onready var knife_particles := $KnifeParticles2D
@onready var particles_target_parts := [
	$TargetParticles2D,
	$TargetParticles2D2,
	$TargetParticles2D3
]

func _ready():
	add_default_items(3, 2)

func _physics_process(delta: float):
	rotation += speed * delta
	
func explode():
	sprite.hide()
	items_container.hide()
	
	var tween := create_tween()
	
	for target_particles_part in particles_target_parts:
		tween.parallel().tween_property(target_particles_part, "modulate", Color("ffffff00"), EXPLOSION_TIME)
		target_particles_part.emitting = true
		
	knife_particles.rotation = -rotation
	knife_particles.emitting = true
	tween.parallel().tween_property(knife_particles, "modulate", Color("ffffff00"), EXPLOSION_TIME)
	
	tween.play()

func add_object_with_pivot(object: Node2D, object_rotation: float):
	var pivot := Node2D.new()
	pivot.rotation = object_rotation
	pivot.add_child(object)
	items_container.add_child(pivot)

func add_default_items(knives: int, apples: int):
	var occupied_rotations := []
	for i in range(knives):
		var pivot_rotation = get_free_random_ratation(occupied_rotations)
		if pivot_rotation == null:
			return
		occupied_rotations.append(pivot_rotation)
		var knife = knife_scene.instantiate()
		knife.position = KNIFE_POSITION
		add_object_with_pivot(knife, pivot_rotation)
		
	for i in range(apples):
		var pivot_rotation = get_free_random_ratation(occupied_rotations)
		if pivot_rotation == null:
			return
		occupied_rotations.append(pivot_rotation)
		var apple = apple_scene.instantiate()
		apple.position = APLLE_POSITION
		add_object_with_pivot(apple, pivot_rotation)

func get_free_random_ratation(occupied_rotations: Array, generation_attempts = 0):
	if generation_attempts >= GENERATION_LIMIT:
		return null
	
	var random_rotation = Globals.rng.randf_range(0, PI * 2)
	
	for occupied in occupied_rotations:
		if random_rotation <= occupied + OBJECT_MARGIN / 2.0 and random_rotation >= occupied - OBJECT_MARGIN / 2.0:
			return get_free_random_ratation(occupied_rotations, generation_attempts + 1)
	
	return random_rotation
