class_name Game extends Node2D

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var camera: Camera2D = $Path2D/PathFollow2D/King/Camera2D


func _process(delta: float) -> void:
    path_follow.progress_ratio += delta * 0.01
    queue_redraw()


func _draw() -> void:
    draw_line(Vector2(320, -360), Vector2(320, 2 * 360), Color.WHEAT)
    draw_line(Vector2(-640, 180), Vector2(2 * 640, 180), Color.WHEAT)
