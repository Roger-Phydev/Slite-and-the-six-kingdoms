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
@onready var buttons_list = [""]; #list of buttons
@onready var buttons_cursor = -1; #the buttons cursor



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	$LevelMusic.play();
	$MenuMovement.volume_db = 20;
	$MenuSelect.volume_db = 20;

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
	if Input.is_action_just_pressed("start"): #if start is pressed
		get_tree().paused = not get_tree().paused; #change paused state
		pause_menu.visible = get_tree().paused; #set the value to visible property of the menu
		playing_interface.visible = not get_tree().paused; #toogles score visibility
		#toogles music:
		if get_tree().paused: #when changes to stopped
			resume_time = $LevelMusic.get_playback_position();
			$LevelMusic.stop();
			$MenuMusic.play();
		else: #when returns to game
			$LevelMusic.play(resume_time);
			$MenuMusic.stop();
			buttons_cursor = -1; #resets the cursor
		# buttons for controls:
		buttons_list = [$PauseMenu/Panel/VBoxContainer/Continue,$PauseMenu/Panel/VBoxContainer/MainMenu,$PauseMenu/Panel/VBoxContainer/ResetLevel,$PauseMenu/Panel/VBoxContainer/Exit];
	####################################
	# Displaying the win menu:
	####################################
	if GameMaster.success:
		get_tree().paused = true;
		win_menu.visible = true;
		playing_interface.visible = false; #stop showing the score panel
		$LevelMusic.stop();
		$LevelSuccess.play(0.0);
		GameMaster.success = false;
		buttons_cursor = -1;
		buttons_list = [$WinMenu/Panel/VBoxContainer/HBoxContainer/NextLevel,$WinMenu/Panel/VBoxContainer/HBoxContainer/RepeatLevel,$WinMenu/Panel/VBoxContainer/MainMenu,$WinMenu/Panel/VBoxContainer/Exit];
	#####################################
	# Displaying the loose menu
	#####################################
	if GameMaster.loose:
		get_tree().paused = true;
		playing_interface.visible = false;
		loose_menu.visible = true;
		$LevelMusic.stop();
		$LevelFailed.play();
		GameMaster.loose = false;
		buttons_cursor = -1;
		buttons_list = [$LooseMenu/Panel/VBoxContainer/ResetRun,$LooseMenu/Panel/VBoxContainer/MainMenu,$LooseMenu/Panel/VBoxContainer/Exit];
	######################################
	# Navigation for the menus
	######################################
	if get_tree().paused:
		# When is paused checks what input is released and then acts depending on the input
		if Input.is_action_just_released("Up"):
			if buttons_cursor == -1: #this action applies for all the first time
				buttons_cursor = 0; #sets the button_cursor on 0
			else: #in other case, this decrements the index inside the buttons arrays
				buttons_cursor = (buttons_cursor + len(buttons_list) - 1)%len(buttons_list)
			$MenuMovement.play(); #plays the movement music
			buttons_list[buttons_cursor].grab_focus(); #grabs the focus to the button
		elif Input.is_action_just_released("Down"):
			if buttons_cursor == -1:
				buttons_cursor = 0;
			else: #in this case, increments the index inside the buttons array
				buttons_cursor = (buttons_cursor + 1)%len(buttons_list)
			$MenuMovement.play(); #plays the movement music
			buttons_list[buttons_cursor].grab_focus(); #grabs the focus to the button
		elif Input.is_action_just_released("right"):
			if buttons_cursor == -1: # in this case just acts when begins the actions
				buttons_cursor = 0;#initializes the button
				$MenuMovement.play(); #plays the movement music
				buttons_list[buttons_cursor].grab_focus(); #grabs the focus to the button
			elif buttons_cursor == 0 and len(buttons_list) == 4:#this acts in the only case when we have 2 buttons one beside another
				buttons_cursor = 1;
				$MenuMovement.play();
				buttons_list[buttons_cursor].grab_focus();
		elif Input.is_action_just_released("left"):
			if buttons_cursor == -1: # in this case just acts when begins the actions
				$MenuMovement.play(); #plays the movement music
				buttons_cursor = 0;#initializes the button
				buttons_list[buttons_cursor].grab_focus(); #grabs the focus to the button
			elif buttons_cursor == 1 and len(buttons_list) == 4:#this acts in the only case when we have 2 buttons one beside another
				buttons_cursor = 0;
				$MenuMovement.play();
				buttons_list[buttons_cursor].grab_focus();
		elif Input.is_action_just_released("Select"):
			if buttons_cursor == -1: # when begins the actions
				buttons_cursor = 0;#initializes the button
				$MenuMovement.play(); #plays the movement music
				buttons_list[buttons_cursor].grab_focus(); #grabs the focus to the button
			else:
				buttons_list[buttons_cursor].emit_signal("button_up");#presses the actual button
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
# Menu buttons events:


###########################################
# Pause menu:
###########################################

# continue:
func _on_continue_button_up() -> void:
	get_tree().paused = false; #set pause as false
	pause_menu.visible = false; #hide the menu
	playing_interface.visible = true; #shows the score panel
	$MenuMusic.stop();
	$LevelMusic.play(resume_time);

#main menu
func _on_main_menu_button_up() -> void:
	GameMaster.coinsCount = 0; # resets coins counter
	get_tree().paused = false;
	GameMaster.start_menu("main"); #starts the main menu

#reset level
func _on_reset_level_button_up() -> void:
	GameMaster.lifes = GameMaster.reload_lifes; #resets lifes quantities
	get_tree().paused = false;
	buttons_cursor = -1;
	GameMaster.reload_level();

# exit
func _on_exit_button_up() -> void:
	GameMaster.exit(); #exits the game
	
############################################
# Win menu:
############################################

# next level
func _on_next_level_button_up() -> void:
	get_tree().paused = false;
	GameMaster.start_next_level(); #starts the next level

# repeat level
func _on_repeat_level_button_up() -> void:
	get_tree().paused = false;
	GameMaster.reload_level(); #reloads the level
	$MenuMusic.stop();
	$LevelMusic.play();

# Reset run in case of hero_mode
func _on_reset_run_button_up() -> void:
	#if wanted to try again, resets variables
	GameMaster.loose = false;
	GameMaster.lifes = 5;
	GameMaster.hits = 3;
	GameMaster.hero_mode = true;
	GameMaster.world = 1;
	GameMaster.level = 1;
	get_tree().paused = false;
	GameMaster.coinsCount = 0;
	GameMaster.start_world_level_scene(1,1); #and starts scene 1-1
