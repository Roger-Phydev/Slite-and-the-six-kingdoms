extends CharacterBody2D

# physics variables
const SPEED = 120.0;
var going_left = true;
var movement = true;
var timeout = 0;
var init_x = 0; #initial position
var init_y = 0;

# set animation at beggining
func _ready() -> void:
	$AnimationPlayer.play("run");
	init_x = position.x; #saves the initial position
	init_y = position.y;
	if not "Right" in self.name:
		going_left = false;
		scale.x = -scale.x;

#checks this every time
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if movement:	
		# movement of the enemy
		$AnimationPlayer.play("run");
		move_character();
		turn();
	else:
		velocity.x = 0; #no movement
		$AnimationPlayer.play("iddle"); #plays iddle animation
		timeout += 1; #increments the timeout
		if timeout == 30: #when has passed 30 frames
			scale.x = -scale.x; #flips the direction of the movement
			movement = true; #allows movement
			timeout = 0; #and resets the timeout

# move function
func move_character():
	velocity.x = -SPEED if going_left else SPEED; # moves left or right whether going_left its true or not
	move_and_slide(); #starts movement
	
# turn function
func turn():
	if (not $FloorDetection.is_colliding()) or $WallDetection.is_colliding(): #if there's no floor or there´s an obstacule, turns
		flip();
func flip():
	going_left = not going_left;
	scale.x = -scale.x; #flips the direction of the movement
# when collides with the player:
func _on_area_2d_body_entered(body: Node2D) -> void:
	if ("Enemy" in body.get_name() or "Bounce" in body.get_name()) and self.name != body.get_name():
		going_left = not going_left;
		scale.x = -scale.x; #flips the direction of the movement
	if body.get_name() == "Player": #if player enters
		GameMaster.hits -= 1; # reduces the number of hits from 1
		body.recoil_from(position.x); #aplies recoil to the player
func respawn(): #sets the position to the initial again
	position.x = init_x;
	position.y = init_y;
	scale.x = -scale.x;
	movement = false;
func respawn_at(pos:Vector2): #sets the position to the parameter
	position = pos;
func respawn_y_axis(y_value:float): #sets the position to the parameter
	position.y = y_value;
	position.x = init_x;
func die(): #when dies, desappears
	queue_free();
#volume control:
#when player enters the low volume area
func _on_low_volume_sound_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = -6; #sets low volume
		$Moving.play(); #and plays the sound
#when player enters the medium volume area
func _on_medium_volume_sound_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = 0; #sets medium volume
#when player enters the full volume area
func _on_full_volume_sound_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = 1; #sets full volume
#when player exits the full volume area
func _on_full_volume_sound_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = 0; #sets medium volume
#when player exits the medium volume area
func _on_medium_volume_sound_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = -6; #sets low volume
#and finally when player exits the low volume area
func _on_low_volume_sound_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.stop(); #stops the sound
