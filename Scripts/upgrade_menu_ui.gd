extends Node

@export var upgrade_name_text : RichTextLabel
@export var upgrade_description_text : RichTextLabel
@export var upgrade_cost_text : RichTextLabel

func update_ui(upgrade_name : String, upgrade_description : String, upgrade_cost : int) -> void:
	upgrade_name_text.text = upgrade_name
	upgrade_description_text.text = upgrade_description
	upgrade_cost_text.text = str("Cost: ", upgrade_cost)
