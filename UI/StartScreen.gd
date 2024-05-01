extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://gameScreens/trainingScene.tscn")


func _on_multiplayer_pressed():
	get_tree().change_scene_to_file("res://UI/MultiplayerConfig.tscn")
