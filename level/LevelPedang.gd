extends Node2D

onready var hero = $Hero
onready var pedang = $Pedang

func _on_Pedang_body_entered(body):
	if body.name == "Hero":
		pedang.queue_free()
		hero.ambil_pedang()
