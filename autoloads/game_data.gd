extends Node

var player_pos := Vector2(0, 0)

func get_player_pos() -> Vector2:
	return player_pos
	
func set_player_pos(pos) -> void:
	player_pos = pos
