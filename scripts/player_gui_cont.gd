extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var health := PlayerData.get_player_health()
	$HealthBar/Numero.text = str(health)
	if health < 1:
		$Retry.visible = true


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/glacier.tscn")
