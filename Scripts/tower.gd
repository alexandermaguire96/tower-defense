extends Node2D

@onready var sprite = $Sprite2D
var glow: Sprite2D

@export var projectile_scene: PackedScene

@export var tower_type: String = "basic"
@export var tier: int = 1

@export var attack_speed: float = 1.0
@export var attack_damage: float = 50.0
@export var crit_chance: float =  0.0
@export var crit_damage: float =  150.0
@export var tower_range: float =  2.0
@export var base_range: float = 100.0


var enemies_in_range = []
var target = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.shape.radius = tower_range * base_range
	
	setup_glow()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	enemies_in_range.append(area)
	update_target()
	
func _on_area_2d_area_exited(area: Area2D) -> void:
		enemies_in_range.erase(area)
		
		if target == area:
			target = null
			
		update_target()
		#print("Target left range")
		
func update_target() -> void:
	if enemies_in_range.is_empty():
		target = null
		$AttackTimer.stop()
		return
	
	var furthest_enemy = enemies_in_range[0]
	var highest_progress = furthest_enemy.get_parent().progress_ratio
	
	for enemy in enemies_in_range:
		var progress = enemy.get_parent().progress_ratio
		
		if progress > highest_progress:
			highest_progress = progress
			furthest_enemy = enemy
		
	target = furthest_enemy
	
	if $AttackTimer.is_stopped():
		$AttackTimer.start()
		
	#print("Target: ", target.name, " Progress: ", highest_progress)
		

func _on_attack_timer_timeout() -> void:
	if target == null:
		$AttackTimer.stop()
		return
		
	if not is_instance_valid(target):
		target = null
		$AttackTimer.stop()
		return
		
	attack(target)

@warning_ignore("shadowed_variable")
func attack(target):
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)

	projectile.global_position = global_position
	projectile.target = target
	projectile.damage = attack_damage
	
func setup_glow() -> void:
	if tier == 1:
		return 
		
	glow = Sprite2D.new()
	glow.texture = sprite.texture
	glow.show_behind_parent = true
	glow.scale = sprite.scale * 1.15
	add_child(glow)

	match tier:
		2:
			glow.modulate = Color.GREEN
		3:
			glow.modulate = Color.BLUE
		4:
			glow.modulate = Color.MEDIUM_PURPLE
		5:
			glow.modulate = Color.RED
		
			
