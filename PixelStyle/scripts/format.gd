class_name Format


static func format_position(vec: Vector2, coords_type := CameraManager.CoordsType.Unknown, trim_trailing_zeros := false) -> String:
    var x := "%.2f" % vec.x
    var y := "%.2f" % vec.y

    # trim trailing zeros if BOTH coordinates end in ".00", for example "640.00 / 480.00" --> "640 / 480"
    if trim_trailing_zeros && x.ends_with(".00") && y.ends_with(".00"):
        x = x.left(-3)
        y = y.left(-3)

    return "%s%s / %s" % [_coords_type_to_symbol(coords_type), x, y]


static func format_size(vec: Vector2) -> String:
    return "%s×%s" % [without_trailing_zeros(vec.x), without_trailing_zeros(vec.y)]


static func without_trailing_zeros(n: float) -> String:
    return String.num(n, 0 if step_decimals(n) == 0 else -1)


static func _coords_type_to_symbol(coords_type: CameraManager.CoordsType) -> String:
    match coords_type:
        CameraManager.CoordsType.World: return "🌐 "
        CameraManager.CoordsType.UI: return "📐 "
        CameraManager.CoordsType.Screen: return "🖥️ "
        _: return ""
