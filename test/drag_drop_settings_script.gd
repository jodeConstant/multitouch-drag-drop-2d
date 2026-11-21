extends Control

@onready var _min_step_edit: TextEdit = $"MinStepEdit"
@onready var _rate_edit: TextEdit = $RateEdit
@onready var _acceleration_edit: TextEdit = $AccelerationEdit

var current_item: DragDropItem2D

func _ready() -> void:
	_min_step_edit.visible = false
	_rate_edit.visible = false
	_acceleration_edit.visible = false

func _on_button_pressed() -> void:
	if current_item:
		var new_rate: = float(_rate_edit.text)
		_rate_edit.text = "%s" % new_rate
		print_debug("Setting move rate (fraction per frame or speed) value to: %s" % new_rate)
		
		var new_acceleration: = float(_acceleration_edit.text)
		_acceleration_edit.text = "%s" % new_acceleration
		print_debug("Setting acceleration (if applicable) to: %s" % new_acceleration)
		
		var new_min_step: = float(_min_step_edit.text)
		_min_step_edit.text = "%s" % new_min_step
		print_debug("Setting min move step to: %s" % new_min_step)
		
		current_item.set_step_rate_accl(new_min_step, new_rate, new_acceleration)

# Hides setting input fields that are not applicable for selected item
func _on_item_selected(p_item) -> void:
	current_item = p_item as DragDropItem2D
	if current_item:
		var vals = current_item.get_step_rate_accl()
		
		_min_step_edit.visible = true
		_min_step_edit.text = "%s" % vals.x
		
		_rate_edit.visible = \
			(current_item is DragDropItemLimited2D) or (current_item is DragDropItemSmooth2D)
		_rate_edit.text = "%s" % vals.y
		
		_acceleration_edit.visible \
			= current_item is DragDropItemLimited2D
		_acceleration_edit.text = "%s" % vals.z
