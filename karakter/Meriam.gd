extends KinematicBody2D

enum ARAH { KIRI = -1, KANAN = 1 }
export(ARAH) var arah = -1

onready var sprite = $Sprite
onready var animtree = $AnimationTree
onready var raycast = $RayCast2D

onready var statemachine = animtree["parameters/playback"]

onready var bola = preload("res://karakter/BolaMeriam.tscn")

func _ready():
	cek_arah()

func _process(delta):
	var current_statemachine = statemachine.get_current_node()
	var is_diam = current_statemachine == "Diam"
	var is_colliding = raycast.is_colliding()
	
#	print(" STATE MACHINE: ", statemachine, " COLLIDING: ", is_colliding)
	
	if is_diam and is_colliding:
		statemachine.travel("Tembak")

func tembak():
	var _bola = bola.instance()
	_bola.global_position = $Position2D.global_position
	get_tree().current_scene.add_child(_bola)
	if arah == ARAH.KIRI:
		_bola.arah = Vector2.LEFT
	else:
		_bola.arah = Vector2.RIGHT

func cek_arah():
	if arah == ARAH.KIRI:
		sprite.flip_h = false
		raycast.scale.x = 1
	else:
		sprite.flip_h = true
		raycast.scale.x = -1
