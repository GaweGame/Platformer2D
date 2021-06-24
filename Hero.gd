extends KinematicBody2D

var laju = 120
var kecepatan = Vector2.ZERO
var laju_lompat = -380
var gravitasi = 12

onready var sprite = $Sprite

func _physics_process(delta):
	kecepatan.y = kecepatan.y + gravitasi
	
	if(Input.is_action_pressed("gerak_kanan")):
		kecepatan.x = laju
	if(Input.is_action_pressed("gerak_kiri")):
		kecepatan.x = -laju
	
	if(Input.is_action_pressed("lompat") and is_on_floor()):
		kecepatan.y = laju_lompat
	
	kecepatan.x = lerp(kecepatan.x, 0, 0.2)
	kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	update_animasi()

func update_animasi():
	if is_on_floor():
		if kecepatan.x < (laju * 0.5) and kecepatan.x > (-laju * 0.5):
			sprite.play("Diam")
		else:
			sprite.play("Lari")
	else:
		if kecepatan.y > 0:
			# jatuh
			sprite.play("Jatuh")
		else:
			# lompat
			sprite.play("Lompat")
	
	sprite.flip_h = false
	if kecepatan.x < 0:
		sprite.flip_h = true





