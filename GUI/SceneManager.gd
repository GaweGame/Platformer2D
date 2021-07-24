extends CanvasLayer

onready var screen = $ColorRect
onready var animation = $AnimationPlayer

func change_scene(path):
	layer = 10
	animation.play("transisi")
	yield(animation, "animation_finished")
	
	get_tree().change_scene(path)
	
	animation.play_backwards("transisi")
	yield(animation, "animation_finished")
	layer = 1
