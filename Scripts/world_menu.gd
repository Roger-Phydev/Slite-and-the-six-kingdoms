extends Control

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_option_1_pressed() -> void:
	GameMaster.world=1; #sets first world
	GameMaster.start_menu("level"); #pass to the level selection menu

func _on_option_2_pressed() -> void:
	GameMaster.world=2; #sets second world
	GameMaster.start_menu("level"); #pass to the level selection menu
	
func _on_option_3_pressed() -> void:
	GameMaster.world=3; #sets third world
	GameMaster.start_menu("level"); #pass to the level selection menu

func _on_option_4_pressed() -> void:
	GameMaster.world=4; #sets fourth world
	GameMaster.start_menu("level"); #pass to the level selection menu

func _on_option_5_pressed() -> void:
	GameMaster.world=5; #sets fifth world
	GameMaster.start_menu("level"); #pass to the level selection menu

func _on_option_6_pressed() -> void:
	GameMaster.world=6; #sets sixth world
	GameMaster.start_menu("level"); #pass to the level selection menu


func _on_return_pressed() -> void:
	GameMaster.start_menu("main"); #returns to the main menu
