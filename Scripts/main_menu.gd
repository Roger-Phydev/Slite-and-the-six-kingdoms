extends Control
#velocity of elements
var clouds_speed = 100;
var birds_speed = 70;
# option of menu movement
var menu_focus = false; #indicates if the control movement is active
var menu_options = []; #the options of menus
var menu_cursor = Vector2(0,0); #the cursor on menus
var previous_cursor_x = 0; #saves the previus state en case of y movement 
var actual_menu = "initial";
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	####### Basic configuration
	GameMaster.coinsCount = 0;
	GameMaster.hits = 3;
	GameMaster.hero_mode = false;
	####### Music
	$MainMenuMusic.play(); #begins the music as far as is ready
	$MenuMovement.volume_db = 20;
	####### Animations
	$Background/Sun/AnimationPlayer.play("shine"); #sun
	for bird in $elements/Birds.get_children(): #birds
		bird.get_children()[0].play("fly");
	$"Variable presentation/Slite/AnimationPlayer".play("idle");
	############# disableding buttons without use
	$InitialOptions/Continue.disabled = true;
	$InitialOptions/Tutorial.disabled = true;
	############# setting menu_options
	menu_options = [
		[$InitialOptions/Continue],
		[$InitialOptions/StartGame],
		[$InitialOptions/Tutorial],
		[$InitialOptions/ToWorldMenu],
		[$InitialOptions/Credits],
		[$InitialOptions/Exit]
	];
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##################################
	# mobile elements
	###############
	# clouds movement
	if $elements/Clouds1.position.x > -2304:
		$elements/Clouds1.position.x -= delta*clouds_speed;
	else:
		$elements/Clouds1.position.x = 1152;
	if $elements/Clouds2.position.x > -2304:
		$elements/Clouds2.position.x -= delta*clouds_speed;
	else:
		$elements/Clouds2.position.x = 1152;
	# birds movement
	if $elements/Birds.position.x > -2304:
		$elements/Birds.position.x -= delta*birds_speed;
	else:
		$elements/Birds.position.x = 0
	################
	# Menu movement
	################
	if (Input.is_action_just_released("Up") or Input.is_action_just_pressed("Down")) and not menu_focus:
		menu_focus = true;
	if menu_focus:
		menu_movement(menu_options);
	if Input.is_action_just_released("cancel"):
		if actual_menu == "world":
			change_menu("world","initial");
			actual_menu = "initial";
		elif actual_menu == "level":
			change_menu("level","world");
			actual_menu = "world";
###################################
# Functions
###################################
# jumping menus:
func change_menu(menu_from:String,menu_to:String):
	# hides the previous menu
	if menu_from == "initial":
		$InitialOptions.visible = false;
	elif menu_from == "world":
		$WorldMenu.visible = false;
	elif menu_from == "level":
		$LevelMenu.visible = false;
	# shows the next menu and sets the options
	if menu_to == "initial":
		menu_options = [
			[$InitialOptions/Continue],
			[$InitialOptions/StartGame],
			[$InitialOptions/Tutorial],
			[$InitialOptions/ToWorldMenu],
			[$InitialOptions/Credits],
			[$InitialOptions/Exit]
		];
		$InitialOptions.visible = true;
	elif menu_to == "world":
		menu_options = [
			[$WorldMenu/Worlds1/World1,$WorldMenu/Worlds1/World2,$WorldMenu/Worlds1/World3],
			[$WorldMenu/Worlds2/World4,$WorldMenu/Worlds2/World5,$WorldMenu/Worlds2/World6],
			[$WorldMenu/ToInitialOptions]
		];
		$WorldMenu.visible = true;
	elif menu_to == "level":
		menu_options = [
			[$LevelMenu/Levels1/Level1,$LevelMenu/Levels1/Level2,$LevelMenu/Levels1/Level3],
			[$LevelMenu/Levels2/Level4,$LevelMenu/Levels2/Level5,$LevelMenu/Levels2/Level6],
			[$LevelMenu/HBoxContainer/MainMenu,$LevelMenu/HBoxContainer/WorldMenu]
		];
		$LevelMenu.visible = true;
	menu_cursor = Vector2(0,0); #resetea el cursor del menú
# Changing secondary visuals:
func toogle_variable_presentation(world:int):
	#get invisible every background
	for bg in $"Variable presentation/WorldBackgrounds".get_children():
		bg.visible = false;
	#then makes visible the world set in input
	$"Variable presentation/WorldBackgrounds".get_children()[world-1].visible = true;
# turning off/on success or hero mode
func set_progress_elements(type:String,on:bool=true):
	if type == "success":
		$"Variable presentation/Success".visible = on;
	elif type == "hero":
		$"Variable presentation/HeroMode".visible = on;
# updating focus elements:
func menu_movement(options):
	#gets dimension of the options
	var height = len(options);
	var width = len(options[menu_cursor.y]);
	##### cursor's changes
	if Input.is_action_just_released("Up"): #up movement
		#decreses y valor and remains 0 if it's smaller than 0
		$MenuMovement.play();
		menu_cursor.y = menu_cursor.y-1 if menu_cursor.y-1>0 else 0;
		
		if len(options[menu_cursor.y]) <= len(options[menu_cursor.y+1]):#if the next state has less width resets
			#sets the x in the range except when is bigger than the width
			previous_cursor_x = menu_cursor.x; #updates previous 
			menu_cursor.x = len(options[menu_cursor.y])-1 if menu_cursor.x >= len(options[menu_cursor.y]) else menu_cursor.x;
		else: #in other case, resets
			menu_cursor.x = previous_cursor_x;
	elif Input.is_action_just_released("Down"): #down movement
		# increases y valor and remains height - 1 if it's greather than height
		$MenuMovement.play();
		menu_cursor.y = menu_cursor.y+1 if menu_cursor.y+1 < height else height-1;
		if len(options[menu_cursor.y]) <= len(options[menu_cursor.y-1]):#if the next state has less width resets
			#sets the x in the range except when is bigger than the width
			previous_cursor_x = menu_cursor.x;
			menu_cursor.x = len(options[menu_cursor.y])-1 if menu_cursor.x >= len(options[menu_cursor.y]) else menu_cursor.x;
		else:
			menu_cursor.x = previous_cursor_x;
	elif Input.is_action_just_released("right"): #right movement
		# increases x valor and remains width - 1 if it's greather than width
		$MenuMovement.play();
		menu_cursor.x = menu_cursor.x+1 if menu_cursor.x+1 < width else width-1;
	elif Input.is_action_just_released("left"):
		#decreses x valor and remains 0 if it's smaller than 0
		$MenuMovement.play();
		menu_cursor.x = menu_cursor.x-1 if menu_cursor.x-1>0 else 0;
	######## focus the new element
	options[menu_cursor.y][menu_cursor.x].grab_focus();
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("start"):
		print("apretado A");
		options[menu_cursor.y][menu_cursor.x].emit_signal("button_down");

############ Menu buttons signals
########### Initial options
## Continue:
func _on_continue_button_down() -> void:
	if $InitialOptions/Continue.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
## Start:
func _on_start_game_button_down() -> void:
	if $InitialOptions/StartGame.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		GameMaster.world = 1;
		GameMaster.level = 1;
		#intializes game:
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Tutorial:
func _on_tutorial_button_down() -> void:
	if $InitialOptions/Tutorial.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
## ToWorldMenu:
func _on_to_world_menu_button_down() -> void:
	if $InitialOptions/ToWorldMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("initial","world");
		actual_menu = "world";
		$MenuSelect.play(); #plays this sound
## Credits:
func _on_credits_button_down() -> void:
	if $InitialOptions/Credits.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound.
		GameMaster.credits_from_menu = true;
		get_tree().change_scene_to_file("res://Scenes/credits.tscn"); #starts the credits
## Exit:
func _on_exit_button_down() -> void:
	if $InitialOptions/Exit.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.exit();
############# World Menu
## World1:
func _on_world_1_button_down() -> void:
	if $WorldMenu/Worlds1/World1.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 1;
		change_menu("world","level");
		actual_menu = "level";
		toogle_variable_presentation(1);
## World 2:
func _on_world_2_button_down() -> void:
	if $WorldMenu/Worlds1/World2.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 2;
		change_menu("world","level");
		actual_menu = "level";
		toogle_variable_presentation(2);
## World 3:
func _on_world_3_button_down() -> void:
	if $WorldMenu/Worlds1/World3.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 3;
		change_menu("world","level");
		actual_menu = "level";
		toogle_variable_presentation(3);
## World 4:
func _on_world_4_button_down() -> void:
	if $WorldMenu/Worlds2/World4.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 4;
		change_menu("world","level");
		actual_menu = "level";
		toogle_variable_presentation(4);
## World 5:
func _on_world_5_button_down() -> void:
	if $WorldMenu/Worlds2/World5.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 5;
		change_menu("world","level");
		actual_menu = "level";
		toogle_variable_presentation(5);
## World 6:
func _on_world_6_button_down() -> void:
	if $WorldMenu/Worlds2/World6.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 6;
		change_menu("world","level");
		actual_menu = "level";
		toogle_variable_presentation(6);
## Initial menu:
func _on_to_initial_options_button_down() -> void:
	if $WorldMenu/ToInitialOptions.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("world","initial");
		actual_menu = "initial";
		toogle_variable_presentation(1);
		$MenuSelect.play(); #plays this sound
		
################## Level Menu
## Level 1:
func _on_level_1_button_down() -> void:
	if $LevelMenu/Levels1/Level1.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 1;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 2:
func _on_level_2_button_down() -> void:
	if $LevelMenu/Levels1/Level2.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 2;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 3:
func _on_level_3_button_down() -> void:
	if $LevelMenu/Levels1/Level3.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 3;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 4:
func _on_level_4_button_down() -> void:
	if $LevelMenu/Levels2/Level4.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 4;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 5:
func _on_level_5_button_down() -> void:
	if $LevelMenu/Levels2/Level5.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 5;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 6:
func _on_level_6_button_down() -> void:
	if $LevelMenu/Levels2/Level6.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 6;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Initial options:
func _on_main_menu_button_down() -> void:
	if $LevelMenu/HBoxContainer/MainMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("level","initial")
		actual_menu = "initial";
		toogle_variable_presentation(1);
		$MenuSelect.play(); #plays this sound
## World menu:
func _on_world_menu_button_down() -> void:
	if $LevelMenu/HBoxContainer/WorldMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("level","world");
		actual_menu = "world";
		toogle_variable_presentation(1);
		$MenuSelect.play(); #plays this sound
