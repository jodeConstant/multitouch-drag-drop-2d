extends Sprite2D

@onready var _hiding_place: Node = self.get_parent()
@onready var default_scale := self.scale
@onready var default_z_index := self.z_index

func set_target(p_target: Node2D):
	if p_target:
		reparent(p_target, false)
		visible = true
		position = Vector2.ZERO
		
		var t_sprite: = p_target as Sprite2D
		if t_sprite:
			scale = t_sprite.texture.get_size() / texture.get_size()
			z_index = t_sprite.z_index + 1
		else:
			scale = default_scale
			z_index = default_z_index
	else:
		reparent(_hiding_place)
		visible = false
