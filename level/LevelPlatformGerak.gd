extends Node2D

func _on_DropZone_body_entered(body):
	get_tree().change_scene("res://level/LevelPlatformGerak.tscn")
