extends CharacterBody2D
class_name Player

@onready var shield_timer: Timer = $ShieldTimer
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

const EXPLOSION = preload("res://Assets/explosion.wav")
const HURT = preload("res://Assets/hurt.wav")
const BASH = preload("res://Assets/bash.wav")
const SPEED := 800.0

var shield := false
var collided := false

func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")
	).normalized()
	
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction.y:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision and not collided:
		if is_instance_of(collision.get_collider(), Enemy):
			collided = true
			if shield:
				shield_sprite.visible = false
				collision.get_collider().queue_free()
				shield = false
				shield_timer.stop()
				Global.score += 5
				if not audio_stream_player_2d.is_playing():
					audio_stream_player_2d.stream = EXPLOSION
					audio_stream_player_2d.play()
					audio_stream_player_2d_2.stream = BASH
					audio_stream_player_2d_2.play()
					
			elif not audio_stream_player_2d.is_playing():
				audio_stream_player_2d.stream = HURT
				audio_stream_player_2d.play()


func _on_shield_timer_timeout() -> void:
	shield_sprite.visible = false
	shield = false


func _on_audio_stream_player_2d_finished() -> void:
	collided = false
	if audio_stream_player_2d.stream == HURT:
		queue_free()
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
