extends Node2D
# Escena que representa un arma abstracta. Todos los atributos 
# exportados tienen que ser definidos
# al momento de ser instanciada el arma.

# Esta configuración abstracta facilita la posible implementación de
# distintos tipos de armas. Los datos solo tendrían que ser leidos de un archivo
# JSON en el momento de ser necesario instanciar el arma.
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
@export
var SHOT_RATE := 1.0

var bullet:PackedScene
var can_shoot := true
var rate_mod := 1.0

func _ready() -> void:
	bullet = preload("res://scenes/bullet.tscn")
	setup_attributes()

func setup_attributes() -> void:
	# Reemplazar los placeholders del arma con los datos definidos en los atributos.
	if SPRITE:
		var tex_resource := load(SPRITE)
		$WpnSprite.texture = tex_resource
		$WpnSprite.scale = SCALE
	
	$Barrel.position = BARREL_POS
	$ShotTimer.wait_time = SHOT_RATE

func _process(_delta: float) -> void:
	# Rotar el brazo alrededor del eje del sprite del jugador
	look_at(get_global_mouse_position())
	# Offset porque godot cosas
	rotation_degrees -= 90
	
	# Disparar: Instanciar escena "Bullet" y configurarla antes de ser añadida al arbol.
	# Luego esperar a poder volver a disparar. Obvio problema de escalabilidad!
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if can_shoot:
			# "Cada arma sabe qué bala dispara." (es cine)
			var bullet_instance := bullet.instantiate()
			bullet_instance.SPRITE = BULLET_SPRITE
			bullet_instance.SCALE = BULLET_SCALE
			bullet_instance.SPEED = BULLET_SPEED
			var dir_vec:Vector2 = $Barrel.get_global_position().direction_to(get_global_mouse_position())
			bullet_instance.DIRECTION = dir_vec
			bullet_instance.LIFE = BULLET_LIFE
			bullet_instance.global_position = $Barrel.get_global_position()
			get_tree().root.add_child(bullet_instance)
			
			# Manejo de animación: se obliga al animador a resetar antes de disparar.
			# Esto se hace para interrumpir una animación
			# Transiciones más complejas requieren del uso de un AnimationTree (basicamente magia oscura)
			$AnimWpn.play("RESET")
			$AnimWpn.play("shoot")
			#$AnimWpn.advance(0)
			can_shoot = false
			$ShotTimer.start(SHOT_RATE*rate_mod)
		
	
	

#Señal conectada del Timer "ShotTimer"
func _on_shot_timer_timeout() -> void:
	can_shoot = true
