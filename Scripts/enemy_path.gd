extends Path2D

signal enemy_leaked
signal game_won

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene

@export var wave_delay := 5.0
@export var boss_wave_delay := 10.0

var current_wave := 59
var max_waves := 60
var enemies_spawned := 0
var enemies_per_wave := 10
var boss_spawned := false


@export var health_scaling := 1.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	if is_boss_wave():
		$SpawnRate.stop()
		spawn_boss()
		return
		
	var new_follow = PathFollow2D.new()
	new_follow.set_script(preload("res://Scripts/path_follow_2d.gd"))

	add_child(new_follow)
	
	new_follow.enemy_leaked.connect(_on_enemy_leaked)
	
	var new_enemy = enemy_scene.instantiate()
	new_follow.add_child(new_enemy)
	
	new_enemy.health = new_enemy.base_health * pow(health_scaling, current_wave - 1)
	
	enemies_spawned += 1
	#print("Enemies Spawned: ", enemies_spawned)
	
	if enemies_spawned >= enemies_per_wave:
		$SpawnRate.stop()
		$WaveDelay.wait_time = wave_delay
		$WaveDelay.start()
	
func _on_enemy_leaked() -> void:
	enemy_leaked.emit()


func _on_wave_timer_timeout() -> void:
	if current_wave >= max_waves:
		return
	
	current_wave += 1
	print("Current_wave: ", current_wave)
	enemies_spawned = 0
	boss_spawned = false
	$SpawnRate.start()
	
func is_boss_wave() -> bool:
	return current_wave % 10 == 0
	
func spawn_boss() -> void:
	boss_spawned = true
	
	var new_follow = PathFollow2D.new()
	new_follow.set_script(preload("res://Scripts/path_follow_2d.gd"))
	
	add_child(new_follow)
	
	new_follow.enemy_leaked.connect(_on_enemy_leaked)
	
	var boss = boss_scene.instantiate()
	new_follow.add_child(boss)
	
	boss.died.connect(_on_boss_died)
	
	boss.health = boss.base_health * current_wave / 10.0
	
	$WaveDelay.wait_time = boss_wave_delay
	$WaveDelay.start()
	
func _on_boss_died() -> void:
	if current_wave == max_waves:
		game_won.emit()
