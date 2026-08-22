extends Node2D


const TowerScene = preload("res://Scenes/Tower.tscn")
var towers = {}
var lives = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			var tile_pos = $Ground.local_to_map($Ground.to_local(mouse_pos))
			
			var tile_data = $Ground.get_cell_tile_data(tile_pos)
			
			if tile_data:
				var is_buildable = tile_data.get_custom_data("is_buildable")
				
				if is_buildable:
					if towers.has(tile_pos):
						print("There is already a tower here!")
						return
						
					var tower_instance = TowerScene.instantiate()
					
					var tile_center = $Ground.map_to_local(tile_pos)
					tower_instance.position = tile_center
					
					add_child(tower_instance)
					
					towers[tile_pos] = tower_instance


func _on_enemy_path_enemy_leaked() -> void:
	lives -= 1.0
	print("Lives remaining: ", lives)
	
	if lives <= 0:
		game_over()
		
func game_over() -> void:
	print("GAME OVER")
	$LoseScreen.show()
	get_tree().paused = true
	


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	



func _on_enemy_path_game_won() -> void:
	print("YOU WIN")
	$WinScreen.show()
	get_tree().paused = true
