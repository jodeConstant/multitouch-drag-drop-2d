extends DragDropItem2D

class_name DragDropItemSmooth2D

## Should be between 0 and 1
@export var move_fraction_per_frame: = 0.9
## 1 would be (nearly?) indistinguishable from no smoothing
const STEP_FRACTION_LIMITS: = Vector2(0.01, 1.0)

func set_step_rate_accl(p_min_step: float, p_rate: float = -1, _p_acceleration: float = -1):
	min_move_step_sqrd = p_min_step * p_min_step
	move_fraction_per_frame = clampf(p_rate, STEP_FRACTION_LIMITS.x, STEP_FRACTION_LIMITS.y)

func get_step_rate_accl() -> Vector3:
	return Vector3(sqrt(min_move_step_sqrd), move_fraction_per_frame, -1)

func _update_move() -> void:
	pass

func _ready() -> void:
	super._ready()
	move_fraction_per_frame = clampf(
		move_fraction_per_frame, 
		STEP_FRACTION_LIMITS.x, STEP_FRACTION_LIMITS.y)

func _process(_delta: float) -> void:
	_pos_diff = _target_pos - position
	if (_pos_diff.length_squared() > min_move_step_sqrd):
		position += _pos_diff * move_fraction_per_frame
