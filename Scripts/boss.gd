extends Area2D

signal died
@export var base_health := 1000.0


var health := 1000.0

func _process(_delta):
	global_rotation = 0
	
func take_damage(amount: float) -> void:
	health -= amount
	print("Boss Health: ", health)

	if health <= 0:
		die()

func die() -> void:
	print("Boss died")
	died.emit()
	get_parent().queue_free()
