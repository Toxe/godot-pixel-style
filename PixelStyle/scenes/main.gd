class_name Main extends Node2D

@export var camera: Camera2D


func _ready() -> void:
    create_window_title_update_timer()
    update_window_title()


func _unhandled_input(event: InputEvent) -> void:
    var event_mouse_button: InputEventMouseButton = event as InputEventMouseButton
    if event_mouse_button && event_mouse_button.is_pressed():
        print(event_mouse_button)
        camera.position = event_mouse_button.position


func _process(delta: float) -> void:
    var camera_movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    camera.position += camera_movement * 100.0 * delta


func create_window_title_update_timer() -> void:
    var timer := Timer.new()
    add_child(timer)
    timer.timeout.connect(update_window_title)
    timer.start(1.0)


func update_window_title() -> void:
    get_window().title = "%s [%d FPS]" % [ProjectSettings.get_setting("application/config/name"), Performance.get_monitor(Performance.TIME_FPS)]
