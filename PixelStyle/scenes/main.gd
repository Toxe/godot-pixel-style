class_name Main extends Node2D


func _ready() -> void:
    create_window_title_update_timer()
    update_window_title()


func create_window_title_update_timer() -> void:
    var timer := Timer.new()
    add_child(timer)
    timer.timeout.connect(update_window_title)
    timer.start(1.0)


func update_window_title() -> void:
    get_window().title = "%s [%d FPS]" % [ProjectSettings.get_setting("application/config/name"), Performance.get_monitor(Performance.TIME_FPS)]
