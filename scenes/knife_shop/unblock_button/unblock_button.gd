extends PanelContainer

signal pressed

func _on_button_pressed():
	pressed.emit()
