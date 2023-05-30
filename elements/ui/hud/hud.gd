extends CanvasLayer


func _on_home_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.START)
