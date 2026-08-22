extends Area2D

var target: Area2D
var damage: float = 0.0
@export var speed: float = 300.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		queue_free()
		return
	global_position = global_position.move_toward(
		target.global_position,
		speed * delta
	)

func _on_area_entered(area: Area2D) -> void:
	if area == target:
		target.take_damage(damage)
		queue_free()
