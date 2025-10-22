extends Node2D
# Escena que representa un arma abstracta. Todos los atributos tienen que ser definidos
# al momento de ser instanciada el arma.
@export_category("Propiedades de arma")
@export_file()
var SPRITE

@export
var SCALE := Vector2(1.0, 1.0)

@export
var BARREL_POS := Vector2(0.0, 105.0)

@export_category("Propiedades de bala")
@export_file
var BULLET_SPRITE

@export
var BULLET_SCALE := Vector2(0.5, 0.5)

@export
var BULLET_SPEED := 1.0

@export
var BULLET_LIFE := 1.0

var bullet:PackedScene

func _ready() -> void:
	bullet = preload("res://scenes/bullet.tscn")
	setup_attributes()

func setup_attributes() -> void:
	#Actualizar la textura y la escala de acuerdo a los atributos
	if SPRITE:
		var tex_resource := load(SPRITE)
		$WpnSprite.texture = tex_resource
		$WpnSprite.scale = SCALE
	
	$Barrel.position = BARREL_POS

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees -= 90
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var bullet_instance := bullet.instantiate()
		bullet_instance.SPRITE = BULLET_SPRITE
		bullet_instance.SCALE = BULLET_SCALE
		bullet_instance.SPEED = BULLET_SPEED
		var dir_vec:Vector2 = $Barrel.get_global_position().direction_to(get_global_mouse_position())
		bullet_instance.DIRECTION = dir_vec
		bullet_instance.LIFE = BULLET_LIFE
		bullet_instance.global_position = $Barrel.get_global_position()
		get_tree().root.add_child(bullet_instance)
	
