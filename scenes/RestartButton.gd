extends Button

func _pressed():
	print('pressed restart')
	Store.reset_game()
	
	get_tree().change_scene_to_file("res://Main.tscn")
