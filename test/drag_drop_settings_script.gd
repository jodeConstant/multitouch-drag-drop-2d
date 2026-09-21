extends Control

@onready var _increment_edit: TextEdit = $"MinStepEdit"
@onready var _fraction_edit: TextEdit = $FractionEdit

signal on_settings_changed(min_step: float, fraction_per_step: float)

func _on_button_pressed() -> void:
	var min_step: = float(_increment_edit.text)
	_increment_edit.text = "%s" % min_step
	print_debug("Setting min move increment to: %s" % min_step)
	
	var fraction: = float(_fraction_edit.text)
	_fraction_edit.text = "%s" % fraction
	print_debug("Setting fraction per move to: %s" % fraction)
	
	emit_signal("on_settings_changed", min_step, fraction)
