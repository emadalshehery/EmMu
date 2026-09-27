extends TileMapLayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if the entering body is the player (adjust the condition as needed)
	if body is CharacterBody2D:  # or use body.name == "Player" or body.is_in_group("player")
		# Trigger particles
		$"../Player/CharacterBody2D/AnimatedSprite2D".visible = false
		$"../Player/CharacterBody2D/CPUParticles2D".emitting = true
		
		# Reload the scene after a brief delay to see the particles
		await get_tree().create_timer(0.5).timeout
		get_tree().reload_current_scene()
