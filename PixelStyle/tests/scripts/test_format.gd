extends GutTest


func test_format_position() -> void:
    assert_eq(Format.format_position(Vector2(0, 0)), "0.00 / 0.00")
    assert_eq(Format.format_position(Vector2(100, 200)), "100.00 / 200.00")
    assert_eq(Format.format_position(Vector2(100.12, 200.34)), "100.12 / 200.34")
    assert_eq(Format.format_position(Vector2(100.1234, 200.3456)), "100.12 / 200.35")
    assert_eq(Format.format_position(Vector2(-100, -200)), "-100.00 / -200.00")
    assert_eq(Format.format_position(Vector2(100, 200), CameraManager.CoordsType.World), "🌐 100.00 / 200.00")
    assert_eq(Format.format_position(Vector2(100, 200), CameraManager.CoordsType.UI), "📐 100.00 / 200.00")
    assert_eq(Format.format_position(Vector2(100, 200), CameraManager.CoordsType.Screen), "🖥️ 100.00 / 200.00")
    assert_eq(Format.format_position(Vector2(100, 200), CameraManager.CoordsType.Unknown), "100.00 / 200.00")
    assert_eq(Format.format_position(Vector2(100, 200), CameraManager.CoordsType.World, true), "🌐 100 / 200")
    assert_eq(Format.format_position(Vector2(100, 200), CameraManager.CoordsType.Unknown, true), "100 / 200")
    assert_eq(Format.format_position(Vector2(0, 0), CameraManager.CoordsType.Unknown, true), "0 / 0")
    assert_eq(Format.format_position(Vector2(0, 0.12), CameraManager.CoordsType.Unknown, true), "0.00 / 0.12")
    assert_eq(Format.format_position(Vector2(0.12, 0), CameraManager.CoordsType.Unknown, true), "0.12 / 0.00")
    assert_eq(Format.format_position(Vector2(-11, -22), CameraManager.CoordsType.Unknown, true), "-11 / -22")


func test_format_size() -> void:
    assert_eq(Format.format_size(Vector2(0, 0)), "0×0")
    assert_eq(Format.format_size(Vector2(640, 480)), "640×480")
