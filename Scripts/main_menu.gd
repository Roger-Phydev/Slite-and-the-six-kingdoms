extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void: #start game button
	GameMaster.world = 1;
	GameMaster.level = 1;
	GameMaster.success = false; #sets false as success
	GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level); #begins the level 1 from world 1

func _on_select_level_pressed() -> void: #select level button
	GameMaster.start_menu("world"); #pass to the world selection menu

func _on_exit_pressed() -> void: #exit button
	GameMaster.exit(); #exits the level
