class_name UI extends Control

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


func _process(_delta: float) -> void:
    var current_camera := camera_manager.current_camera

    frame_label.text = "%0.6f\n%d\n%0.1f" % [Time.get_ticks_usec() / 1_000_000.0, Engine.get_process_frames(), Performance.get_monitor(Performance.TIME_FPS)]
    camera_label.text = "%s\n%s\n%s\n%s\n%s\n%s\n%s" % [
        current_camera.name,
        "on" if current_camera.position_smoothing_enabled else "off",
        Format.format_position(current_camera.position, camera_manager.get_current_camera_coords_type()),
        Format.format_position(current_camera.global_position, camera_manager.get_current_camera_coords_type()),
        Format.format_position(current_camera.get_target_position(), camera_manager.get_current_camera_coords_type()),
        Format.format_position(current_camera.offset, camera_manager.get_current_camera_coords_type()),
        Format.format_position(current_camera.get_screen_center_position(), camera_manager.get_current_camera_coords_type()),
    ]

    texture_rect_label.text = "%s\n%s" % [Format.format_position(texture_rect.get_canvas_transform().origin), Format.format_position(texture_rect.get_screen_transform().origin)]
    king_label.text = "%s\n%s" % [Format.format_position(game.king.global_position, CameraManager.CoordsType.World), Format.format_position(game.king.get_screen_transform().origin, CameraManager.CoordsType.World)]
    priest_label.text = "%s\n%s" % [Format.format_position(game.priest.global_position, CameraManager.CoordsType.World), Format.format_position(game.priest.get_screen_transform().origin, CameraManager.CoordsType.World)]
    window_size_label.text = "%s\n%s" % [Format.format_size(get_window().size), Format.format_size((game.get_viewport() as SubViewport).size)]

    camera_zoom_slider.value = current_camera.zoom.x
    camera_zoom_label.text = "%.2f" % current_camera.zoom.x
    king_speed_slider.value = game.king_speed
    king_speed_label.text = "%.2f" % game.king_speed
    priest_speed_slider.value = game.priest_speed
    priest_speed_label.text = "%.2f (pixels per frame)" % game.priest_speed

    queue_redraw()


func _draw() -> void:
    if !DebugDraw.draw_enabled:
        return

    # axes
    DebugDraw.draw_axes(self, size / 2.0, "UI center: %s" % [Format.format_position(size / 2.0, CameraManager.CoordsType.UI, true)], Color.WHEAT, Color.BLACK)

    # camera
    var camera_position := camera_manager.current_camera.position
    var camera_offset := camera_manager.current_camera.offset
    var camera_target_position := camera_manager.current_camera.get_target_position()
    var camera_target_position_plus_offset := camera_target_position + camera_offset
    var camera_screen_center_position := camera_manager.current_camera.get_screen_center_position()
    var camera_coords_type := camera_manager.get_current_camera_coords_type()

    DebugDraw.draw_labeled_circle(self, transform_world_to_ui_coords(camera_target_position_plus_offset), 5, Color.YELLOW, Color.BLACK, 1, [
        "🎥 target_position + offset: %s" % [Format.format_position(camera_target_position_plus_offset, camera_coords_type)],
        "%s" % [Format.format_position(transform_world_to_ui_coords(camera_target_position_plus_offset), CameraManager.CoordsType.UI)],
    ])
    DebugDraw.draw_labeled_circle(self, transform_world_to_ui_coords(camera_screen_center_position), 7, Color.GREEN, Color.BLACK, 1, [
        "🎥 screen_center_position: %s" % [Format.format_position(camera_screen_center_position, camera_coords_type)],
        "%s" % [Format.format_position(transform_world_to_ui_coords(camera_screen_center_position), CameraManager.CoordsType.UI)],
    ])
    draw_dashed_line(transform_world_to_ui_coords(camera_target_position_plus_offset), transform_world_to_ui_coords(camera_screen_center_position), Color.GREEN, 0.5, 1, false)

    if !camera_position.is_zero_approx():
        var from := transform_world_to_ui_coords(camera_target_position - camera_position)
        var to := transform_world_to_ui_coords(camera_target_position)
        draw_line(from, to, Color.DARK_GRAY, 0.5)
        DebugDraw.draw_labeled_circle(self, from, 3, Color.DARK_GRAY, Color.BLACK, 0.5, ["🎥 position: %s" % [Format.format_position(camera_position, camera_coords_type)]])

    if !camera_offset.is_zero_approx():
        var from := transform_world_to_ui_coords(camera_target_position)
        var to := transform_world_to_ui_coords(camera_target_position_plus_offset)
        draw_line(from, to, Color.LIGHT_GRAY, 0.5)
        DebugDraw.draw_labeled_circle(self, from, 3, Color.LIGHT_GRAY, Color.BLACK, 0.5, ["🎥 target_position (without offset): %s" % [Format.format_position(camera_target_position, camera_coords_type)]])

    # mouse
    var mouse_coords := get_local_mouse_position()
    var world_coords := transform_ui_to_world_coords(mouse_coords)
    var screen_coords := transform_ui_to_screen_coords(mouse_coords)
    var lines: Array[String] = [
        Format.format_position(world_coords, CameraManager.CoordsType.World),
        Format.format_position(mouse_coords, CameraManager.CoordsType.UI),
        Format.format_position(screen_coords, CameraManager.CoordsType.Screen, true),
    ]
    DebugDraw.draw_labeled_circle(self, mouse_coords, 3, Color.LIGHT_GRAY, Color.BLACK, 0.25, lines)


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_fullscreen"):
        if DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
        else:
            DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
    elif event.is_action_pressed("toggle_ui"):
        ($HBoxContainer as Control).visible = !($HBoxContainer as Control).visible
    elif event.is_action_pressed("toggle_debug_draw"):
        DebugDraw.draw_enabled = !DebugDraw.draw_enabled
    elif event.is_action_pressed("toggle_debug_text"):
        DebugDraw.text_enabled = !DebugDraw.text_enabled
    elif event.is_action_pressed("switch_camera"):
        camera_manager.next_camera()
    elif event.is_action_pressed("recenter_camera"):
        camera_manager.recenter_camera()
    elif event.is_action_pressed("toggle_camera_smoothing"):
        camera_manager.toggle_camera_smoothing()
    elif event.is_action_pressed("quit"):
        get_tree().quit()


func transform_world_to_ui_coords(pos: Vector2) -> Vector2:
    var coords_on_world_canvas := game.get_global_transform_with_canvas() * pos
    var coords_on_ui_canvas := get_global_transform_with_canvas().affine_inverse() * coords_on_world_canvas
    return coords_on_ui_canvas


func transform_ui_to_world_coords(pos: Vector2) -> Vector2:
    var coords_on_ui_canvas := get_global_transform_with_canvas() * pos
    var coords_on_world_canvas := game.get_global_transform_with_canvas().affine_inverse() * coords_on_ui_canvas
    return coords_on_world_canvas


func transform_ui_to_screen_coords(pos: Vector2) -> Vector2:
    var coords_on_ui_canvas := get_global_transform_with_canvas() * pos
    var coords_on_screen := get_viewport().get_screen_transform() * coords_on_ui_canvas
    return coords_on_screen


func _on_camera_zoom_slider_value_changed(value: float) -> void:
    camera_manager.current_camera.zoom = Vector2(value, value)
    camera_zoom_label.text = "%.2f" % camera_manager.current_camera.zoom.x


func _on_king_speed_slider_value_changed(value: float) -> void:
    game.king_speed = value
    king_speed_label.text = "%.2f" % game.king_speed


func _on_priest_speed_slider_value_changed(value: float) -> void:
    game.priest_speed = value
    priest_speed_label.text = "%.2f" % game.priest_speed
