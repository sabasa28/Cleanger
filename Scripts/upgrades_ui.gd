extends CanvasLayer

signal on_upgrades_finished

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_button_upgrade_3_button_down() -> void:
	print("Button 3 pressed")


func _on_button_upgrade_2_button_down() -> void:
	print("Button 2 pressed")


func _on_button_upgrade_1_button_down() -> void:
	print("Button 1 pressed")


func _on_button_upgrade_finished_button_down() -> void:
	on_upgrades_finished.emit()
