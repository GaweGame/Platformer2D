extends AnimatedSprite

func _on_PartikelHero_animation_finished():
	queue_free()
