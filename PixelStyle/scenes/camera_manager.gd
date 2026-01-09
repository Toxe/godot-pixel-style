class_name CameraManager extends Node

@export var cameras: Array[Camera2D]

@onready var current_camera: Camera2D = _get_first_enabled_camera()


func _get_first_enabled_camera() -> Camera2D:
    return cameras.get(cameras.find_custom(func(c: Camera2D) -> bool: return c.enabled))


func next_camera() -> void:
    var next_index := cameras.find(current_camera) + 1
    current_camera.enabled = false
    current_camera = cameras[next_index] if next_index < cameras.size() else cameras[0]
    current_camera.enabled = true
