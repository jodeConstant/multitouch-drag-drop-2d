extends Node2D

## Lowest z-index for drag & drop items
@export var min_z_index: int

## Additional spacing between drag & drop items' z-index,
## 0 or less for no spacing (min, min + 1, min + 2 ...)
@export var z_index_spacing: int

## WARNING: Child nodes' classes should match DragDropItem2D.
## Skip type check ONLY if you know they will all match.
@export var skip_type_check: = false

var items: Array[DragDropItem2D]

func _ready() -> void:
	items.append_array(
		get_children() 
		if skip_type_check else 
		find_children("*", "DragDropItem2D", false, false)
		)
	#print_debug(items)
	for it in items:
		if not it._on_drag_start.is_connected(_on_item_picked_up):
			it._on_drag_start.connect(_on_item_picked_up)

## Sorts z-indices of registered non-Control type drag & drop items
func _on_item_picked_up(item: Node2D):
	#print_debug("picked up %s" % item)
	move_child(item, -1)
	# moves / adds item to be last in the list
	items.erase(item)
	items.push_back(item)
	for i in items.size():
		items[i].z_index = min_z_index + i + (i * maxi(0, z_index_spacing))
		#print_debug("%s has z-index %s" % [items[i], items[i].z_index])

func _set_drag_follow_variables(min_step: float, fraction_per_step: float) -> void:
	for i in items:
		i._set_move_vals(min_step, fraction_per_step)
