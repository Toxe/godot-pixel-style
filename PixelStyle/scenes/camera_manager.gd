class_name CameraManager extends Node

enum CoordsType {
    Unknown,
    World,
    UI,
    Screen,
}

@export var cameras: Array[Camera2D]

@onready var current_camera: Camera2D = _get_first_enabled_camera()


func _process(delta: float) -> void:
    var camera_movement := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if !camera_movement.is_zero_approx():
        var camera_speed := 0.1 if Input.is_physical_key_pressed(Key.KEY_SHIFT) else 1.0
        if Input.is_physical_key_pressed(Key.KEY_CTRL):
            current_camera.position += camera_movement * 100.0 * delta * camera_speed
        else:
            current_camera.offset += camera_movement * 100.0 * delta * camera_speed


func _get_first_enabled_camera() -> Camera2D:
    return cameras.get(cameras.find_custom(func(c: Camera2D) -> bool: return c.enabled))


func next_camera() -> void:
    var next_index := cameras.find(current_camera) + 1
    current_camera.enabled = false
    current_camera = cameras[next_index] if next_index < cameras.size() else cameras[0]
    current_camera.enabled = true


func recenter_camera() -> void:
    current_camera.position = Vector2.ZERO
    current_camera.offset = Vector2.ZERO


func toggle_camera_smoothing() -> void:
    current_camera.position_smoothing_enabled = !current_camera.position_smoothing_enabled


func get_current_camera_coords_type() -> CoordsType:
    match current_camera.name:
        "GameCamera": return CoordsType.World
        "MainCamera": return CoordsType.UI
        _: return CoordsType.Unknown
