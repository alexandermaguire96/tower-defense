extends Area2D

@export var base_health := 100.0
var health := 100.0

func take_damage(amount: float) -> void:
	health -= amount
	print("Enemy Health: ", health)
	
	if health <= 0:
		die()
		
func die() -> void:
	print("Enemy died")
	get_tree().current_scene.add_coins(10)
	get_parent().queue_free()
	
