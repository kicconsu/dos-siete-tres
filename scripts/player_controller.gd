extends CharacterBody2D

@export_category("Variables de movimiento")
@export
var SPEED = 300.0

func _process(_delta: float) -> void:
	#Flipear el sprite de armando si el mouse está a la izq.
	if global_position.x - get_global_mouse_position().x < 0:
		$CharSprite.flip_h = false
	else:
		$CharSprite.flip_h = true

func _physics_process(_delta: float) -> void:
	# Para mover un CharacterBody solo hace falta calcular "velocity"
	# antes de llamar move_and_slide(). Este cálculo depende de la naturaleza del juego
	# (plataformero, top-down, shoot-em-up, isométrico...).
	# Investiga sobre el tipo de juego que quieras hacer!!!! :)
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
	
	velocity = velocity.limit_length(SPEED*1.3)
	
	move_and_slide()
	
