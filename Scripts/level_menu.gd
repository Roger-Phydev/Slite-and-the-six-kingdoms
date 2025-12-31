extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMaster.success = false; #sets false as success


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_1_pressed() -> void:
	GameMaster.level = 1; #sets the level
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #start the scene of the level

func _on_option_2_pressed() -> void:
	GameMaster.level = 2; #sets the level
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #start the scene of the level

func _on_option_3_pressed() -> void:
	GameMaster.level = 3; #sets the level
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #start the scene of the level


func _on_option_4_pressed() -> void:
	GameMaster.level = 4; #sets the level
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #start the scene of the level

func _on_option_5_pressed() -> void:
	GameMaster.level = 5; #sets the level
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #start the scene of the level

func _on_option_6_pressed() -> void:
	GameMaster.level = 6; #sets the level
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #start the scene of the level

func _on_return_world_pressed() -> void:
	GameMaster.start_menu("world"); #returns to the world selection menu

func _on_return_main_pressed() -> void:
	GameMaster.start_menu("main"); #returns to the main menu
