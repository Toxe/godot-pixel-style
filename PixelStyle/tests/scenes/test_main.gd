extends GutTest

const main_scene: PackedScene = preload("uid://dvkb4iyvuwwy4")


func test_scene_runs() -> void:
    add_child_autofree(main_scene.instantiate())
    await wait_process_frames(1)
    pass_test("scene works")
