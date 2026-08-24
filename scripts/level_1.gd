extends Node2D

@onready var lasers: Node2D = $lasers
@onready var player: CharacterBody2D = $player

func _ready() -> void:
	player.connect("laser_shot", _on_player_laser_shoot)

func _on_player_laser_shoot(laser):
	lasers.add_child(laser)
