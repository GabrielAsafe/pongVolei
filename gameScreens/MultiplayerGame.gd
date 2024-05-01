extends Node2D

@export var PlayerScene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in Game.players:#corre no vetor de players
		var currentPlayer = PlayerScene.instantiate()# diz que current player é do tipo que foi passado por parâmetro no export
		currentPlayer.name = str(i)#quando se trata de um dicionário, se eu pegar o i é a key, se eu pegar o i[x] é o value e nesse caso o game.palyers guarda essa merda
		add_child(currentPlayer)#adiciona o player na raiz do nó mas poderia definir um nó para ser pai dele

		if i == 0:
			currentPlayer.global_position = $"playerSpawn/0".position #martelado e fds
		elif i == 1:
			currentPlayer.global_position = $"playerSpawn/1".position

		index +=1

		
		
