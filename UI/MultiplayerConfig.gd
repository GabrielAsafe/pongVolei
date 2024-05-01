extends  Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_host_button_down():
	var valor = Game.create_game()
	#print("aguardando jogadores")
	
	if valor != null:
		$Panel/Label.text = "Servidor já criado no pi " + Game.DEFAULT_SERVER_IP
		
	
func _on_join_button_down():
	Game.join_game()
	


func _on_play_button_down():
	Game.player_loaded.rpc()
	Game.load_game.rpc("res://gameScreens/MultiplayerGame.tscn")
	
	
	
