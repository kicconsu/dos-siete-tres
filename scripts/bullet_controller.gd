extends Area2D

@export_category("Parámetros de bala")

#Categoria 1: Bala amistosa, Categoria 2: Bala enemiga
@export_range(1, 2, 1)
var CATEGORY := 1

@export_file()
var SPRITE

@export
var SCALE := Vector2(0.5, 0.5)

@export
var SPEED := 0.0

@export
var LIFE := 0.0

@export
var DIRECTION := Vector2(0, 1)

func _ready() -> void:
	upd8_graphics()
	$LifeTimer.wait_time = LIFE
	$LifeTimer.start()
	

func upd8_graphics() -> void:
	if SPRITE:
		var tex_resource := load(SPRITE)
		$BulletSprite.texture = tex_resource
		$BulletSprite.scale = SCALE
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var move_vec := SPEED*DIRECTION
	
	position += move_vec


func _on_life_timer_timeout() -> void:
	self.queue_free()
