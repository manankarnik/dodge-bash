extends Node2D

@onready var enemy_spawn_rate: Timer = $EnemySpawnRate
@onready var enemy_spawn_location: PathFollow2D = $EnemySpawnPath/EnemySpawnLocation
@onready var collectible_spawn_rate: Timer = $CollectibleSpawnRate
@onready var collectible_despawn_rate: Timer = $CollectibleDespawnRate
@onready var score_timer: Timer = $ScoreTimer
@onready var score_label: Label = $ScoreLabel

const ENEMY = preload("res://Scenes/enemy.tscn")
const COLLECTIBLE = preload("res://Scenes/collectible.tscn")


func _ready() -> void:
	randomize()
	Global.score = 0
	collectible_spawn_rate.start()

func _on_enemy_spawn_rate_timeout() -> void:
	var enemy  := ENEMY.instantiate()
	enemy_spawn_location.progress_ratio = randf()
	var direction := (enemy_spawn_location.rotation + PI / 2) + randf_range(-PI / 4, PI / 4)
	enemy.position = enemy_spawn_location.position
	add_child(enemy)
	enemy.rotation = direction
	enemy.velocity = Vector2.RIGHT.rotated(direction) * randf_range(200, 300)
	enemy.move_and_slide()



func _on_collectible_spawn_rate_timeout() -> void:
	var collectible = COLLECTIBLE.instantiate()
	var screen_size = get_viewport_rect().size
	collectible.position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
	add_child(collectible)
	collectible_despawn_rate.start()
	collectible_spawn_rate.wait_time = randf_range(3, 5)
	collectible_spawn_rate.start()


func _on_collectible_despawn_rate_timeout() -> void:
	if $Collectible: $Collectible.queue_free()


func _on_score_timer_timeout() -> void:
	Global.score += 1
	score_label.text = "Score: " + str(Global.score)
