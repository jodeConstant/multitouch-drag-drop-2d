## Sprite2D drag & drop item, supports multitouch
class_name DragDropItem2D

extends Sprite2D

## Shortest distance moved per frame squared, if distance
## to _target_pos is shorter, object does not move
@export var min_move_step_sqrd: = 1.0

var _vwprt: Viewport

var _touch: InputEventScreenTouch
var _drag: InputEventScreenDrag

var _drag_offset: Vector2

# Needed for the derived classes
var _target_pos: Vector2
var _pos_diff: Vector2

# For multitouch
var _touch_idx: = -1

# Can be changed to decouple from a Sprite2D properties
@onready var _bounds: Vector2 = (texture.get_size() * 0.5)

## Check to NOT drag this object by its center
@export var keep_drag_offset: = true
## If true, treats X (or Y, if below options is checked) dimension as radius
@export var circular_bounds: = false
@export var y_as_radius: = false

func set_step_rate_accl(p_min_step: float, _p_rate: float = -1, _p_acceleration: float = -1):
	min_move_step_sqrd = p_min_step * p_min_step

func get_step_rate_accl() -> Vector3:
	return Vector3(sqrt(min_move_step_sqrd), -1, -1)

func _drop() -> void:
	# action(s) here:
	
	_on_drag_end.emit(self)
	print_debug("[WIP] Dropped item #%s: %s" % [_touch_idx, name])
	_touch_idx = -1

func _start_drag() -> void:
	_touch_idx = _touch.index
	_drag_offset = -_touch.position * scale
	_on_drag_start.emit(self)
	print_debug("[WIP] Start drag of item #%s: %s" % [_touch_idx, name])

func _update_move() -> void:
	if (_pos_diff.length_squared() > min_move_step_sqrd):
		position = _target_pos

func _in_bounds(point: Vector2) -> bool:
	point = point.abs()
	if circular_bounds:
		return point.length_squared() <= ( (_bounds.y * _bounds.y) 
			if y_as_radius else (_bounds.x * _bounds.x) )
	else:
		return (point.x < _bounds.x) and (point.y < _bounds.y)

func _ready() -> void:
	min_move_step_sqrd = maxf(0, min_move_step_sqrd)
	_target_pos = position
	_vwprt = get_tree().root.get_viewport()
	if not _vwprt:
		print_debug("No viewport found for node %s, deleting..." % name)
		queue_free()
	#print_debug("Bounds for %s are: %s" % [name, _bounds])

# NOTE: Changing this to _input(...) allows dragging over UI elements,
# but likely with overlapping UI reacting to inputs as well.
func _unhandled_input(event: InputEvent) -> void:
	# start drag:
	_touch = make_input_local(event) as InputEventScreenTouch
	if _touch:
		# test for touch overlap with the item to start drag
		if _touch.pressed and _in_bounds(_touch.position):
			#print_debug("In bounds of %s" % name)
			_start_drag()
			_vwprt.set_input_as_handled()
		elif _touch.index == _touch_idx:
			_drop()
			_vwprt.set_input_as_handled()
	
	elif _touch_idx > -1:# only chech drag if the item has been picked up (index not -1)
		_drag = make_input_local(event) as InputEventScreenDrag
		if _drag and _drag.index == _touch_idx:
			_target_pos = event.position + _drag_offset if keep_drag_offset else event.position
			_pos_diff = _target_pos - position
			_update_move()
			_vwprt.set_input_as_handled()

signal _on_drag_start(item: Node2D)
signal _on_drag_end(item: Node2D)
