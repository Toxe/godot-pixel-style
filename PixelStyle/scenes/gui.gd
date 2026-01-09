class_name GUI extends Control

@export var game: Game
@export var texture_rect: TextureRect

@onready var camera_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/CameraLabel
@onready var texture_rect_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer2/TextureRectLabel
@onready var king_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer3/KingLabel
@onready var king_speed_slider: HSlider = $HBoxContainer/VBoxContainer/HBoxContainer4/KingSpeedSlider
@onready var king_speed_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer4/KingSpeedLabel
@onready var window_size_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer5/WindowSizeLabel


func _ready() -> void:
    king_speed_slider.value = game.king_speed
    king_speed_label.text = "%.2f" % game.king_speed


func _process(_delta: float) -> void:
    camera_label.text = "%s\n%s\n%s" % [format_vector(game.camera.get_target_position()), format_vector(game.camera.get_screen_center_position()), format_vector(game.camera.get_screen_transform().origin)]
    texture_rect_label.text = "%s\n%s" % [format_vector(texture_rect.get_canvas_transform().origin), format_vector(texture_rect.get_screen_transform().origin)]
    king_label.text = "%s\n%s" % [format_vector(game.king.global_position), format_vector(game.king.get_screen_transform().origin)]
    window_size_label.text = "%s\n%s" % [format_size(get_window().size), format_size((game.get_viewport() as SubViewport).size)]
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
        ($HBoxContainer as Control).visible = !($HBoxContainer as Control).visible
    elif event.is_action_pressed("quit"):
        get_tree().quit()


func format_vector(vec: Vector2) -> String:
    return "%.2f / %.2f" % [vec.x, vec.y]


func format_size(vec: Vector2i) -> String:
    return "%d×%d" % [vec.x, vec.y]


func _on_king_speed_slider_value_changed(value: float) -> void:
    game.king_speed = value
    king_speed_label.text = "%.2f" % game.king_speed
