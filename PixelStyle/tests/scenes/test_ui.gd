extends GutTest

const main_scene: PackedScene = preload("uid://dvkb4iyvuwwy4")


func _create_ui() -> UI:
    var main: Main = add_child_autofree(main_scene.instantiate())
    var ui: UI = main.get_node("CanvasLayer/UI")
    ui.game.king_speed = 0.0
    ui.camera_manager.current_camera.position_smoothing_enabled = false
    return ui


func test_transform_to_ui_coords_from_different_coords_type() -> void:
    var ui := _create_ui()
    assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.World, Vector2(0, 0)), Vector2(-46.0, -71.3333), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.World, Vector2(320, 180)), Vector2(274.0, 108.6667), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.World, Vector2(640, 360)), Vector2(594.0, 288.6667), Vector2(0.00001, 0.00001))

    ui.camera_manager.current_camera.position = Vector2(-50, 20)
    ui.camera_manager.current_camera.offset = Vector2(20, -40)
    await wait_process_frames(1)

    assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.World, Vector2(0, 0)), Vector2(-16.0, -51.3333), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.World, Vector2(320, 180)), Vector2(304.0, 128.6667), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.World, Vector2(640, 360)), Vector2(624.0, 308.6667), Vector2(0.00001, 0.00001))


func test_transform_to_ui_coords_from_same_coords_type() -> void:
    var ui := _create_ui()
    var test_coords: Array[Vector2] = [Vector2(0, 0), Vector2(320, 180), Vector2(640, 360)]

    for vec in test_coords:
        assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.UI, vec), vec, Vector2(0.00001, 0.00001))

    ui.camera_manager.current_camera.position = Vector2(-50, 20)
    ui.camera_manager.current_camera.offset = Vector2(20, -40)
    await wait_process_frames(1)

    for vec in test_coords:
        assert_almost_eq(ui.transform_to_ui_coords(CameraManager.CoordsType.UI, vec), vec, Vector2(0.00001, 0.00001))


func test_transform_to_world_coords_from_different_coords_type() -> void:
    var ui := _create_ui()
    assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.UI, Vector2(0, 0)), Vector2(46.0, 71.3333), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.UI, Vector2(320, 180)), Vector2(366.0, 251.3333), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.UI, Vector2(640, 360)), Vector2(686.0, 431.3333), Vector2(0.00001, 0.00001))

    ui.camera_manager.current_camera.position = Vector2(-50, 20)
    ui.camera_manager.current_camera.offset = Vector2(20, -40)
    await wait_process_frames(1)

    assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.UI, Vector2(0, 0)), Vector2(16.0, 51.3333), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.UI, Vector2(320, 180)), Vector2(336.0, 231.3333), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.UI, Vector2(640, 360)), Vector2(656.0, 411.3333), Vector2(0.00001, 0.00001))


func test_transform_to_world_coords_from_same_coords_type() -> void:
    var ui := _create_ui()
    var test_coords: Array[Vector2] = [Vector2(0, 0), Vector2(320, 180), Vector2(640, 360)]

    for vec in test_coords:
        assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.World, vec), vec, Vector2(0.00001, 0.00001))

    ui.camera_manager.current_camera.position = Vector2(-50, 20)
    ui.camera_manager.current_camera.offset = Vector2(20, -40)
    await wait_process_frames(1)

    for vec in test_coords:
        assert_almost_eq(ui.transform_to_world_coords(CameraManager.CoordsType.World, vec), vec, Vector2(0.00001, 0.00001))


func test_transform_ui_to_screen_coords() -> void:
    var ui := _create_ui()
    assert_almost_eq(ui.transform_ui_to_screen_coords(Vector2(0, 0)), Vector2(0, 0), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_ui_to_screen_coords(Vector2(320, 180)), Vector2(960, 540), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_ui_to_screen_coords(Vector2(640, 360)), Vector2(1920, 1080), Vector2(0.00001, 0.00001))

    ui.camera_manager.current_camera.position = Vector2(-50, 20)
    ui.camera_manager.current_camera.offset = Vector2(20, -40)
    await wait_process_frames(1)

    assert_almost_eq(ui.transform_ui_to_screen_coords(Vector2(0, 0)), Vector2(0, 0), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_ui_to_screen_coords(Vector2(320, 180)), Vector2(960, 540), Vector2(0.00001, 0.00001))
    assert_almost_eq(ui.transform_ui_to_screen_coords(Vector2(640, 360)), Vector2(1920, 1080), Vector2(0.00001, 0.00001))
