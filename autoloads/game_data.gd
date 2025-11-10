extends Node

var player_pos := Vector2(0, 0)
var player_health := 5

func get_player_pos() -> Vector2:
	return player_pos
	
func set_player_pos(pos:Vector2) -> void:
	player_pos = pos
	
func get_player_health() -> int:
	return player_health

func set_player_health(health:int) -> void:
	player_health = health
