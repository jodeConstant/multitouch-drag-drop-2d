extends DragDropItem2D

class_name DragDropItemLimited2D

@export var max_speed: float = 10
## 0 or less means instant
@export var acceleration: float = 0
var _current_speed: float
var _is_moving: bool = false


func set_step_rate_accl(p_min_step: float, p_rate: float = -1, p_acceleration: float = -1):
	min_move_step_sqrd = p_min_step * p_min_step
	max_speed = p_rate
	acceleration = p_acceleration

func get_step_rate_accl() -> Vector3:
	return Vector3(sqrt(min_move_step_sqrd), max_speed, acceleration)

func _update_move() -> void:
	if (_pos_diff.length_squared() > min_move_step_sqrd):
		_is_moving = true
		if acceleration <= 0:
			_current_speed = max_speed

func _ready() -> void:
	super._ready()
	max_speed = maxf(max_speed, 0)
	acceleration = maxf(acceleration, 0)

func _physics_process(delta: float) -> void:
	if _is_moving:
		if acceleration > 0:
			_current_speed = move_toward(_current_speed, max_speed, acceleration * delta)
		position = position.move_toward(_target_pos, _current_speed)
		if position.is_equal_approx(_target_pos):
			_is_moving = false
			_current_speed = 0
