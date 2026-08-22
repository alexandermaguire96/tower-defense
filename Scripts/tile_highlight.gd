extends Node2D

@export var tile_map: TileMapLayer

var is_buildable = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_pos = tile_map.get_global_mouse_position()
	var tile_pos = tile_map.local_to_map(tile_map.to_local(mouse_pos))
	
	var tile_data = tile_map.get_cell_tile_data(tile_pos) 
	
	if tile_data:
		is_buildable = tile_data.get_custom_data("is_buildable")
	else:
		is_buildable = false
	
	var tile_center = tile_map.map_to_local(tile_pos)
	global_position = tile_map.to_global(tile_center)
	
	queue_redraw()
	
func _draw():
	if is_buildable:
		var tile_size = Vector2(tile_map.tile_set.tile_size)
		
		var rect = Rect2(
			- tile_size / 2,
			tile_size
		)
			
		draw_rect(rect, Color.WHITE, false, 2.0)
	
