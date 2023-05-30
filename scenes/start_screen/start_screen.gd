extends Control


func _on_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.GAME)


func _on_texture_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.SHOP)
