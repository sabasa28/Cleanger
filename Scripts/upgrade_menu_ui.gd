extends CanvasItem

@export var upgrade_name_text : RichTextLabel
@export var upgrade_description_text : RichTextLabel
@export var upgrade_cost_text : RichTextLabel
var enabled : bool = false

func update_ui(upgrade_name : String, upgrade_description : String, upgrade_cost : int) -> void:
	enabled = true
	upgrade_name_text.text = upgrade_name
	upgrade_description_text.text = upgrade_description
	upgrade_cost_text.text = str("Cost: ", upgrade_cost)

func change_enabled_state(new_state : bool) -> void:
	enabled = new_state
	if !enabled:
		visible = false
