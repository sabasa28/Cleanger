extends CanvasLayer

signal on_upgrades_finished
@export var all_upgrades : Array[upgrade]
@export var coins_text : RichTextLabel

func _ready() -> void:
	Stats.on_coins_changed.connect(update_coins_text)

func _process(delta: float) -> void:
	pass

func _on_button_upgrade_button_down(upgrade_num : int) -> void:
	on_upgrade_button_pressed(upgrade_num)

func _on_button_upgrade_0_button_down() -> void:
	on_upgrade_button_pressed(0)

func _on_button_upgrade_1_button_down() -> void:
	on_upgrade_button_pressed(1)

func _on_button_upgrade_2_button_down() -> void:
	on_upgrade_button_pressed(2)

func _on_button_upgrade_3_button_down() -> void:
	on_upgrade_button_pressed(3)

func _on_button_upgrade_4_button_down() -> void:
	on_upgrade_button_pressed(4)

func _on_button_upgrade_finished_button_down() -> void:
	on_upgrades_finished.emit()
	print("Upgrades finished")

func on_upgrade_button_pressed(button_num : int) -> void:
	if button_num < 0 || button_num >= all_upgrades.size():
		print("aca pasa algo raro che")
		return
	all_upgrades[button_num].apply_upgrade()

func prepare_and_set_visible() -> void:
	for i in all_upgrades.size():
		if all_upgrades[i].button_node == null:
			all_upgrades[i].button_node = get_node(all_upgrades[i].button)
			all_upgrades[i].button_node.button_down.connect(_on_button_upgrade_button_down.bind(i))
		all_upgrades[i].try_init(i)
		all_upgrades[i].update_button_and_menu()
	visible = true

func update_coins_text(coins_total, coins_just_earned) -> void:
	coins_text.text = str(coins_total)

func _display_description(description_displayer : NodePath) -> void:
	get_node(description_displayer).visible = true

func _stop_displaying_description(description_displayer : NodePath) -> void:
	get_node(description_displayer).visible = false
