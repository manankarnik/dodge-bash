extends Control

@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	score_label.text = "Score: " + str(Global.score)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
