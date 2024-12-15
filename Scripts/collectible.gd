extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const PICKUP = preload("res://Assets/pickup.wav")

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		body.shield = true
		body.shield_sprite.visible = true
		body.shield_timer.start()
		audio_stream_player_2d.stream = PICKUP
		audio_stream_player_2d.play()
		visible = false
		


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
