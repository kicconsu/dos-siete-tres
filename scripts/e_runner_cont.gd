extends Area2D

@export
var SPEED:float = 2

@onready
var ANIM_YETI:AnimationPlayer = $AnimYeti

var actual_speed:float = 0.0
var caution_cutoff:float = 1e6 
#true: derecha, false: izq
var flipped:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animator:AnimationPlayer = ANIM_YETI
	animator.speed_scale *= (SPEED+10)/20
	animator.play("walk")


func _process(_delta: float) -> void:
	var look_to_player := PlayerData.get_player_pos()-global_position
	if look_to_player.x > 0:
		if not flipped:
			ANIM_YETI.play("look_around")
			ANIM_YETI.queue("walk")
			flipped = !flipped
		$SpriteEnemy.flip_h = true
	else:
		if flipped:
			ANIM_YETI.play("look_around")
			ANIM_YETI.queue("walk")
			flipped = !flipped
		$SpriteEnemy.flip_h = false
	
	var dist_to_player := look_to_player.length_squared()
	if dist_to_player > caution_cutoff:
		actual_speed = SPEED
	else: #Reducir la velocidad en la medida que el jugador se acerque al enemigo
		actual_speed = SPEED * dist_to_player/caution_cutoff
	
	var direction:Vector2 = look_to_player.normalized()
	var move_vec := actual_speed*direction
	position += move_vec
