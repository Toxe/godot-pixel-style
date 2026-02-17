class_name GUI extends Control

@export var game: Game
@export var camera_manager: CameraManager
@export var texture_rect: TextureRect

@onready var frame_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer9/FrameLabel
@onready var camera_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/CameraLabel
@onready var camera_zoom_slider: HSlider = $HBoxContainer/VBoxContainer/GridContainer/CameraZoomSlider
@onready var camera_zoom_label: Label = $HBoxContainer/VBoxContainer/GridContainer/CameraZoomLabel
@onready var texture_rect_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer2/TextureRectLabel
@onready var king_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer3/KingLabel
@onready var king_speed_slider: HSlider = $HBoxContainer/VBoxContainer/GridContainer/KingSpeedSlider
@onready var king_speed_label: Label = $HBoxContainer/VBoxContainer/GridContainer/KingSpeedLabel
@onready var priest_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer7/PriestLabel
@onready var priest_speed_slider: HSlider = $HBoxContainer/VBoxContainer/GridContainer/PriestSpeedSlider
@onready var priest_speed_label: Label = $HBoxContainer/VBoxContainer/GridContainer/PriestSpeedLabel
@onready var window_size_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer5/WindowSizeLabel


func _process(delta: float) -> void:
    var current_camera := camera_manager.current_camera
    var camera_movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    if camera_movement != Vector2.ZERO:
        var camera_speed := 0.1 if Input.is_physical_key_pressed(Key.KEY_SHIFT) else 1.0
        if Input.is_physical_key_pressed(Key.KEY_CTRL):
            current_camera.offset += camera_movement * 100.0 * delta * camera_speed
        else:
            current_camera.position += camera_movement * 100.0 * delta * camera_speed

    frame_label.text = "%0.6f\n%d\n%0.1f" % [Time.get_ticks_usec() / 1_000_000.0, Engine.get_process_frames(), Performance.get_monitor(Performance.TIME_FPS)]
    camera_label.text = "%s\n%s\n%s\n%s\n%s\n%s\n%s" % [
        current_camera.name,
        "on" if current_camera.position_smoothing_enabled else "off",
        Format.format_position(current_camera.position),
        Format.format_position(current_camera.global_position),
        Format.format_position(current_camera.get_target_position()),
        Format.format_position(current_camera.offset),
        Format.format_position(current_camera.get_screen_center_position()),
    ]

    texture_rect_label.text = "%s\n%s" % [Format.format_position(texture_rect.get_canvas_transform().origin), Format.format_position(texture_rect.get_screen_transform().origin)]
    king_label.text = "%s\n%s" % [Format.format_position(game.king.global_position), Format.format_position(game.king.get_screen_transform().origin)]
    priest_label.text = "%s\n%s" % [Format.format_position(game.priest.global_position), Format.format_position(game.priest.get_screen_transform().origin)]
    window_size_label.text = "%s\n%s" % [Format.format_size(get_window().size), Format.format_size((game.get_viewport() as SubViewport).size)]

    camera_zoom_slider.value = current_camera.zoom.x
    camera_zoom_label.text = "%.2f" % current_camera.zoom.x
    king_speed_slider.value = game.king_speed
    king_speed_label.text = "%.2f" % game.king_speed
    priest_speed_slider.value = game.priest_speed
    priest_speed_label.text = "%.2f (pixels per frame)" % game.priest_speed

    queue_redraw()


func _draw() -> void:
    DebugDraw.draw_axes(self, size / 2.0, "GUI center", Color.WHEAT)

    var coords_on_game_sub_viewport_canvas := game.get_global_transform_with_canvas() * camera_manager.current_camera.global_position
    var local_gui_coords := get_global_transform_with_canvas().affine_inverse() * coords_on_game_sub_viewport_canvas
    DebugDraw.draw_labeled_circle(self, local_gui_coords, 10, Color.GREEN, 1, "Camera global_position: %s" % [Format.format_position(camera_manager.current_camera.global_position)])


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_fullscreen"):
        if DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
        else:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
    elif event.is_action_pressed("toggle_gui"):
        ($HBoxContainer as Control).visible = !($HBoxContainer as Control).visible
    elif event.is_action_pressed("switch_camera"):
        camera_manager.next_camera()
    elif event.is_action_pressed("recenter_camera"):
        camera_manager.recenter_camera()
    elif event.is_action_pressed("toggle_camera_smoothing"):
        camera_manager.toggle_camera_smoothing()
    elif event.is_action_pressed("quit"):
        get_tree().quit()


func _on_camera_zoom_slider_value_changed(value: float) -> void:
    camera_manager.current_camera.zoom = Vector2(value, value)
    camera_zoom_label.text = "%.2f" % camera_manager.current_camera.zoom.x


func _on_king_speed_slider_value_changed(value: float) -> void:
    game.king_speed = value
    king_speed_label.text = "%.2f" % game.king_speed


func _on_priest_speed_slider_value_changed(value: float) -> void:
    game.priest_speed = value
    priest_speed_label.text = "%.2f" % game.priest_speed
