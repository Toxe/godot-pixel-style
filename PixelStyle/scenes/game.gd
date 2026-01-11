class_name Game extends Node2D

@onready var king: Sprite2D = $KingPath2D/PathFollow2D/King
@onready var king_path_follow: PathFollow2D = $KingPath2D/PathFollow2D
@onready var priest: Sprite2D = $PriestPath2D/PathFollow2D/Priest
@onready var priest_path_follow: PathFollow2D = $PriestPath2D/PathFollow2D

var king_speed := 0.1
var priest_speed := 1.0


func _process(delta: float) -> void:
    king_path_follow.progress_ratio += delta * king_speed
    priest_path_follow.progress += priest_speed

    queue_redraw()


func _draw() -> void:
    draw_line(Vector2(320, -360), Vector2(320, 2 * 360), Color.WHEAT)
    draw_line(Vector2(-640, 180), Vector2(2 * 640, 180), Color.WHEAT)
