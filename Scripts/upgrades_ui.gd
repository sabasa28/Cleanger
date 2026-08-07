extends CanvasLayer

signal on_upgrades_finished

func _ready() -> void:
	pass # Replace with function body. she got that body oh me oh my

func _process(delta: float) -> void:
	pass

func _on_button_upgrade_3_button_down() -> void:
	Stats.raise_floor_value(0.1)
	print("Floors value raised")

func _on_button_upgrade_2_button_down() -> void:
	Stats.raise_window_value(1.0)
	print("Windows value raised")

func _on_button_upgrade_1_button_down() -> void:
	Stats.raise_spot_value(0.5)
	print("Spots value raised")

func _on_button_upgrade_finished_button_down() -> void:
	on_upgrades_finished.emit()
	print("Upgrades finished")

func _on_button_upgrade_4_button_down() -> void:
	Stats.raise_strenght(0.25)
	print("Strenght raised")
