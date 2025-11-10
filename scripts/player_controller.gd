extends CharacterBody2D

@export_category("Variables de movimiento")
@export
var SPEED = 300.0

@export
var HEALTH := 5

var shmoovin := false
var livin := true

func _ready() -> void:
	PlayerData.set_player_health(HEALTH)

func _process(_delta: float) -> void:
	#Flipear el sprite de armando si el mouse está a la izq.
	if global_position.x - get_global_mouse_position().x < 0:
		$CharSprite.flip_h = false
	else:
		$CharSprite.flip_h = true
	
	#Controlar el audioplayer de los pasos
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		$AudioPlayer.stream_paused = false
	else:
		$AudioPlayer.stream_paused = true
	
	#Los autoloads son utiles para guardar el estado
	#actual de algun nodo en un lugar donde sea accesible por todos
	#en este caso, esto permite que los yetis siempre sepan la ubicacion del jugador
	PlayerData.set_player_pos(global_position)
	
	if HEALTH < 1 and livin:
		$Hurt.play("deady")
		livin = false
		$CharSprite/Arm.queue_free()
		set_collision_layer_value(1, false)

	

func _physics_process(_delta: float) -> void:
	# Para mover un CharacterBody solo hace falta calcular "velocity"
	# antes de llamar move_and_slide(). Este cálculo depende de la naturaleza del juego
	# (plataformero, top-down, shoot-em-up, isométrico...).
	# Investiga sobre el tipo de juego que quieras hacer!!!! :)
	if HEALTH > 0:
		var up_down_dir := Input.get_axis("move_up", "move_down")
		var left_right_dir := Input.get_axis("move_left", "move_right")
		
		if up_down_dir:
			velocity.y = SPEED*up_down_dir
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
		if left_right_dir:
			velocity.x = SPEED*left_right_dir
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if up_down_dir or left_right_dir:
			$AnimPlayer.queue("walk")
		else:
			$AnimPlayer.play("RESET")
		
		velocity = velocity.limit_length(SPEED*1.3)
	else:
		velocity = Vector2(0, 0)
	move_and_slide()

func get_hit() -> void:
	HEALTH -= 1
	PlayerData.set_player_health(HEALTH)
	$Hurt.play("hurty")
	
