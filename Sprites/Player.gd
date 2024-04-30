extends CharacterBody2D

@onready var player = $"."
const speed = 1000
var score:int = 0
#signal _marcarPontos(score)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	if player.get_last_slide_collision():
		score +=1
		#emit_signal("_marcarPontos",score)
