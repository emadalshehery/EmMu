# a light bob so the trophy reads as something to pick up, not level dressing
extends Area2D
 
# a light bob so the trophy reads as something to pick up, not level dressing
@export var bob_speed = 2.0
@export var bob_height = 4.0
 
var _start_y = 0.0
var _time = 0.0
var _collected = false
 
func _ready() -> void:
	if Abilities.has_wall_jump:
		queue_free()
		return
	_start_y = position.y
	body_entered.connect(_on_body_entered)
 
func _process(delta: float) -> void:
	if _collected:
		return
	_time += delta
	position.y = _start_y + sin(_time * bob_speed) * bob_height
 
func _on_body_entered(body: Node) -> void:
	if _collected:
		return
	if body.has_method("grant_wall_jump"):
		_collected = true
		body.grant_wall_jump()
		queue_free()
