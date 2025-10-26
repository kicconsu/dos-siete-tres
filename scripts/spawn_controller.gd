extends Area2D

# Manejar el instanciamiento de enemigos. 
#    Cada Timeout, samplear un punto random, aparecer un enemigo ahi y decidir un nuevo tiempo para el timer
#    Si un enemigo se sale de el area de DespawnEnemies, este desaparece

@export
var SAFE_ZONE := 1000.0

@export
var INVERSE_SPAWN_RATE:float = 1

@onready
var SPAWN_RADIUS:float = $DespawnEnemies/CollisionShape2D.shape.radius
@onready
var TIMER:Timer = $TimerSpawn
var RUNNER_SCENE := preload("res://scenes/runner.tscn")

func spawn_on_random() -> void:
	var magnitude := randf_range(SAFE_ZONE, SPAWN_RADIUS) # Distancia
	var angle := randf_range(0, 1.9*PI) # Angulo
	
	var spawn_vec := Vector2(1.0, 0)*magnitude
	spawn_vec = spawn_vec.rotated(angle)
	
	#Decide cual enemigo va a aparecer
	#var enemy_type := bool(randi_range(0, 1))
	var enemy_type = true
	var enemy_instance:Node
	if enemy_type:
		enemy_instance = RUNNER_SCENE.instantiate()
		enemy_instance.SPEED = randf_range(2, 20)
	else:
		enemy_instance = RUNNER_SCENE.instantiate()
	
	#El spawn handler asume que siempre sigue la posición del jugador.
	#Por esto, la posicion del enemigo a aparecer es solo una suma vectorial:
	enemy_instance.global_position = global_position+spawn_vec
	get_tree().root.add_child(enemy_instance)
	
func _on_timer_spawn_timeout() -> void:
	spawn_on_random()
	TIMER.start(INVERSE_SPAWN_RATE*randf_range(0.05, 1.5))


func _on_despawn_enemies_area_exited(area: Area2D) -> void:
	area.queue_free()
