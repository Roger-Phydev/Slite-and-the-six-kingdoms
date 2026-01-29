extends Control

@onready var seconds = 0;
@onready var velocity = 200;
@onready var initial_timer = 0;
@onready var skip = false;
@onready var bat_speed = 200;
@onready var birds_speed = 100;
@onready var clouds_speed = 150;
@onready var sun_speed = 15;
@onready var sun_animation = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CreditsMusic.play();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("start") and GameMaster.credits_from_menu:
		GameMaster.start_menu("main");
	if $elements/Clouds1.position.x > -2304:
		$elements/Clouds1.position.x -= delta*clouds_speed;
	else:
		$elements/Clouds1.position.x = 1152;
	if $elements/Clouds2.position.x > -2304:
		$elements/Clouds2.position.x -= delta*clouds_speed;
	else:
		$elements/Clouds2.position.x = 1152;
	seconds += delta;
	#time activation of shines:
	if seconds > 0.1 and seconds < 0.15:
		activate_shine(0);
		activate_shine(4);
		activate_shine(8);
		activate_shine(12);
	elif seconds > 0.4 and seconds < 0.5:
		activate_shine(2);
		activate_shine(6);
		activate_shine(10);
		activate_shine(14);
	elif seconds > 0.55 and seconds < 0.65:
		activate_shine(1);
		activate_shine(5);
		activate_shine(9);
		activate_shine(13);
	elif seconds>0.85 and seconds < 0.95:
		activate_shine(3);
		activate_shine(7);
		activate_shine(11);
		activate_shine(15);
	elif seconds > 5: #after a second
		$Content.position.y -= delta*velocity; #moves the credits
	#changes the velocity in function of position
	if $Content.position.y < -6912: #the final section
		velocity = 0;
		skip = true;
	elif $Content.position.y < -5120: #most important part
		velocity = 0;
		#activation of birds
		activate_birds();
		$elements/Birds.position.x -= delta*birds_speed;
		initial_timer = seconds if initial_timer==0 else initial_timer; #sets the timer only it wasn't initiated
		if seconds-initial_timer>10: #waits for aprox 10 s
			velocity = 100; #changes then the velocity
			$Background/Sun/AnimationPlayer.play("shine");
			sun_animation = true;
		gradient_on_sky_color(-5120,-6912,[0.5201, 0.4712, 0.4437, 1.0],[0.2157, 0.502, 0.7373, 1.0]);
		
		# (0.2157, 0.502, 0.7373, 1.0)
	elif $Content.position.y < -3300: #When reaches people, then slow down scrolling
		velocity = 100;
		#bats animation
		activate_bats();
		$elements/Bats.position.x += delta*bat_speed; 
		#deactivating shines
		if $Content.position.y > -4719 and $Content.position.y < -4600:
			deactivate_shine(0);
			deactivate_shine(4);
			deactivate_shine(8);
			deactivate_shine(12);
		elif $Content.position.y > -4879 and $Content.position.y < -4720:
			deactivate_shine(2);
			deactivate_shine(6);
			deactivate_shine(10);
			deactivate_shine(14);
		elif $Content.position.y > -4999 and $Content.position.y < -4880:
			deactivate_shine(1);
			deactivate_shine(5);
			deactivate_shine(9);
			deactivate_shine(13);
		elif $Content.position.y > -5120 and $Content.position.y < -5000:
			deactivate_shine(3);
			deactivate_shine(7);
			deactivate_shine(11);
			deactivate_shine(15);
		gradient_on_sky_color(-3300,-5120,[0.5216, 0.4824, 0.8235, 1.0],[0.5201, 0.4712, 0.4437, 1.0]);
	else:
		gradient_on_sky_color(0,-3300,[0.0,0.0,0.0,1.0],[0.5216, 0.4824, 0.8235, 1.0])
	if skip: #when skip is allowed
		if Input.is_action_just_released("jump"): #and jump actions is realesed
			GameMaster.credits_from_menu = false;
			GameMaster.start_menu("main"); #changes to main menu
	if $elements/Bats.position.x > 1600: #deactivation of bats
		deactivate_bats();
	if $elements/Birds.position.x < -1600:
		deactivate_birds();
	if sun_animation:
		if $Background/Sun.position.y > 75:
			$Background/Sun.position.y -= delta*sun_speed;
		else:
			$Background/Sun.position.y = 75;
func activate_shine(n):
	$Background/Shines.get_children()[n].visible = true; #makes it visible
	$Background/Shines.get_children()[n].get_children()[0].play("shine"); #starts animation
func deactivate_shine(n):
	$Background/Shines.get_children()[n].visible = false; #makes it visible
	$Background/Shines.get_children()[n].get_children()[0].pause(); #starts animation
func gradient_on_sky_color(initial_value,final_value,initial_color,final_color): #a function that changes the sky color
	var scale_factor = 0;
	if $Content.position.y > initial_value: #if it's less than the initial value
		$Background/Sky/Sky.color[0] = initial_color[0];
		$Background/Sky/Sky.color[0] = initial_color[1];
		$Background/Sky/Sky.color[0] = initial_color[2];
		$Background/Sky/Sky.color[0] = initial_color[3];
	elif $Content.position.y <= initial_value and $Content.position.y >= final_value: #between the transition range
		scale_factor = ($Content.position.y-initial_value)/(final_value - initial_value); #sets the scale factor
		$Background/Sky/Sky.color[0] = initial_color[0] + (final_color[0]-initial_color[0])*scale_factor;
		$Background/Sky/Sky.color[1] = initial_color[1] + (final_color[1]-initial_color[1])*scale_factor;
		$Background/Sky/Sky.color[2] = initial_color[2] + (final_color[2]-initial_color[2])*scale_factor;
		$Background/Sky/Sky.color[3] = initial_color[3] + (final_color[3]-initial_color[3])*scale_factor;
	else:#in other case
		for i in range(4):#sets the final color
			$Background/Sky/Sky.color[0] = final_color[0]; 
			$Background/Sky/Sky.color[1] = final_color[1]; 
			$Background/Sky/Sky.color[2] = final_color[2]; 
			$Background/Sky/Sky.color[3] = final_color[3]; 
func activate_bats():
	$elements/Bats.visible = true;
	for bat in $elements/Bats.get_children():
		bat.get_children()[0].play("fly");
func deactivate_bats():
	$elements/Bats.visible = false;
	for bat in $elements/Bats.get_children():
		bat.get_children()[0].pause();
func activate_birds():
	$elements/Birds.visible = true;
	for bird in $elements/Birds.get_children():
		bird.get_children()[0].play("fly");
func deactivate_birds():
	$elements/Birds.visible = false;
	for bird in $elements/Birds.get_children():
		bird.get_children()[0].pause();
