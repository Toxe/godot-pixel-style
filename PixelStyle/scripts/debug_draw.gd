class_name DebugDraw

class FittedText:
    var text := ""
    var rect := Rect2()
    var font_size := 0


const font_size := 6
const font_outline_size := 2

static var project_theme := ThemeDB.get_project_theme()


static func draw_label(canvas_item: CanvasItem, label_position: Vector2, lines: Array[String], text_color: Color, outline_color: Color, label_anchor: Vector2) -> void:
    if canvas_item.visible:
        var viewport := canvas_item.get_viewport()
        var labels: Array[FittedText]

        for text in lines:
            var fitted_text := _fit_label_text_to_viewport(text, viewport)
            if !fitted_text:
                fitted_text = _fit_label_text_to_viewport("[text too long]", viewport)
            assert(fitted_text != null)
            labels.append(fitted_text)

        _right_align_labels(labels)
        _vertically_stack_labels(labels)

        var bounding_box := _calc_labels_bounding_box(labels)
        bounding_box = _position_rect_with_anchor(bounding_box, label_position, label_anchor)
        bounding_box = _fit_rect_to_viewport(bounding_box, viewport)

        _move_labels_into_bounding_box(labels, bounding_box)

        for label in labels:
            var baseline_position := label.rect.position + Vector2(0, label.font_size)
            canvas_item.draw_string_outline(project_theme.default_font, baseline_position, label.text, HORIZONTAL_ALIGNMENT_RIGHT, label.rect.size.x, label.font_size, font_outline_size, outline_color)
            canvas_item.draw_string(project_theme.default_font, baseline_position, label.text, HORIZONTAL_ALIGNMENT_RIGHT, label.rect.size.x, label.font_size, text_color)


static func draw_axes(canvas_item: CanvasItem, center: Vector2, text: String, color: Color, outline_color: Color) -> void:
    var viewport_size := canvas_item.get_viewport_rect().size
    canvas_item.draw_line(Vector2(center.x, 0), Vector2(center.x, viewport_size.y), color)
    canvas_item.draw_line(Vector2(0, center.y), Vector2(viewport_size.x, center.y), color)
    var label_position := Vector2(viewport_size.x - 1, center.y)
    draw_label(canvas_item, label_position, ["%s (%s)" % [text, Format.format_position(center, true)]], color, outline_color, Vector2(1, 1))


static func draw_labeled_circle(canvas_item: CanvasItem, pos: Vector2, radius: float, color: Color, outline_color: Color, width: float, lines: Array[String]) -> void:
    if canvas_item.visible:
        canvas_item.draw_circle(pos, radius, color, false, width)
        var label_position := pos + Vector2(0, radius + roundf(float(font_size) / 2.0))
        draw_label(canvas_item, label_position, lines, color, outline_color, Vector2(0.5, 0))


# brute force trying decreasing font sizes until the text fits inside the Viewport
static func _fit_label_text_to_viewport(text: String, viewport: Viewport) -> FittedText:
    var viewport_rect := viewport.get_visible_rect()
    var fitted_text := FittedText.new()
    fitted_text.text = text
    fitted_text.font_size = font_size

    while fitted_text.font_size > 1:
        fitted_text.rect.size = project_theme.default_font.get_string_size(fitted_text.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fitted_text.font_size)
        if fitted_text.rect.size.x <= viewport_rect.size.x:
            break
        else:
            fitted_text.font_size -= 1

    return fitted_text if fitted_text.font_size > 1 else null


static func _right_align_labels(labels: Array[FittedText]) -> void:
    var max_x := 0.0
    for label in labels:
        max_x = maxf(max_x, label.rect.end.x)
    for label in labels:
        label.rect.end.x = max_x


static func _vertically_stack_labels(labels: Array[FittedText]) -> void:
    var offset_y := 0.0
    for label in labels:
        label.rect.position.y += offset_y
        offset_y += label.font_size


static func _calc_labels_bounding_box(labels: Array[FittedText]) -> Rect2:
    var bbox := Rect2()
    for label in labels:
        bbox = bbox.merge(label.rect)
    return bbox


static func _position_rect_with_anchor(rect: Rect2, pos: Vector2, anchor: Vector2) -> Rect2:
    return Rect2(pos - rect.size * anchor, rect.size)


static func _fit_rect_to_viewport(rect: Rect2, viewport: Viewport) -> Rect2:
    var viewport_rect := viewport.get_visible_rect()

    if rect.end.x > viewport_rect.end.x:
        rect.position.x += viewport_rect.end.x - rect.end.x
    elif rect.position.x < viewport_rect.position.x:
        rect.position.x += viewport_rect.position.x - rect.position.x

    if rect.end.y > viewport_rect.end.y:
        rect.position.y += viewport_rect.end.y - rect.end.y
    elif rect.position.y < viewport_rect.position.y:
        rect.position.y += viewport_rect.position.y - rect.position.y

    return rect


static func _move_labels_into_bounding_box(labels: Array[FittedText], bounding_box: Rect2) -> void:
    for label in labels:
        label.rect.position += bounding_box.position
