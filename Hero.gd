extends KinematicBody2D

var laju = 120
var kecepatan = Vector2.ZERO
var laju_lompat = -380
var gravitasi = 12

func _physics_process(delta):
	kecepatan.y = kecepatan.y + gravitasi
	
	if(Input.is_action_pressed("gerak_kanan")):
		kecepatan.x = laju
	if(Input.is_action_pressed("gerak_kiri")):
		kecepatan.x = -laju
	
	if(Input.is_action_pressed("lompat") and is_on_floor()):
		kecepatan.y = laju_lompat
	
	print(kecepatan.y)
	kecepatan.x = lerp(kecepatan.x, 0, 0.2)
	kecepatan = move_and_slide(kecepatan, Vector2.UP)
