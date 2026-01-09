class_name Game extends Node2D

@onready var camera: Camera2D = $Path2D/PathFollow2D/King/Camera2D
@onready var king: Sprite2D = $Path2D/PathFollow2D/King
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

var king_speed := 0.1


func _process(delta: float) -> void:
    path_follow.progress_ratio += delta * king_speed
    queue_redraw()


func _draw() -> void:
    draw_line(Vector2(320, -360), Vector2(320, 2 * 360), Color.WHEAT)
    draw_line(Vector2(-640, 180), Vector2(2 * 640, 180), Color.WHEAT)
