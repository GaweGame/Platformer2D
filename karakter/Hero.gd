extends KinematicBody2D

var laju_cepat = 600
var laju_normal = 120
var laju = laju_normal
var kecepatan = Vector2.ZERO
var laju_lompat = -380
var gravitasi = 12
var koin = 0
var sedang_terluka = false
var health_maks = 50
var health = 50

export var bawa_pedang = false
var sedang_serang = false
var animasi_dengan_pedang = preload("res://karakter/HeroDenganPedang.tres")
var partikel_hero = preload("res://karakter/PartikelHero.tscn")

onready var sprite = $Sprite

signal hero_mati
signal hero_menang
signal hero_apdet_health(value)
signal hero_apdet_koin(value)

func _ready():
	if bawa_pedang:
		sprite.frames = animasi_dengan_pedang

func _input(event):
	if event is InputEventKey and event.is_action_pressed("serang") and bawa_pedang:
		sedang_serang = true
		sprite.play("Serang")
		yield(sprite, "animation_finished")
		sedang_serang = false

func _physics_process(delta):
	var is_jumping = false
	
	kecepatan.y = kecepatan.y + gravitasi
	
	if(not sedang_terluka and Input.is_action_pressed("gerak_kanan")):
		kecepatan.x = laju
	if(not sedang_terluka and Input.is_action_pressed("gerak_kiri")):
		kecepatan.x = -laju
	
	if(not sedang_terluka and Input.is_action_just_pressed("lari_cepat")):
		lari_cepat()
	
	if(not sedang_terluka and Input.is_action_pressed("lompat") and is_on_floor()):
		if not is_jumping and Input.is_action_pressed("turun"):
			position.y += 1
		else:
			keluarkan_partikel("lompat")
			kecepatan.y = laju_lompat
			is_jumping = true
	
	var snap = Vector2.ZERO if is_jumping else (Vector2.DOWN * 8)
	
	var kecepatan_jatuh = kecepatan.y
	
	kecepatan.x = lerp(kecepatan.x, 0, 0.2)
	kecepatan = move_and_slide_with_snap(kecepatan, snap, Vector2.UP)
	
	if kecepatan.y - kecepatan_jatuh < -gravitasi:
		keluarkan_partikel("jatuh")
	
	if not sedang_terluka and not sedang_serang:
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
#	print(" KOIN: ", koin)
	emit_signal("hero_apdet_koin", koin)
	# Cek jumlah koin
	var grup_koin = get_tree().get_nodes_in_group("GrupKoin")
	var jumlah_koin = grup_koin.size()
	print(" GRUP KOIN: ", grup_koin)
	print(" JUMLAH: ", jumlah_koin)
	# Kalau habis, panggil signal hero_menang
	if jumlah_koin == 0:
		emit_signal("hero_menang")

func terluka():
	sedang_terluka = true
	
	health -= 15
	emit_signal("hero_apdet_health", (float(health)/float(health_maks)) * 100)
	
	if kecepatan.x > 0:
		kecepatan.x = -500
	else:
		kecepatan.x = 500
	
	sprite.play("Terluka")
	yield(get_tree().create_timer(1), "timeout")
	
	if health <= 0:
		mati()
	else:
		sedang_terluka = false

func mati():
	sprite.play("Mati")
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(2, false)
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("hero_mati")

func ambil_pedang():
	if not bawa_pedang:
		bawa_pedang = true
		sprite.frames = animasi_dengan_pedang

func keluarkan_partikel(jenis):
	var _partikel_hero = partikel_hero.instance()
	_partikel_hero.play(jenis)
	_partikel_hero.flip_h = sprite.flip_h
	_partikel_hero.global_position = global_position
	get_tree().current_scene.add_child(_partikel_hero)


func _on_Sprite_frame_changed():
	if sprite.animation == "Lari" and sprite.frame == 2:
		keluarkan_partikel("lari")
