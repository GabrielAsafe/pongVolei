extends  "res://gameScreens/Game.gd" 



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_down():
	create_game()


func _on_join_button_down():
	join_game("127.0.0.1")


func _on_play_button_down():
	load_game.rpc("res://UI/MultiplayerConfig.tscn")
