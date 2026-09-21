## Sprite2D drag & drop item, supports multitouch
class_name DragDropItem2D

extends Sprite2D

## Check to NOT drag this object by its center
@export var keep_drag_offset: = true

@export var smooth_movement: = false

## Should be between 0 and 1
@export var move_fraction_per_frame: = 0.9

## Shortest distance moved per frame squared, if distance
## to _target_pos is shorter, object does not move
@export var min_move_step_sqrd: = 1.0

var _vwprt: Viewport

var _touch: InputEventScreenTouch
var _drag: InputEventScreenDrag

# Internal movement smoothing variables
var _target_pos: Vector2
var _pos_diff: Vector2
var _drag_offset: Vector2

# For multitouch
var _touch_idx: = -1

# Can be changed to decouple from a Sprite2D properties
@onready var _bounds: Vector2 = (texture.get_size() * 0.5)

func _set_move_vals(increment: float, fraction: float):
	min_move_step_sqrd = increment * increment
	move_fraction_per_frame = fraction

func _drop() -> void:
	# action(s) here:
	
	emit_signal("_on_drag_end", self)
	print_debug("[WIP] Dropped item #%s: %s" % [_touch_idx, name])
	_touch_idx = -1

func _start_drag() -> void:
	_touch_idx = _touch.index
	_drag_offset = -_touch.position * scale
	emit_signal("_on_drag_start", self)
	print_debug("[WIP] Start drag of item #%s: %s" % [_touch_idx, name])

func _in_bounds(point: Vector2) -> bool:
	point = point.abs()
	return (point.x < _bounds.x) and (point.y < _bounds.y)

func _ready() -> void:
	min_move_step_sqrd = maxf(0.01, min_move_step_sqrd)
	move_fraction_per_frame = clampf(move_fraction_per_frame, 0.01, 1.0)
	_target_pos = position
	_vwprt = get_tree().root.get_viewport()
	if not _vwprt:
		print_debug("No viewport found for node %s, deleting..." % name)
		queue_free()
	#print_debug("Bounds for %s are: %s" % [name, _bounds])

# For smoother object movement, moving a fraction of remaining
# distance per frame. Possibly unnecessary.
# _process can also be used for a consistent speed if needed
func _process(_delta: float) -> void:
	if smooth_movement:
		_pos_diff = _target_pos - position
		if (_pos_diff.length_squared() > min_move_step_sqrd):
			position += _pos_diff * move_fraction_per_frame

func _unhandled_input(event: InputEvent) -> void:
	# start drag:
	_touch = make_input_local(event) as InputEventScreenTouch
	if _touch:
		# test for touch overlap with the item to start drag
		if _touch.pressed:
			#print_debug("%s evaluates a press, local position: %s" % [name, _touch.position])
			if _in_bounds(_touch.position):
				#print_debug("In bounds of %s" % name)
				_start_drag()
				_vwprt.set_input_as_handled()
		elif _touch.index == _touch_idx:
			_drop()
			_vwprt.set_input_as_handled()
	else:
		_drag = make_input_local(event) as InputEventScreenDrag
		if _drag and _drag.index == _touch_idx:
			_target_pos = event.position + _drag_offset if keep_drag_offset else event.position
			_vwprt.set_input_as_handled()
			if not smooth_movement:
				#print_debug("--> %s" % _pos_diff.length_squared())
				_pos_diff = _target_pos - position
				if (_pos_diff.length_squared() > min_move_step_sqrd):
					position = _target_pos

signal _on_drag_start(item: Node2D)
signal _on_drag_end(item: Node2D)
