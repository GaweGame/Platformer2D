extends KinematicBody2D

var gravitasi = 12
var laju = 20
var kecepatan = Vector2.ZERO
export var arah = 1

func _ready():
	pass

func _physics_process(delta):
	kecepatan.y += gravitasi
	
	if is_on_wall():
		arah = arah * -1
	
	kecepatan.x = laju * arah
	
	kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	_update_animasi()

func _update_animasi():
	if is_on_floor():
		$AnimatedSprite.play("lari")
	else:
		$AnimatedSprite.play("jatuh")
	$AnimatedSprite.flip_h = true
	if arah == -1:
		$AnimatedSprite.flip_h = false
