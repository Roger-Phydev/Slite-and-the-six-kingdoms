extends CharacterBody2D

# physics variables
const SPEED = 120.0;
var positive_direction = true; 
var init_x = 0; #initial positions
var init_y = 0;
var vertical = false;
#note in this case because always starts a change of direction, logic of going_left has been switched

# set animation at beggining
func _ready() -> void:
	$AnimationPlayer.play("move");
	init_x = position.x;
	init_y = position.y;
	if "Right" in self.name: #uses the word "Right" in the enemy to know the direction is going to
		positive_direction = false;
		scale.x = -scale.x;
	#the next two cases performs the necesary transformations to the sprite
	elif "Up" in self.name: #sets the vertical property true and rotates
		vertical = true;
		rotation_degrees = 90;
	elif "Down" in self.name: #sets vertical property true and rotates and scale
		vertical = true;		
		positive_direction = false;
		scale.x = -scale.x;
		rotation_degrees = 90;
#checks this every time
func _physics_process(delta: float) -> void:		
	# movement of the enemy
	move_character();
	if vertical:
		position.x = init_x;
	else:
		position.y = init_y;
	if $WallDetection.is_colliding():
		respawn();

# move function
func move_character():
	if vertical:
		velocity.y = -SPEED if positive_direction else SPEED;
	else:
		velocity.x = -SPEED if positive_direction else SPEED; # moves left or right whether going_left its true or not
	move_and_slide(); #starts movement
	
# when collides with the player:
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": #if player enters
		GameMaster.hits -= 1; # reduces the number of hits from 1
		body.recoil_from(position.x); #aplies recoil to the player

func respawn():
	position = Vector2(init_x,init_y);
func respawn_at(pos:Vector2): #sets the position to the parameter
	position = pos;
func respawn_y_axis(y_value:float): #sets the position to the parameter
	position.y = y_value;
	position.x = init_x;
#volume control:
#when player enters the low volume area
func _on_low_volume_sound_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = -6; #sets low volume
		$Moving.play(); #and plays the of fire
#when player enters the medium volume area
func _on_medium_volume_sound_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = 0; #sets medium volume
#when player enters the full volume area
func _on_full_volume_sound_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Moving.volume_db = 1; #sets full volume on moving
		$Flush.play(); #and plays the flush once
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
