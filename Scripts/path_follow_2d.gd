extends PathFollow2D

signal enemy_leaked

@export var speed: float = 100.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#print("Path follow create", get_instance_id())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += speed * delta
	

	if progress_ratio >= .99:
		enemy_leaked.emit()
		queue_free()
