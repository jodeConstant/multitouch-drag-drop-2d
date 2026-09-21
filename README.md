# Overview

This is relatively simple way to implement a multitouch-supporting drag & drop for Node2D -derived nodes, using Sprite2D as an example.

This implementation uses a Sprite2D as a base class and relies on texture size for drag detection bounds size and shape of objects.
This can be changed by changing the corresponding `_bounds` variable to an adjustable property via `@export` annotation.

## Limitations and features to be added:

- Currently drag input events may have to be processed by all drag & drop items' scripts at worst. May be inefficient with large numbers of drag & drop items
- Not yet implemented a "dispenser" system to add new drag & drop items via dragging from a "stack"
- No 2D physics-integration yet
- No frame rate -independent speed limitation yet, should be easy to add via `_process` or `_physics_process` methods though
