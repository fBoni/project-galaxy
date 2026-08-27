extends CharacterBody2D

#signal laser_shot(laser) #sinal não é mais necessário

@export var acceleration:float = 10.0
@export var max_speed:float = 300.0
@export var rotation_speed:float = 250.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var muzzle: Node2D = $Muzzle

var laser_scene = preload("res://scenes/laser.tscn")

func _process(delta: float) -> void:
	#if Input.is_action_pressed("shoot"):
	if Input.is_action_just_pressed("shoot"):
		shoot_laser()

func _ready() -> void:
	animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.UP if Input.is_action_pressed("move_forward") else Vector2.ZERO
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	
	if Input.is_action_pressed("move_forward"):
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
		
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	
	move_and_slide()
	
	#Teletransporta a nave para o outro lado ao sair da tela
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
		
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
		
func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	get_tree().current_scene.add_child(l)
	
	
	
