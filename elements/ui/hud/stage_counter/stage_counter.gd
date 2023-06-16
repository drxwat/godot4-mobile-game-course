extends HBoxContainer

const PASSED_COLOR := Color("#f0ad1f")
const DEFAULT_COLOR := Color("#ffffff")

func _ready():
	Events.stage_changed.connect(update_stage)

func update_stage(stage: Stage):
	var current_stage = Globals.current_stage % Globals.BOSS_LEVEL
	
	for i in range(Globals.BOSS_LEVEL):
		var texture_rect: TextureRect = get_child(i)
		texture_rect.modulate = PASSED_COLOR if current_stage == 0 or i < current_stage else DEFAULT_COLOR
