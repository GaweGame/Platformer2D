extends KinematicBody2D

var laju_cepat = 600
var laju_normal = 120
var laju = laju_normal
var kecepatan = Vector2.ZERO
var laju_lompat = -380
var gravitasi = 12
var koin = 0
var sedang_terluka = false

onready var sprite = $Sprite

func _physics_process(delta):
	kecepatan.y = kecepatan.y + gravitasi
	
	if(not sedang_terluka and Input.is_action_pressed("gerak_kanan")):
		kecepatan.x = laju
	if(not sedang_terluka and Input.is_action_pressed("gerak_kiri")):
		kecepatan.x = -laju
	
	if(not sedang_terluka and Input.is_action_just_pressed("lari_cepat")):
		lari_cepat()
	
	if(not sedang_terluka and Input.is_action_pressed("lompat") and is_on_floor()):
		kecepatan.y = laju_lompat
	
	kecepatan.x = lerp(kecepatan.x, 0, 0.2)
	kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	if not sedang_terluka:
		update_animasi()

func update_animasi():
	if is_on_floor():
		if kecepatan.x < (laju * 0.5) and kecepatan.x > (-laju * 0.5):
			sprite.play("Diam")
		else:
			if laju == laju_normal:
				sprite.play("Lari")
			elif laju == laju_cepat:
				sprite.play("LariCepat")
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

func lari_cepat():
	laju = laju_cepat
	$Timer.start()

func _on_Timer_timeout():
	laju = laju_normal


func ambil_koin():
	koin = koin + 1
	print(" KOIN: ", koin)


func terluka():
	sedang_terluka = true
	sprite.play("Terluka")
	if kecepatan.x > 0:
		kecepatan.x = -500
	else:
		kecepatan.x = 500
	yield(get_tree().create_timer(1), "timeout")
	sedang_terluka = false
