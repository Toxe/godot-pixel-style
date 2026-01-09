class_name GUI extends Control

@export var camera: Camera2D
@export var texture_rect: TextureRect
@export var king: Sprite2D

@onready var camera_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/CameraLabel
@onready var texture_rect_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer2/TextureRectLabel
@onready var king_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer3/KingLabel


func _process(_delta: float) -> void:
    camera_label.text = "%s\n%s\n%s" % [format_vector(camera.get_target_position()), format_vector(camera.get_screen_center_position()), format_vector(camera.get_screen_transform().origin)]
    texture_rect_label.text = "%s\n%s" % [format_vector(texture_rect.get_canvas_transform().origin), format_vector(texture_rect.get_screen_transform().origin)]
    king_label.text = "%s\n%s" % [format_vector(king.global_position), format_vector(king.get_screen_transform().origin)]
    queue_redraw()


func _draw() -> void:
    draw_line(Vector2(320, -360), Vector2(320, 2 * 360), Color.WHEAT)
    draw_line(Vector2(-640, 180), Vector2(2 * 640, 180), Color.WHEAT)

    var cam_delta := camera.get_target_position() - camera.get_screen_center_position()
    draw_circle(camera.get_screen_transform().origin, 10, Color.TURQUOISE, false, 2)
    draw_circle(camera.get_screen_transform().origin - cam_delta, 10, Color.PURPLE, false, 2)


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_gui"):
        visible = !visible


func format_vector(vec: Vector2) -> String:
    return "%.2f / %.2f" % [vec.x, vec.y]
