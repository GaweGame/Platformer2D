extends Node2D

onready var health_progress = $CanvasLayer/HealthBar/TextureProgress
onready var jumlah_koin = $CanvasLayer/CoinBar/Label

func _on_ZonaJatuh_body_entered(body):
	if body.name == 'Hero':
		get_tree().change_scene("res://Level1.tscn")


func _on_Hero_hero_apdet_health(value):
	health_progress.value = value


func _on_Hero_hero_apdet_koin(value):
	jumlah_koin.text = String(value)
