extends Control
var time = 0; #counts time
var skip = false; #allows skip this scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Sun/AnimationPlayer.play("shine");
	$InitialMusic.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta; #acumulative time
	if time < 15: # 10 seconds of first screen
		pass
	elif time <=30: #then until 30 seconds
		transition($Screen,$Screen2,time-15); #makes transition between screen 1 and 2
	elif time <=45: #then until 45 seconds
		transition($Screen2,$Screen3,time-30); #makes transition between screen 2 and 3
	elif time <=60: #then until 60 seconds
		transition($Screen3,$Screen4,time-45); #makes transition between screen 3 and 4
	elif time <=75: #then until 75 seconds
		transition($Screen4,$Screen5,time-60); #makes transition between screen 4 and 5
	elif time <=90: #then until 90 seconds
		transition($Screen5,$Screen6,time-75); #makes transition between screen 5 and 6
	else:
		$Begin.visible = true;
		animate_text(time);
		skip = true;
		SaveManager.completed_initial_scene();
	if skip:
		if Input.is_action_just_pressed("start"):
			GameMaster.start_menu("main");

######################
# functions:
######################
#text animation:
func animate_text(t):
	var formated_time = int(t)%2; #time formated
	var dt = t-int(t); #only decimal part
	var actual_color;
	if formated_time == 0: #first cycle
		actual_color = Color(1,dt,dt,1); #changes from red to white
	else: #second cycle
		actual_color = Color(1,1-dt,1-dt,1); #changes from white to red
	$Begin.add_theme_color_override("font_color",actual_color);
# transition:
func transition(screen_1,screen_2,time_lapse):
	screen_2.visible = true; #starts making visible the second screen
	if time_lapse <=5: #transition to left
		screen_1.position.x = -1252*(time_lapse/5);
		screen_2.position.x = 1152 - 1252*(time_lapse/5);
		$Bg.position.x = 2304 - 1252*(time_lapse/5);
	elif time_lapse <=6: #transition to right
		screen_1.position.x = -1252 + 200*(time_lapse-5);
		screen_2.position.x = -100 + 200*(time_lapse-5);
		$Bg.position.x = 1052 + 200*(time_lapse-5);
	elif time_lapse <= 7: #final transition to right
		screen_1.position.x = -1052 - 100*(time_lapse-6);
		screen_2.position.x = 100 - 100*(time_lapse-6);
		$Bg.position.x = 1252 - 100*(time_lapse-6);
	else:
		screen_1.visible = false;#makes the second screen invisible
