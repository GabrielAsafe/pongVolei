extends CharacterBody2D

@onready var player = $"."

const speed = 1000
var score:int = 0
#signal _marcarPontos(score)

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())#faz com que cada player seja seu próprio multiplayerAuthority. assim os movimentos que ele fizer só vao ser refletidos nele mesmo

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * speed

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		get_input()
		move_and_slide()
		if player.get_last_slide_collision():
			score +=1
			#emit_signal("_marcarPontos",score)
