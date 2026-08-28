#Asteroid
class_name Asteroid extends Area2D

signal exploded(pos, size)

var movement_vector = Vector2(0, -1)

enum AsteroidSize{LARGE, MEDIUM, SMALL}
@export var size = AsteroidSize.LARGE

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var speed: float = 50.0

func _ready() -> void:
	rotation = randf_range(0, 2*PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			sprite_2d.texture = preload("res://asteroids/asteroid_big1.png")
			collision_shape_2d.set_deferred("shape", preload("res://resources/asteroids_cshape_large.tres"))
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 150)
			sprite_2d.texture = preload("res://asteroids/asteroid_medium1.png")
			collision_shape_2d.set_deferred("shape", preload("res://resources/asteroids_cshape_medium.tres"))
		AsteroidSize.SMALL:
			speed = randf_range(100, 200)
			sprite_2d.texture = preload("res://asteroids/asteroid_small1.png")
			collision_shape_2d.set_deferred("shape", preload("res://resources/asteroids_cshape_small.tres"))

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = collision_shape_2d.shape.radius
	var screen_size = get_viewport_rect().size
	if (global_position.y+radius) < 0:
		global_position.y = (screen_size.y+radius)
	elif (global_position.y-radius) > screen_size.y:
		global_position.y = -radius
		
	if (global_position.x+radius) < 0:
		global_position.x = (screen_size.x+radius)
	elif (global_position.x-radius) > screen_size.x:
		global_position.x = -radius
		
func explode():
	emit_signal("exploded", global_position, size)
	queue_free()
