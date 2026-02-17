class_name DebugDraw

const font_size := 5


static func draw_label(canvas_item: CanvasItem, label_position: Vector2, text: String, alignment: HorizontalAlignment, color: Color, label_offset: Vector2) -> void:
    if canvas_item.visible:
        var gui: Control = canvas_item.get_node("/root/Main/CanvasLayer/GUI")  # TODO
        var string_size := gui.theme.default_font.get_multiline_string_size(text, alignment, -1, font_size)
        var bottom_left := label_position + string_size * label_offset
        canvas_item.draw_multiline_string(gui.theme.default_font, bottom_left, text, alignment, string_size.x, font_size, -1, color)


static func draw_axes(canvas_item: CanvasItem, center: Vector2, text: String, color: Color) -> void:
    var viewport_size := canvas_item.get_viewport_rect().size
    canvas_item.draw_line(Vector2(center.x, 0), Vector2(center.x, viewport_size.y), color)
    canvas_item.draw_line(Vector2(0, center.y), Vector2(viewport_size.x, center.y), color)
    var label_position := Vector2(viewport_size.x - 1, center.y - 2)
    draw_label(canvas_item, label_position, "%s (%s)" % [text, Format.format_position(center, true)], HORIZONTAL_ALIGNMENT_LEFT, color, Vector2(-1, 0))


static func draw_labeled_circle(canvas_item: CanvasItem, pos: Vector2, radius: float, color: Color, width: float, text: String) -> void:
    canvas_item.draw_circle(pos, radius, color, false, width)
    var label_position := pos + Vector2(0, radius)
    draw_label(canvas_item, label_position, text, HORIZONTAL_ALIGNMENT_CENTER, color, Vector2(-0.5, 1))
