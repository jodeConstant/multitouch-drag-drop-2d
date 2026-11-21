extends Node2D

## Toggle whether z-index gets adjusted as items are selected.
## NOTE: If z-index is the same for all drag & drop objects,
## draw order gets adjusted just by node hierarchy / ordering.
@export var z_index_sorting: = false

## Lowest z-index for drag & drop items
@export var min_z_index: int

## Additional spacing between drag & drop items' z-index,
## 0 or less for no spacing (min, min + 1, min + 2 ...)
@export var z_index_spacing: int

var sortable_items: Array[Node2D]

signal _on_managed_item_dragged(item: Node2D)

# Signal names
#static var _self_on_managed_item_drag_signal: = &"_on_managed_item_dragged"
#static var _item_on_drag_signal: = &"_on_drag_start"

# Find appropriate items among child nodes
func _ready() -> void:
	# NOTE: Child nodes' classes should match DragDropItem2D.
	# Remove this type check ONLY if you know they will all match.
	var childrn: = get_children()
	var idx: = 0
	while idx < childrn.size():
		#print_debug("z-sorter processing item %s at index %s" % [childrn[idx].name, idx])
		if (childrn[idx] is Node2D) and childrn[idx].has_signal(&"_on_drag_start"):
			if not childrn[idx]._on_drag_start.is_connected(_on_item_picked_up):
				childrn[idx]._on_drag_start.connect(_on_item_picked_up)
			idx += 1
		else:
			childrn.remove_at(idx)
	sortable_items.append_array(childrn)

## Sorts z-indices of registered non-Control type drag & drop items
func _on_item_picked_up(item: Node2D):
	print_debug("picked up %s" % item)
	
	# Top-level drawn item should react to overlapping inputs
	move_child(item, -1)
	
	if z_index_sorting:
		# For z-index sorting
		# moves / adds item to be last in the list
		sortable_items.erase(item)
		sortable_items.push_back(item)
		for i in sortable_items.size():
			sortable_items[i].z_index = min_z_index + i + (i * maxi(0, z_index_spacing))
			#print_debug("%s has z-index %s" % [sortable_items[i], sortable_items[i].z_index])
			
	_on_managed_item_dragged.emit(item)

# TODO:
#func add_sortable_item(p_item: Node2D) -> void:
	#pass
