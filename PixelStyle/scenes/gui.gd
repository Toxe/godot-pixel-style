class_name GUI extends Control

@export var camera: Camera2D
@export var texture_rect: TextureRect
@export var king: Sprite2D


func _process(_delta: float) -> void:
    var cam_delta := camera.get_target_position() - camera.get_screen_center_position()
    ($CameraLabel as Label).text = "Camera: target_position: %s\nscreen_center_position: %s\ndelta: %s\nscreen_transform: %s" % [camera.get_target_position(), camera.get_screen_center_position(), cam_delta, camera.get_screen_transform().origin]
    ($TextureRectLabel as Label).text = "TextureRect: %s\n%s" % [texture_rect.get_canvas_transform().origin, texture_rect.get_screen_transform().origin]
    ($KingLabel as Label).text = "King: %s\n%s\n%s" % [king.global_position, king.global_transform.origin, king.get_screen_transform().origin]
    queue_redraw()


func _draw() -> void:
    draw_line(Vector2(320, -360), Vector2(320, 2 * 360), Color.WHEAT)
    draw_line(Vector2(-640, 180), Vector2(2 * 640, 180), Color.WHEAT)

    var cam_delta := camera.get_target_position() - camera.get_screen_center_position()
    draw_circle(camera.get_screen_transform().origin, 10, Color.TURQUOISE, false, 2)
    draw_circle(camera.get_screen_transform().origin - cam_delta, 10, Color.PURPLE, false, 2)
