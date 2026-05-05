extends Control

# Selection and variables:
@onready var playing_interface = $PlayingInterface; #selects the score panel
@onready var target_coins = $PlayingInterface/Score/target; #selects coins number
@onready var coins_number = $PlayingInterface/Score/coinsNumber; #selects the label of coins number
@onready var lifes_number = $PlayingInterface/Lifes/LifesNumber; #selects the label of lifes number
@onready var first_heart = $PlayingInterface/Damage/heartIcon; #selects the first heart
@onready var second_heart = $PlayingInterface/Damage/heartIcon2; #selects the second heart
@onready var third_heart = $PlayingInterface/Damage/heartIcon3; #selects the third heart
@onready var pause_menu = $PauseMenu; #selects the pause menu
@onready var win_menu = $WinMenu; #selects the win menu
@onready var loose_menu = $LooseMenu; #selects the loose menu
@onready var resume_time = 0.0;
@onready var menu_cursor = Vector2(0,0);
@onready var previous_cursor_x = 0;
@onready var menu_options = [];
@onready var menu_focus = false;
@onready var button_enabled = false;
var pause = true;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	###################################
	# Setting mouse focus
	###################################
	var buttons = $PauseMenu/Panel/VBoxContainer.get_children()+$LooseMenu/Panel/VBoxContainer.get_children()+$WinMenu/Panel/VBoxContainer.get_children();
	for element in buttons:
		if element.get_child_count() != 0:
			for subelement in element.get_children():
				print(subelement);
				if subelement.get_class() == "Button":
					subelement.mouse_entered.connect(mouse_focus.bind(subelement))
		else:
			if element.get_class() == "Button":
				print(element)
				element.mouse_entered.connect(mouse_focus.bind(element))
	# Level info set:
	$PlayingInterface/LevelInfo/Info.text = "Mundo "+str(int(GameMaster.world))+" - Nivel "+str(int(GameMaster.level));
	if GameMaster.hero_mode:
		$PlayingInterface/LevelInfo.size = Vector2(230.0,30.0);
		$PlayingInterface/LevelInfo.position = Vector2(29,132.0);
		$PlayingInterface/LevelInfo/Info.text += " (Héroe)"
		$PauseMenu/Panel.size.y = 130;
		$PauseMenu/Panel.position.y = 16;
		$WinMenu/Panel.size.y = 120;
		$WinMenu/Panel.position.y = 21;
	else:
		$PauseMenu/Panel.position.y = 2.375;
		$LooseMenu/Panel/VBoxContainer.size = Vector2(250,119);
		$LooseMenu/Panel/VBoxContainer.position = Vector2(10,11.5);
		$LooseMenu/Panel.size.y = 130;
		$LooseMenu/Panel.position.y = 16;
	# getting and setting the coins number for the actual level
	if GameMaster.coins[GameMaster.world-1][GameMaster.level-1] < 10: #9 or less coins
			target_coins.text = "0" + str(GameMaster.coins[GameMaster.world-1][GameMaster.level-1]);
	else: #10 or more coins
			target_coins.text = str(GameMaster.coins[GameMaster.world-1][GameMaster.level-1]);
	# displaying the UI whether the hero mode is active or not
	if GameMaster.hero_mode: #displaying or not the lifes panel
		$PlayingInterface/Lifes.visible = true;
	else: #in case or not hero mode
		$PlayingInterface/Lifes.visible = false;# don't display the lifes panel
		$PlayingInterface/Score.position.x = 0; #sets the coin counter left of the screen
	if GameMaster.hero_mode:
		$LevelMusicHero.play();
		if GameMaster.world == 6 and GameMaster.level < 6:
			$LevelMusicHero.volume_db = 10;
	else:
		$LevelMusic.play();
	$MenuMovement.volume_db = 20;
	$MenuSelect.volume_db = 20;
	###################################
	# Web version display
	###################################
	if OS.get_name() == "Windows":
		menu_options = [
					[$PauseMenu/Panel/VBoxContainer/Continue],
					[$PauseMenu/Panel/VBoxContainer/MainMenu],
					[$PauseMenu/Panel/VBoxContainer/ResetLevel],
					[$PauseMenu/Panel/VBoxContainer/Exit]
				];
	else:
		#disables every exit button
		$PauseMenu/Panel/VBoxContainer/Exit.visible = false;
		$WinMenu/Panel/VBoxContainer/Exit.visible = false;
		$LooseMenu/Panel/VBoxContainer/Exit.visible = false;
		#change of sizes and positions:
		$PauseMenu/Panel.size.y = 130;
		$PauseMenu/Panel.position.y = 16;
		$WinMenu/Panel.size.y = 110;
		$WinMenu/Panel.position.y = 26;
		$LooseMenu/Panel.size.y = 100;
		$LooseMenu/Panel.position.y = 31;
		menu_options = [
			[$PauseMenu/Panel/VBoxContainer/Continue],
			[$PauseMenu/Panel/VBoxContainer/MainMenu],
			[$PauseMenu/Panel/VBoxContainer/ResetLevel]
		];
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	###################################
	# displaying the score in screen:
	###################################
	var total_coins = ""; #variable that contains the number of coins, type string
	if GameMaster.coinsCount < 10: #9 or less coins
		total_coins = "0"+str(GameMaster.coinsCount);
	else: #10 or more coins
		total_coins = str(GameMaster.coinsCount);
	coins_number.text = total_coins; #printing the total of coins in screen
	####################################
	# displaying lifes in case of hero mode:
	####################################
	if GameMaster.hero_mode:
		lifes_number.text = str(GameMaster.lifes);
	####################################
	# Updating the number of hits
	####################################
	updating_hearts(GameMaster.hits);
	# Pausing and displaying the pause menu:
	####################################
	if Input.is_action_just_pressed("start") and pause: #if start is pressed
		get_tree().paused = not get_tree().paused; #change paused state
		pause_menu.visible = get_tree().paused; #set the value to visible property of the menu
		playing_interface.visible = not get_tree().paused; #toogles score visibility
		#toogles music:
		if get_tree().paused: #when changes to stopped
			button_enabled = true;
			if GameMaster.hero_mode:
				resume_time = $LevelMusicHero.get_playback_position();
				$LevelMusicHero.stop();
			else:
				resume_time = $LevelMusic.get_playback_position();
				$LevelMusic.stop();
			$MenuMusic.play();
			menu_cursor = Vector2(0,0);
			if GameMaster.hero_mode:
				if OS.get_name() == "Windows":
					menu_options = [
						[$PauseMenu/Panel/VBoxContainer/Continue],
						[$PauseMenu/Panel/VBoxContainer/MainMenu],
						[$PauseMenu/Panel/VBoxContainer/Exit]
					];
					$PauseMenu/Panel.size.y = 130;
					$PauseMenu/Panel.position.y = 16;
				else:
					menu_options = [
						[$PauseMenu/Panel/VBoxContainer/Continue],
						[$PauseMenu/Panel/VBoxContainer/MainMenu]
					];
					$PauseMenu/Panel.size.y = 100;
					$PauseMenu/Panel.position.y = 31;
					$PauseMenu/Panel/VBoxContainer/Exit.visible = false;
				$PauseMenu/Panel/VBoxContainer/ResetLevel.visible = false;
			else:
				if OS.get_name() == "Windows":
					menu_options = [
						[$PauseMenu/Panel/VBoxContainer/Continue],
						[$PauseMenu/Panel/VBoxContainer/MainMenu],
						[$PauseMenu/Panel/VBoxContainer/ResetLevel],
						[$PauseMenu/Panel/VBoxContainer/Exit]
					];
				else:
					menu_options = [
						[$PauseMenu/Panel/VBoxContainer/Continue],
						[$PauseMenu/Panel/VBoxContainer/MainMenu],
						[$PauseMenu/Panel/VBoxContainer/ResetLevel]
					];
					$PauseMenu/Panel/VBoxContainer/Exit.visible = false;
			menu_options[0][0].grab_focus();
		else: #when returns to game
			button_enabled = false;
			if GameMaster.hero_mode:
				$LevelMusicHero.play(resume_time);
			else:
				$LevelMusic.play(resume_time);
			$MenuMusic.stop();
	if not get_tree().paused:
		pause = true;
	####################################
	# Displaying the win menu:
	####################################
	if GameMaster.success:
		pause = false;
		get_tree().paused = true;
		$PlayingInterface.visible = false; #stop showing the score panel
		GameMaster.success = false;
		if GameMaster.world == 6 and GameMaster.level == 6: #if its the last one
			menu_cursor = Vector2(0,0);
			menu_options = [
				[$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel]
			];
			$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel.text = "Ver créditos"
			$WinMenu/Panel/VBoxContainer/HBoxContainer/RepeatLevel.visible = false;
			$WinMenu/Panel/VBoxContainer/MainMenu.visible = false;
			$WinMenu/Panel/VBoxContainer/Exit.visible = false;
			$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel.grab_focus();
			if GameMaster.hero_mode: #if it hero mode
				$LevelMusicHero.stop();
				$LevelSuccessHero.play(0.0);
				SaveManager.completed_hero_mode_game(); #set this as true
				$WinMenu/Panel/VBoxContainer/Message.text = "Felicidades!!!\nEres un héroe!";
			else: #sets this as true
				$LevelMusic.stop();
				$LevelSuccess.play(0.0);
				SaveManager.complete_level(6,6);
				SaveManager.completed_normal_game();
				$WinMenu/Panel/VBoxContainer/Message.text = "Lo lograste!!!\nSiempre lo supe!";
			button_enabled = false;
			$Save.visible = true;
			$Save/AnimationPlayer.play("saving");
			await get_tree().create_timer(1.0).timeout;
			$Save.visible = false;
			$Save/AnimationPlayer.stop();
			$WinMenu.visible = true; 	
			button_enabled = true;
		else:
			if not GameMaster.hero_mode: #if its not hero mode
				SaveManager.complete_level(GameMaster.world,GameMaster.level); #saves the completed level
				$LevelMusic.stop();
				$LevelSuccess.play(0.0);
				$Save.visible = true;
				$WinMenu.visible = true;
				menu_cursor = Vector2(0,0);
				if OS.get_name() == "Windows":
					menu_options = [
						[$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel,$WinMenu/Panel/VBoxContainer/HBoxContainer/RepeatLevel],
						[$WinMenu/Panel/VBoxContainer/MainMenu],
						[$WinMenu/Panel/VBoxContainer/Exit]
					];
				else:
					menu_options = [
						[$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel,$WinMenu/Panel/VBoxContainer/HBoxContainer/RepeatLevel],
						[$WinMenu/Panel/VBoxContainer/MainMenu]
					];
					$WinMenu/Panel/VBoxContainer/Exit.visible = false;
				menu_options[0][0].grab_focus();
				$Save/AnimationPlayer.play("saving");
				await get_tree().create_timer(1.0).timeout;
				button_enabled = true;
				$Save.visible = false;
				$Save/AnimationPlayer.stop();
			else:
				$WinMenu.visible = true;
				$LevelMusicHero.stop();
				$LevelSuccessHero.play(0.0);
				button_enabled = true;
				if OS.get_name() == "Windows":
					menu_options = [
						[$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel],
						[$WinMenu/Panel/VBoxContainer/Exit]
					];
					$WinMenu/Panel.size.y = 120;
					$WinMenu/Panel.position.y = 21;
				else:
					menu_options = [
						[$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel]
					];
					$WinMenu/Panel.size.y = 90;
					$WinMenu/Panel.position.y = 36;
					$WinMenu/Panel/VBoxContainer/Exit.visible = false;
				$WinMenu/Panel/VBoxContainer/HBoxContainer/RepeatLevel.visible = false;
				$WinMenu/Panel/VBoxContainer/MainMenu.visible = false;
				menu_options[0][0].grab_focus();
		
	#####################################
	# Displaying the loose menu
	#####################################
	if GameMaster.loose:
		pause = false;
		get_tree().paused = true;
		playing_interface.visible = false;
		loose_menu.visible = true;
		if GameMaster.hero_mode:
			$LevelMusicHero.stop();
		else:
			$LevelMusic.stop();
		$LevelFailed.play();
		GameMaster.loose = false;
		menu_cursor = Vector2(0,0);
		if OS.get_name() == "Windows":
			menu_options = [
				[$LooseMenu/Panel/VBoxContainer/ResetRun],
				[$LooseMenu/Panel/VBoxContainer/MainMenu],
				[$LooseMenu/Panel/VBoxContainer/Exit]
			];
		else:
			menu_options = [
				[$LooseMenu/Panel/VBoxContainer/ResetRun],
				[$LooseMenu/Panel/VBoxContainer/MainMenu]
			];
			$LooseMenu/Panel/VBoxContainer/Exit.visible = false;
		menu_options[0][0].grab_focus();
		button_enabled = true;
	######################################
	# Navigation for the menus
	######################################
	if get_tree().paused:
		menu_focus = true;
		# When is paused checks what input is released and then acts depending on the input
		if menu_focus:
			menu_movement(menu_options);
##########################################
# updating hearts function
##########################################
func updating_hearts(number: int):
	if number == 3:
		first_heart.frame = 1;
		second_heart.frame = 1;
		third_heart.frame = 1;
	elif number == 2:
		first_heart.frame = 1;
		second_heart.frame = 1;
		third_heart.frame = 3;
	elif number == 1:
		first_heart.frame = 1;
		second_heart.frame = 3;
		third_heart.frame = 3;
###########################################
# Menu movement:
func menu_movement(options):
	#gets dimension of the options
	var height = len(options);
	var width = len(options[menu_cursor.y]);
	##### cursor's changes
	if Input.is_action_just_released("Up"): #up movement
		#decreses y valor and remains 0 if it's smaller than 0
		$MenuMovement.play();
		menu_cursor.y = menu_cursor.y-1 if menu_cursor.y-1>0 else 0;
		if len(options) > 1:
			if len(options[int(menu_cursor.y)]) <= len(options[int(menu_cursor.y+1)]):#if the next state has less width resets
				#sets the x in the range except when is bigger than the width
				previous_cursor_x = menu_cursor.x; #updates previous 
				menu_cursor.x = len(options[menu_cursor.y])-1 if menu_cursor.x >= len(options[menu_cursor.y]) else menu_cursor.x;
			else: #in other case, resets
				menu_cursor.x = previous_cursor_x;
		else:
			menu_cursor.y = 0;
	elif Input.is_action_just_released("Down"): #down movement
		# increases y valor and remains height - 1 if it's greather than height
		$MenuMovement.play();
		menu_cursor.y = menu_cursor.y+1 if menu_cursor.y+1 < height else height-1;
		if len(options) > 1:
			if len(options[menu_cursor.y]) <= len(options[menu_cursor.y-1]):#if the next state has less width resets
				#sets the x in the range except when is bigger than the width
				previous_cursor_x = menu_cursor.x;
				menu_cursor.x = len(options[menu_cursor.y])-1 if menu_cursor.x >= len(options[menu_cursor.y]) else menu_cursor.x;
			else:
				menu_cursor.x = previous_cursor_x;
		else:
			menu_cursor.y = 0;
	elif Input.is_action_just_released("right"): #right movement
		# increases x valor and remains width - 1 if it's greather than width
		$MenuMovement.play();
		menu_cursor.x = menu_cursor.x+1 if menu_cursor.x+1 < width else width-1;
	elif Input.is_action_just_released("left"):
		#decreses x valor and remains 0 if it's smaller than 0
		$MenuMovement.play();
		menu_cursor.x = menu_cursor.x-1 if menu_cursor.x-1>0 else 0;
	######## focus the new element
	options[int(menu_cursor.y)][int(menu_cursor.x)].grab_focus();
	if Input.is_action_just_pressed("jump") and not Input.is_key_label_pressed(KEY_SPACE) and not Input.is_key_label_pressed(KEY_KP_ENTER) and not Input.is_key_label_pressed(KEY_ENTER):
		options[menu_cursor.y][menu_cursor.x].emit_signal("button_up");
	if Input.is_action_just_pressed("start"):
		pass
###########################################
# Menu buttons events:


###########################################
# Pause menu:
###########################################

# continue:
func _on_continue_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		get_tree().paused = false; #set pause as false
		pause_menu.visible = false; #hide the menu
		playing_interface.visible = true; #shows the score panel
		$MenuMusic.stop();
		if GameMaster.hero_mode:
			$LevelMusicHero.play(resume_time);
		else:
			$LevelMusic.play(resume_time);

#main menu
func _on_main_menu_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		GameMaster.coinsCount = 0; # resets coins counter
		get_tree().paused = false;
		GameMaster.start_menu("main"); #starts the main menu

#reset level
func _on_reset_level_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		GameMaster.lifes = GameMaster.reload_lifes; #resets lifes quantities
		get_tree().paused = false;
		menu_cursor = Vector2(0,0);
		GameMaster.reload_level();

# exit
func _on_exit_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		GameMaster.exit(); #exits the game
	
############################################
# Win menu:
############################################

# next level
func _on_next_level_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		get_tree().paused = false;
		GameMaster.start_next_level(); #starts the next level

# repeat level
func _on_repeat_level_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		get_tree().paused = false;
		GameMaster.reload_level(); #reloads the level
		$MenuMusic.stop();
		$LevelMusic.play();

# Reset run in case of hero_mode
func _on_reset_run_button_up() -> void:
	if button_enabled and not Input.is_action_just_pressed("start"):
		get_tree().paused = false;
		GameMaster.start_hero_mode();



# mouse behavior function
func mouse_focus(object):
	for i in range(len(menu_options)):
		var index = menu_options[i].find(object);
		if index != -1:
			menu_options[i][index].grab_focus()
			if menu_cursor != Vector2(index,i):
				$MenuMovement.play();
			menu_cursor = Vector2(index,i);
			break;
