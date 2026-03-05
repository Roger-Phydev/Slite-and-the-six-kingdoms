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
var selection_enabled = true;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_indicator(0);
	####### Basic configuration
	GameMaster.coinsCount = 0;
	GameMaster.hits = 3;
	GameMaster.hero_mode = false;
	####### Music
	$MainMenuMusic.play(); #begins the music as far as is ready
	$MenuMovement.volume_db = 20;
	####### Animations
	#menu
	$Roger/AnimationPlayer.play("blinkandwaving"); #my name animation
	$Info/AnimationPlayer.play("waving"); #info about menu animation
	$MenuBg/AnimationPlayer.play("waving"); #menu movement animation
	$Title/AnimationPlayer.play("blink"); #title
	############	
	$Background/Sun/AnimationPlayer.play("shine"); #sun
	for bird in $elements/Birds.get_children(): #birds
		bird.get_children()[0].play("fly");
	$"Variable presentation/Slite/AnimationPlayer".play("idle"); #slite
	$"Variable presentation/Chest/AnimationPlayer".play("idle_close"); #chest
	#coins for level indicator:
	$"Variable presentation/LevelIndicator/Coin1/AnimationPlayer".play("spin");
	$"Variable presentation/LevelIndicator/Coin2/AnimationPlayer".play("spin");
	$"Variable presentation/LevelIndicator/Coin3/AnimationPlayer".play("spin");
	$"Variable presentation/LevelIndicator/Coin4/AnimationPlayer".play("spin");
	$"Variable presentation/LevelIndicator/Coin5/AnimationPlayer".play("spin");
	$"Variable presentation/LevelIndicator/Coin6/AnimationPlayer".play("spin");
	$"Variable presentation/WorldBackgrounds/World6/Ckeckpoint/AnimationPlayer".play("move");
	$"Variable presentation/WorldBackgrounds/World6/Ckeckpoint2/AnimationPlayer".play("move");
	############# disableding buttons without use
	$MenuBg/InitialOptions/Continue.disabled = true;
	############# setting menu_options
	menu_options = [
		[$MenuBg/InitialOptions/Continue],
		[$MenuBg/InitialOptions/StartGame],
		[$MenuBg/InitialOptions/HBoxContainer/Tutorial,$MenuBg/InitialOptions/HBoxContainer/FirstScene],
		[$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu,$MenuBg/InitialOptions/HBoxContainer2/Credits],
		[$MenuBg/InitialOptions/Exit]
	];
	############# Setting mouse actions to display info
	$MenuBg/InitialOptions/Continue.mouse_entered.connect(continue_info);
	$MenuBg/InitialOptions/StartGame.mouse_entered.connect(start_info);
	$MenuBg/InitialOptions/HBoxContainer/Tutorial.mouse_entered.connect(tutorial_info);
	$MenuBg/InitialOptions/HBoxContainer/FirstScene.mouse_entered.connect(first_scene_info);
	$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.mouse_entered.connect(to_world_initial_info);
	$MenuBg/InitialOptions/HBoxContainer2/Credits.mouse_entered.connect(credits_info);
	$MenuBg/InitialOptions/Exit.mouse_entered.connect(exit_info);
	$MenuBg/WorldMenu/Worlds1/World1.mouse_entered.connect(world_1_info);
	$MenuBg/WorldMenu/Worlds1/World2.mouse_entered.connect(world_2_info);
	$MenuBg/WorldMenu/Worlds1/World3.mouse_entered.connect(world_3_info);
	$MenuBg/WorldMenu/Worlds2/World4.mouse_entered.connect(world_4_info);
	$MenuBg/WorldMenu/Worlds2/World5.mouse_entered.connect(world_5_info);
	$MenuBg/WorldMenu/Worlds2/World6.mouse_entered.connect(world_6_info);
	$MenuBg/WorldMenu/ToInitialOptions.mouse_entered.connect(to_world_info);
	$MenuBg/LevelMenu/Levels1/Level1.mouse_entered.connect(level_1_info);
	$MenuBg/LevelMenu/Levels1/Level2.mouse_entered.connect(level_2_info);
	$MenuBg/LevelMenu/Levels1/Level3.mouse_entered.connect(level_3_info);
	$MenuBg/LevelMenu/Levels2/Level4.mouse_entered.connect(level_4_info);
	$MenuBg/LevelMenu/Levels2/Level5.mouse_entered.connect(level_5_info);
	$MenuBg/LevelMenu/Levels2/Level6.mouse_entered.connect(level_6_info);
	$MenuBg/LevelMenu/HBoxContainer/MainMenu.mouse_entered.connect(to_initial_options_info);
	$MenuBg/LevelMenu/HBoxContainer/WorldMenu.mouse_entered.connect(to_world_info);
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
	if $elements/Birds.position.x > -2600:
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
			$MenuSelect.play(); #plays this sound
		elif actual_menu == "level":
			change_menu("level","world");
			actual_menu = "world";
			toogle_variable_presentation(1);
			$"Variable presentation/Chest/AnimationPlayer".play("close");
			$MenuSelect.play(); #plays this sound
			set_level_indicator(0);
			selection_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_close");
		else:
			$MenuDisabled.play();
###################################
# Functions
###################################
# jumping menus:
func change_menu(menu_from:String,menu_to:String):
	# hides the previous menu
	if menu_from == "initial":
		$MenuBg/InitialOptions.visible = false;
	elif menu_from == "world":
		$MenuBg/WorldMenu.visible = false;
	elif menu_from == "level":
		$MenuBg/LevelMenu.visible = false;
	# shows the next menu and sets the options
	if menu_to == "initial":
		menu_options = [
			[$MenuBg/InitialOptions/Continue],
			[$MenuBg/InitialOptions/StartGame],
			[$MenuBg/InitialOptions/HBoxContainer/Tutorial,$MenuBg/InitialOptions/HBoxContainer/FirstScene],
			[$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu,$MenuBg/InitialOptions/HBoxContainer2/Credits],
			[$MenuBg/InitialOptions/Exit]
		];
		$MenuBg/InitialOptions.visible = true;
	elif menu_to == "world":
		menu_options = [
			[$MenuBg/WorldMenu/Worlds1/World1,$MenuBg/WorldMenu/Worlds1/World2,$MenuBg/WorldMenu/Worlds1/World3],
			[$MenuBg/WorldMenu/Worlds2/World4,$MenuBg/WorldMenu/Worlds2/World5,$MenuBg/WorldMenu/Worlds2/World6],
			[$MenuBg/WorldMenu/ToInitialOptions]
		];
		$MenuBg/WorldMenu.visible = true;
	elif menu_to == "level":
		menu_options = [
			[$MenuBg/LevelMenu/Levels1/Level1,$MenuBg/LevelMenu/Levels1/Level2,$MenuBg/LevelMenu/Levels1/Level3],
			[$MenuBg/LevelMenu/Levels2/Level4,$MenuBg/LevelMenu/Levels2/Level5,$MenuBg/LevelMenu/Levels2/Level6],
			[$MenuBg/LevelMenu/HBoxContainer/MainMenu,$MenuBg/LevelMenu/HBoxContainer/WorldMenu]
		];
		$MenuBg/LevelMenu.visible = true;
	menu_cursor = Vector2(0,0); #resetea el cursor del menú
# Changing secondary visuals:
func toogle_variable_presentation(world:int):
	#get invisible every background
	for bg in $"Variable presentation/WorldBackgrounds".get_children():
		bg.visible = false;
	#then makes visible the world set in input
	$"Variable presentation/WorldBackgrounds".get_children()[world-1].visible = true;
func set_level_indicator(l:int):
	var coins = $"Variable presentation/LevelIndicator".get_children();
	for i in range(6):
		coins[i].visible = i<l; #only makes visible the first l elements
	if l == 1:
		$"Variable presentation/LevelIndicator/Coin1".position = Vector2i(-184,256);
	elif l == 2:
		$"Variable presentation/LevelIndicator/Coin1".position = Vector2(-192,264);
		$"Variable presentation/LevelIndicator/Coin2".position = Vector2(-168,240);
	elif l == 3:
		$"Variable presentation/LevelIndicator/Coin1".position = Vector2(-208,264);
		$"Variable presentation/LevelIndicator/Coin2".position = Vector2(-192,232);
		$"Variable presentation/LevelIndicator/Coin3".position = Vector2(-176,264);
	elif l == 4:
		$"Variable presentation/LevelIndicator/Coin1".position = Vector2(-208,264);
		$"Variable presentation/LevelIndicator/Coin2".position = Vector2(-208,232);
		$"Variable presentation/LevelIndicator/Coin3".position = Vector2(-176,232);
		$"Variable presentation/LevelIndicator/Coin4".position = Vector2(-176,264);
	elif l == 5:
		$"Variable presentation/LevelIndicator/Coin1".position = Vector2(-208,264);
		$"Variable presentation/LevelIndicator/Coin2".position = Vector2(-216,232);
		$"Variable presentation/LevelIndicator/Coin3".position = Vector2(-188,208);
		$"Variable presentation/LevelIndicator/Coin4".position = Vector2(-160,232);
		$"Variable presentation/LevelIndicator/Coin5".position = Vector2(-168,264);
	elif l == 6:
		$"Variable presentation/LevelIndicator/Coin1".position = Vector2(-208,264);
		$"Variable presentation/LevelIndicator/Coin2".position = Vector2(-216,232);
		$"Variable presentation/LevelIndicator/Coin3".position = Vector2(-188,208);
		$"Variable presentation/LevelIndicator/Coin4".position = Vector2(-160,232);
		$"Variable presentation/LevelIndicator/Coin5".position = Vector2(-168,264);
		$"Variable presentation/LevelIndicator/Coin6".position = Vector2(-188,240);
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
	options[menu_cursor.y][menu_cursor.x].emit_signal("mouse_entered");
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("start"):
		options[menu_cursor.y][menu_cursor.x].emit_signal("button_down");

############ Menu buttons signals
########### Initial options
## Continue:
func _on_continue_button_down() -> void:
	if $MenuBg/InitialOptions/Continue.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
## Start:
func _on_start_game_button_down() -> void:
	if $MenuBg/InitialOptions/StartGame.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		GameMaster.world = 1;
		GameMaster.level = 1;
		GameMaster.hero_mode = false;
		GameMaster.coinsCount = 0;
		#intializes game:
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Tutorial:
func _on_tutorial_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.start_tutorial();
## First Scene:
func _on_first_scene_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer/FirstScene.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		get_tree().change_scene_to_file("res://Scenes/initial_scene.tscn");
## ToWorldMenu:
func _on_to_world_menu_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		GameMaster.hero_mode = false;
		change_menu("initial","world");
		actual_menu = "world";
		$Info/OptionInfo.add_theme_font_size_override("font_size",60);
		$MenuSelect.play(); #plays this sound
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
## Credits:
func _on_credits_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer2/Credits.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound.
		GameMaster.credits_from_menu = true;
		get_tree().change_scene_to_file("res://Scenes/credits.tscn"); #starts the credits
## Exit:
func _on_exit_button_down() -> void:
	if $MenuBg/InitialOptions/Exit.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.exit();
############# World Menu
## World1:
func _on_world_1_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds1/World1.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 1;
		change_menu("world","level");
		$"Variable presentation/Chest/AnimationPlayer".play("open");
		actual_menu = "level";
		toogle_variable_presentation(1);
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 2:
func _on_world_2_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds1/World2.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 2;
		change_menu("world","level");
		$"Variable presentation/Chest/AnimationPlayer".play("open");
		actual_menu = "level";
		toogle_variable_presentation(2);
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 3:
func _on_world_3_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds1/World3.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 3;
		change_menu("world","level");
		$"Variable presentation/Chest/AnimationPlayer".play("open");
		actual_menu = "level";
		toogle_variable_presentation(3);
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 4:
func _on_world_4_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds2/World4.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 4;
		change_menu("world","level");
		$"Variable presentation/Chest/AnimationPlayer".play("open");
		actual_menu = "level";
		toogle_variable_presentation(4);
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 5:
func _on_world_5_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds2/World5.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 5;
		change_menu("world","level");
		actual_menu = "level";
		$"Variable presentation/Chest/AnimationPlayer".play("open");
		toogle_variable_presentation(5);
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 6:
func _on_world_6_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds2/World6.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		$MenuSelect.play(); #plays this sound
		GameMaster.world = 6;
		change_menu("world","level");
		$"Variable presentation/Chest/AnimationPlayer".play("open");
		actual_menu = "level";
		toogle_variable_presentation(6);
		selection_enabled = false;
		$Info/OptionInfo.text = "Selecciona una opción";
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## Initial menu:
func _on_to_initial_options_button_down() -> void:
	if $MenuBg/WorldMenu/ToInitialOptions.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("world","initial");
		actual_menu = "initial";
		toogle_variable_presentation(1);
		set_level_indicator(0);
		$MenuSelect.play(); #plays this sound
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Selecciona una opción";
		
################## Level Menu
## Level 1:
func _on_level_1_button_down() -> void:
	if $MenuBg/LevelMenu/Levels1/Level1.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 1;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 2:
func _on_level_2_button_down() -> void:
	if $MenuBg/LevelMenu/Levels1/Level2.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 2;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 3:
func _on_level_3_button_down() -> void:
	if $MenuBg/LevelMenu/Levels1/Level3.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 3;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 4:
func _on_level_4_button_down() -> void:
	if $MenuBg/LevelMenu/Levels2/Level4.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 4;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 5:
func _on_level_5_button_down() -> void:
	if $MenuBg/LevelMenu/Levels2/Level5.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 5;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 6:
func _on_level_6_button_down() -> void:
	if $MenuBg/LevelMenu/Levels2/Level6.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		#sets basic configuration
		GameMaster.level = 6;
		$MenuSelect.play(); #plays this sound
		GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Initial options:
func _on_main_menu_button_down() -> void:
	if $MenuBg/LevelMenu/HBoxContainer/MainMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("level","initial")
		actual_menu = "initial";
		toogle_variable_presentation(1);
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$"Variable presentation/Chest/AnimationPlayer".play("close");
		$MenuSelect.play(); #plays this sound
		set_level_indicator(0);
		$Info/OptionInfo.text = "Selecciona una opción";
		selection_enabled = false;
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_close");
## World menu:
func _on_world_menu_button_down() -> void:
	if $MenuBg/LevelMenu/HBoxContainer/WorldMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		change_menu("level","world");
		actual_menu = "world";
		toogle_variable_presentation(1);
		$"Variable presentation/Chest/AnimationPlayer".play("close");
		$MenuSelect.play(); #plays this sound
		set_level_indicator(0);
		$Info/OptionInfo.text = "Selecciona una opción";
		selection_enabled = false;
		await get_tree().create_timer(0.5).timeout;
		selection_enabled = true;
		$"Variable presentation/Chest/AnimationPlayer".play("idle_close");
## Signal control for info data
func continue_info():
	$"Variable presentation/Chest/AnimationPlayer".play("idle_close");
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Continua tu partida donde la dejaste, aún en desarrollo";
func start_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Inicia la aventura desde el principio";
func tutorial_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Juega el tutorial para aprender los controles y a lo que te enfrentarás";
func first_scene_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Ponte en contexto con una breve narrativa de la historia hasta ahora";
func to_world_initial_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Selecciona un nivel para jugar";
func credits_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Mira la escena de créditos, agradeciendo a los que hicieron posible esto";
func exit_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Al seleccionar esto, saldrás del juego";
func world_1_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Reino del Bosque";
		toogle_variable_presentation(1);
func world_2_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Reino de la Tierra";
		toogle_variable_presentation(2);
func world_3_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Reino de las Arenas";
		toogle_variable_presentation(3);
func world_4_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Reino del Mar";
		toogle_variable_presentation(4);
func world_5_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Reino del Hielo";
		toogle_variable_presentation(5);
func world_6_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Reino del Fuego";
		toogle_variable_presentation(6);
func to_initial_options_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Vuelve al menú inicial";
func level_1_info():
	if selection_enabled:
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 1 del "+worlds[GameMaster.world-1];
		set_level_indicator(1);
func level_2_info():
	if selection_enabled:
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 2 del "+worlds[GameMaster.world-1];
		set_level_indicator(2);
func level_3_info():
	if selection_enabled:
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 3 del "+worlds[GameMaster.world-1];
		set_level_indicator(3);
func level_4_info():
	if selection_enabled:
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 4 del "+worlds[GameMaster.world-1];
		set_level_indicator(4);
func level_5_info():
	if selection_enabled:
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 5 del "+worlds[GameMaster.world-1];
		set_level_indicator(5);
func level_6_info():
	if selection_enabled:
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 6 del "+worlds[GameMaster.world-1];
		set_level_indicator(6);
func to_world_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Vuelve a la selección de mundo";
