extends Area2D

export(int) var speed = 250
var arah = Vector2.ZERO

onready var sprite = $Sprite
onready var particle = $Particles2D

func _process(delta):
	translate(arah * speed * delta)

func _on_BolaMeriam_body_entered(body):
	if body.name == "Hero":
		body.terluka()
	speed = 0
	sprite.visible = false
	particle.emitting = true
	yield(get_tree().create_timer(particle.lifetime), "timeout")
	queue_free()
