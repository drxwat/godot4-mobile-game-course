extends CanvasLayer


func _on_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.GAME)
