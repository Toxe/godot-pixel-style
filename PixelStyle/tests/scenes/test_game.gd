extends GutTest

const game_scene: PackedScene = preload("uid://cl4oo5o1s3gb8")


func test_scene_runs() -> void:
    add_child_autofree(game_scene.instantiate())
    await wait_process_frames(1)
    pass_test("scene works")
