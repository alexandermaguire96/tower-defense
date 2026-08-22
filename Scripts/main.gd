extends Node2D

@onready var coin_label = $CoinLabel
@onready var tower_actions = $TowerActions

var towers = {}
var lives = 5.0
var coins = 100
var selected_tower = null

const TOWER_COST = 30

@export var tier_1_pool: Array[PackedScene]
@export var tier_2_pool: Array[PackedScene]
@export var tier_3_pool: Array[PackedScene]
@export var tier_4_pool: Array[PackedScene]
@export var tier_5_pool: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	coin_label.text = "Coins: " + str(coins)

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
						selected_tower = towers[tile_pos]
						print("Selected tower: ", selected_tower)
						print("showing tower actions")
						
						var tower_position = selected_tower.global_position
						
						var reroll = tower_actions.get_node("Reroll")
						var merge = tower_actions.get_node("Merge")
						
						var button_width = reroll.size.x * reroll.scale.x
						var button_height = reroll.size.y * reroll.scale.y
						
						reroll.position = tower_position + Vector2(-button_width / 2, -button_height - 40)
						merge.position = tower_position + Vector2(-button_width / 2, 40)
						
						merge.hide()
						tower_actions.show()
						return
					
					if coins < TOWER_COST:
						return
					coins -= TOWER_COST
					
					var tower_scene = tier_1_pool.pick_random()	
					var tower_instance = tower_scene.instantiate()
					
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
	
func add_coins(amount: int) -> void:
	coins += amount
	
