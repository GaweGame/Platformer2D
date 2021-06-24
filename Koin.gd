extends Area2D

func _on_Koin_body_entered(body):
	if body.name == 'Hero':
		body.ambil_koin()
	var _efekkoin = preload("res://EfekKoin.tscn")
	var efekkoin = _efekkoin.instance()
	efekkoin.transform = self.transform
	get_tree().current_scene.add_child(efekkoin)
	queue_free()
