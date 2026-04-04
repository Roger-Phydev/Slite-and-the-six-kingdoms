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
var buttons_enabled = true;
const reset_save_combination = ["right","right","left","left","cancel","cancel"];
const unlock_all_levels_combination = ["right","left","right","left","start","start"];
const unlock_all_combination = ["left","right","left","right","start","start"];
var input_sequence = [];
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checking_disabled_buttons();
	# OS.shell_open(ProjectSettings.globalize_path("user://"));
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
	############# setting menu_options
	menu_options = [
		[$MenuBg/InitialOptions/Continue],
		[$MenuBg/InitialOptions/StartGame],
		[$MenuBg/InitialOptions/HBoxContainer/Tutorial,$MenuBg/InitialOptions/HBoxContainer/FirstScene],
		[$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu,$MenuBg/InitialOptions/HBoxContainer2/Credits],
		[$MenuBg/InitialOptions/HeroMode],
		[$MenuBg/InitialOptions/Exit]
	];
	############# Setting mouse actions to display info
	$MenuBg/InitialOptions/Continue.mouse_entered.connect(continue_info);
	$MenuBg/InitialOptions/StartGame.mouse_entered.connect(start_info);
	$MenuBg/InitialOptions/HBoxContainer/Tutorial.mouse_entered.connect(tutorial_info);
	$MenuBg/InitialOptions/HBoxContainer/FirstScene.mouse_entered.connect(first_scene_info);
	$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.mouse_entered.connect(to_world_initial_info);
	$MenuBg/InitialOptions/HBoxContainer2/Credits.mouse_entered.connect(credits_info);
	$MenuBg/InitialOptions/HeroMode.mouse_entered.connect(hero_mode_info);
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
	check_codes();
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
# disabled or enabling things:
func checking_disabled_buttons():
	var data = SaveManager.load_game();
	if not data["initial_scene_watched"]: #not initial scene saw
		$MenuBg/InitialOptions/Continue.disabled = true;
		$MenuBg/InitialOptions/StartGame.disabled = true;
		$MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled = true;
		$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled = true;
		$MenuBg/InitialOptions/HBoxContainer2/Credits.disabled = true;
		$MenuBg/InitialOptions/HeroMode.disabled = true;
	else:
		if not data["tutorial_completed"]: #not tutorial completed
			$MenuBg/InitialOptions/Continue.disabled = true;
			$MenuBg/InitialOptions/StartGame.disabled = true;
			$MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled = false;
			$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled = true;
			$MenuBg/InitialOptions/HBoxContainer2/Credits.disabled = true;
			$MenuBg/InitialOptions/HeroMode.disabled = true;
		else:
			$MenuBg/InitialOptions/Continue.disabled = true;
			$MenuBg/InitialOptions/StartGame.disabled = false;
			$MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled = false;
			$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled = true;
			$MenuBg/InitialOptions/HBoxContainer2/Credits.disabled = true;
			$MenuBg/InitialOptions/HeroMode.disabled = true;
			if SaveManager.is_world_available(1):
				$MenuBg/InitialOptions/Continue.disabled = false;
				$MenuBg/InitialOptions/StartGame.disabled = false;
				$MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled = false;
				$MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled = false;
				$MenuBg/InitialOptions/HBoxContainer2/Credits.disabled = true;
				disable_worlds_buttons();
	checking_secundary_goals();
func checking_secundary_goals():
	set_progress_elements("success",SaveManager.is_normal_game_completed());
	set_progress_elements("hero",SaveManager.is_hero_game_completed());
	if SaveManager.is_normal_game_completed():
		$MenuBg/InitialOptions/HBoxContainer2/Credits.disabled = false;
		$MenuBg/InitialOptions/HeroMode.disabled = false;
func disable_worlds_buttons():
	var buttons = [
		$MenuBg/WorldMenu/Worlds1/World1,
		$MenuBg/WorldMenu/Worlds1/World2,
		$MenuBg/WorldMenu/Worlds1/World3,
		$MenuBg/WorldMenu/Worlds2/World4,
		$MenuBg/WorldMenu/Worlds2/World5,
		$MenuBg/WorldMenu/Worlds2/World6
	]
	for i in range(1,7):
		buttons[i-1].disabled = not SaveManager.is_world_available(i);
func disable_levels_buttons_for_world(world:int):
	var buttons = [
		$MenuBg/LevelMenu/Levels1/Level1,
		$MenuBg/LevelMenu/Levels1/Level2,
		$MenuBg/LevelMenu/Levels1/Level3,
		$MenuBg/LevelMenu/Levels2/Level4,
		$MenuBg/LevelMenu/Levels2/Level5,
		$MenuBg/LevelMenu/Levels2/Level6
	]
	for i in range(1,7):
		buttons[i-1].disabled = not SaveManager.is_level_completed(world,i);
#Printing codes info
func check_codes():
	if input_sequence == reset_save_combination:
		SaveManager.reset_save_data();
		print_codes_info("Código activado\nGuardado reiniciado");
	elif input_sequence == unlock_all_levels_combination:
		SaveManager.unlock_all_levels();
		print_codes_info("Código activado\nNiveles desbloqueados");
	elif input_sequence == unlock_all_combination:
		SaveManager.unlock_all();
		print_codes_info("Código activado\nTodo desbloqueado!");
func print_codes_info(message:String):
	$Codes/CodeInfo.text = message;
	$Codes.visible = true;
	$Codes/AnimationPlayer.play("showing");
	buttons_enabled = false
	await get_tree().create_timer(2.2).timeout;
	buttons_enabled = true;
	checking_disabled_buttons();
	$Codes.visible = false;
	input_sequence = [];
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
		if on:
			$"Variable presentation/Success/AnimationPlayer".play("moving");
		else:
			$"Variable presentation/Success/AnimationPlayer".pause();
	elif type == "hero":
		$"Variable presentation/HeroMode".visible = on;
		if on:
			$"Variable presentation/HeroMode/AnimationPlayer".play("moving");
		else:
			$"Variable presentation/HeroMode/AnimationPlayer".pause();
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
		if buttons_enabled:
			var res = SaveManager.get_latest_world_level();
			GameMaster.world = res[0];
			GameMaster.level = res[1];
			GameMaster.hero_mode = false;
			GameMaster.coinsCount = 0;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Start:
func _on_start_game_button_down() -> void:
	if $MenuBg/InitialOptions/StartGame.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			GameMaster.world = 1;
			GameMaster.level = 1;
			GameMaster.hero_mode = false;
			GameMaster.coinsCount = 0;
			#intializes game:
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Tutorial:
func _on_tutorial_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			GameMaster.start_tutorial();
			buttons_enabled = true;
## First Scene:
func _on_first_scene_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer/FirstScene.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			get_tree().change_scene_to_file("res://Scenes/initial_scene.tscn");
## ToWorldMenu:
func _on_to_world_menu_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			GameMaster.hero_mode = false;
			change_menu("initial","world");
			actual_menu = "world";
			$Info/OptionInfo.add_theme_font_size_override("font_size",60);
			$MenuSelect.play(); #plays this sound
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			await get_tree().create_timer(0.5).timeout;
			selection_enabled = true;
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
## Credits:
func _on_credits_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer2/Credits.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound.
			GameMaster.credits_from_menu = true;
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			if SaveManager.is_hero_game_completed():
				GameMaster.hero_mode = true;
			else:
				GameMaster.hero_mode = false;
			get_tree().change_scene_to_file("res://Scenes/credits.tscn"); #starts the credits
## Hero mode!:
func _on_hero_mode_button_down() -> void:
	if $MenuBg/InitialOptions/HBoxContainer2/Credits.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound.
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_hero_mode();
## Exit:
func _on_exit_button_down() -> void:
	if $MenuBg/InitialOptions/Exit.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.exit();
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
############# World Menu
## World1:
func _on_world_1_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds1/World1.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.world = 1;
			change_menu("world","level");
			$"Variable presentation/Chest/AnimationPlayer".play("open");
			actual_menu = "level";
			toogle_variable_presentation(1);
			disable_levels_buttons_for_world(1);
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 2:
func _on_world_2_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds1/World2.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.world = 2;
			change_menu("world","level");
			$"Variable presentation/Chest/AnimationPlayer".play("open");
			actual_menu = "level";
			toogle_variable_presentation(2);
			disable_levels_buttons_for_world(2);
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 3:
func _on_world_3_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds1/World3.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.world = 3;
			change_menu("world","level");
			$"Variable presentation/Chest/AnimationPlayer".play("open");
			actual_menu = "level";
			toogle_variable_presentation(3);
			disable_levels_buttons_for_world(3);
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 4:
func _on_world_4_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds2/World4.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.world = 4;
			change_menu("world","level");
			$"Variable presentation/Chest/AnimationPlayer".play("open");
			actual_menu = "level";
			toogle_variable_presentation(4);
			disable_levels_buttons_for_world(4);
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 5:
func _on_world_5_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds2/World5.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.world = 5;
			change_menu("world","level");
			actual_menu = "level";
			$"Variable presentation/Chest/AnimationPlayer".play("open");
			toogle_variable_presentation(5);
			disable_levels_buttons_for_world(5);
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## World 6:
func _on_world_6_button_down() -> void:
	if $MenuBg/WorldMenu/Worlds2/World6.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			$MenuSelect.play(); #plays this sound
			GameMaster.world = 6;
			change_menu("world","level");
			$"Variable presentation/Chest/AnimationPlayer".play("open");
			actual_menu = "level";
			toogle_variable_presentation(6);
			disable_levels_buttons_for_world(6);
			selection_enabled = false;
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_open");
## Initial menu:
func _on_to_initial_options_button_down() -> void:
	if $MenuBg/WorldMenu/ToInitialOptions.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			change_menu("world","initial");
			actual_menu = "initial";
			toogle_variable_presentation(1);
			set_level_indicator(0);
			$MenuSelect.play(); #plays this sound
			$Info/OptionInfo.add_theme_font_size_override("font_size",40);
			$Info/OptionInfo.text = "Selecciona una opción";
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
		
################## Level Menu
## Level 1:
func _on_level_1_button_down() -> void:
	if $MenuBg/LevelMenu/Levels1/Level1.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			#sets basic configuration
			GameMaster.level = 1;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 2:
func _on_level_2_button_down() -> void:
	if $MenuBg/LevelMenu/Levels1/Level2.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			#sets basic configuration
			GameMaster.level = 2;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 3:
func _on_level_3_button_down() -> void:
	if $MenuBg/LevelMenu/Levels1/Level3.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			#sets basic configuration
			GameMaster.level = 3;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 4:
func _on_level_4_button_down() -> void:
	if $MenuBg/LevelMenu/Levels2/Level4.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			#sets basic configuration
			GameMaster.level = 4;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 5:
func _on_level_5_button_down() -> void:
	if $MenuBg/LevelMenu/Levels2/Level5.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			#sets basic configuration
			GameMaster.level = 5;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Level 6:
func _on_level_6_button_down() -> void:
	if $MenuBg/LevelMenu/Levels2/Level6.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			#sets basic configuration
			GameMaster.level = 6;
			$MenuSelect.play(); #plays this sound
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			GameMaster.start_world_level_scene(GameMaster.world,GameMaster.level);
## Initial options:
func _on_main_menu_button_down() -> void:
	if $MenuBg/LevelMenu/HBoxContainer/MainMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			change_menu("level","initial")
			actual_menu = "initial";
			toogle_variable_presentation(1);
			$Info/OptionInfo.add_theme_font_size_override("font_size",40);
			$"Variable presentation/Chest/AnimationPlayer".play("close");
			$MenuSelect.play(); #plays this sound
			set_level_indicator(0);
			$Info/OptionInfo.text = "Selecciona una opción";
			selection_enabled = false;
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_close");
## World menu:
func _on_world_menu_button_down() -> void:
	if $MenuBg/LevelMenu/HBoxContainer/WorldMenu.disabled: #if it's disabled
		$MenuDisabled.play(); #plays this sound
	else:
		if buttons_enabled:
			change_menu("level","world");
			actual_menu = "world";
			toogle_variable_presentation(1);
			$"Variable presentation/Chest/AnimationPlayer".play("close");
			$MenuSelect.play(); #plays this sound
			set_level_indicator(0);
			$Info/OptionInfo.text = "Selecciona una opción";
			selection_enabled = false;
			buttons_enabled = false;
			await get_tree().create_timer(0.5).timeout;
			buttons_enabled = true;
			selection_enabled = true;
			$"Variable presentation/Chest/AnimationPlayer".play("idle_close");
## Signal control for info data
func continue_info():
	if $MenuBg/InitialOptions/Continue.disabled:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Inicia una aventura para desbloquear";
	else:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Continua tu partida desde el nivel en que lo dejaste";
func start_info():
	if $MenuBg/InitialOptions/StartGame.disabled:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Para poder iniciar una aventura primero juega el tutorial";
	else:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Inicia la aventura desde el principio";
func tutorial_info():
	if $MenuBg/InitialOptions/HBoxContainer/Tutorial.disabled:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Mira la escena principal para desbloquear";
	else:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Juega el tutorial para aprender los controles y a lo que te enfrentarás";
func first_scene_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Ponte en contexto con una breve narrativa de la historia hasta ahora";
func to_world_initial_info():
	if $MenuBg/InitialOptions/HBoxContainer2/ToWorldMenu.disabled:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Disponible una vez hayas pasado algún nivel";
	else:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Selecciona un nivel que hayas pasado para jugar";
func credits_info():
	if $MenuBg/InitialOptions/HBoxContainer2/Credits.disabled:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Termina el juego para poder ver los créditos";
	else:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Mira la escena de créditos, con todos los agradecimientos";
func hero_mode_info():
	if $MenuBg/InitialOptions/HBoxContainer2/Credits.disabled:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Termina el juego para poder jugar este modo";
	else:
		$Info/OptionInfo.add_theme_font_size_override("font_size",40);
		$Info/OptionInfo.text = "Pasa toda la aventura con vidas limitadas sin guardado, el modo definitivo está aquí!";
func exit_info():
	$Info/OptionInfo.add_theme_font_size_override("font_size",40);
	$Info/OptionInfo.text = "Al seleccionar esto, saldrás del juego";
func world_1_info():
	if SaveManager.is_world_available(1):
		$Info/OptionInfo.text = "Reino del Bosque";
		toogle_variable_presentation(1);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este Reino";
		toogle_variable_presentation(1);
func world_2_info():
	if SaveManager.is_world_available(2):
		$Info/OptionInfo.text = "Reino de la Tierra";
		toogle_variable_presentation(2);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este Reino";
		toogle_variable_presentation(1);
func world_3_info():
	if SaveManager.is_world_available(3):
		$Info/OptionInfo.text = "Reino de las Arenas";
		toogle_variable_presentation(3);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este Reino";
		toogle_variable_presentation(1);
func world_4_info():
	if SaveManager.is_world_available(4):
		$Info/OptionInfo.text = "Reino del Mar";
		toogle_variable_presentation(4);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este Reino";
		toogle_variable_presentation(1);
func world_5_info():
	if SaveManager.is_world_available(5):
		$Info/OptionInfo.text = "Reino del Hielo";
		toogle_variable_presentation(5);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este Reino";
		toogle_variable_presentation(1);
func world_6_info():
	if SaveManager.is_world_available(6):
		$Info/OptionInfo.text = "Reino del Fuego";
		toogle_variable_presentation(6);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este Reino";
		toogle_variable_presentation(1);
func to_initial_options_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Vuelve al menú inicial";
func level_1_info():
	if SaveManager.is_level_completed(GameMaster.world,1):
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 1 del "+worlds[GameMaster.world-1];
		set_level_indicator(1);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este nivel";
		set_level_indicator(0);
func level_2_info():
	if SaveManager.is_level_completed(GameMaster.world,2):
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 2 del "+worlds[GameMaster.world-1];
		set_level_indicator(2);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este nivel";
		set_level_indicator(0);
func level_3_info():
	if SaveManager.is_level_completed(GameMaster.world,3):
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 3 del "+worlds[GameMaster.world-1];
		set_level_indicator(3);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este nivel";
		set_level_indicator(0);
func level_4_info():
	if SaveManager.is_level_completed(GameMaster.world,4):
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 4 del "+worlds[GameMaster.world-1];
		set_level_indicator(4);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este nivel";
		set_level_indicator(0);
func level_5_info():
	if SaveManager.is_level_completed(GameMaster.world,5):
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 5 del "+worlds[GameMaster.world-1];
		set_level_indicator(5);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este nivel";
		set_level_indicator(0);
func level_6_info():
	if SaveManager.is_level_completed(GameMaster.world,6):
		var worlds = ["Reino del Bosque","Reino de la Tierra","Reino de las Arenas","Reino del Mar","Reino del Hielo","Reino del Fuego"];
		$Info/OptionInfo.text = "Jugar nivel 6 del "+worlds[GameMaster.world-1];
		set_level_indicator(6);
	else:
		$Info/OptionInfo.text = "Sigue jugando para desbloquear este nivel";
		set_level_indicator(0);
func to_world_info():
	if selection_enabled:
		$Info/OptionInfo.text = "Vuelve a la selección de mundo";
# input reception and lecture:
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		const keys = ["left","right","start","cancel"];
		for key in keys:
			if event.is_action_released(key):
				input_sequence.append(key);
		if len(input_sequence)>6:
			input_sequence.pop_front();
		print(input_sequence);
