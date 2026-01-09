class_name GUI extends Control

@export var game: Game
@export var texture_rect: TextureRect

@onready var camera_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/CameraLabel
@onready var texture_rect_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer2/TextureRectLabel
@onready var king_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer3/KingLabel


func _process(_delta: float) -> void:
    camera_label.text = "%s\n%s\n%s" % [format_vector(game.camera.get_target_position()), format_vector(game.camera.get_screen_center_position()), format_vector(game.camera.get_screen_transform().origin)]
    texture_rect_label.text = "%s\n%s" % [format_vector(texture_rect.get_canvas_transform().origin), format_vector(texture_rect.get_screen_transform().origin)]
    king_label.text = "%s\n%s" % [format_vector(game.king.global_position), format_vector(game.king.get_screen_transform().origin)]
    queue_redraw()


func _draw() -> void:
    draw_line(Vector2(320, -360), Vector2(320, 2 * 360), Color.WHEAT)
    draw_line(Vector2(-640, 180), Vector2(2 * 640, 180), Color.WHEAT)

    var cam_delta := game.camera.get_target_position() - game.camera.get_screen_center_position()
    draw_circle(game.camera.get_screen_transform().origin, 10, Color.TURQUOISE, false, 2)
    draw_circle(game.camera.get_screen_transform().origin - cam_delta, 10, Color.PURPLE, false, 2)


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_fullscreen"):
        if DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
        else:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
    elif event.is_action_pressed("toggle_gui"):
        visible = !visible
    elif event.is_action_pressed("quit"):
        get_tree().quit()


func format_vector(vec: Vector2) -> String:
    return "%.2f / %.2f" % [vec.x, vec.y]
