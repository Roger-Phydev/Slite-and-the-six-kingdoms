extends CharacterBody2D

# physics variables
const SPEED = 80.0;
var going_left = true; 
var init_x = 0; #initial position
var init_y = 0;
#note in this case because always starts a change of direction, logic of going_left has been switched

# set animation at beggining
func _ready() -> void:
	$AnimationPlayer.play("run");
	init_x = position.x; #saves the initial position
	init_y = position.y;
	if "Right" in self.name: #uses the word "Right" in the enemy to know the direction is going to
		going_left = false;
		scale.x = -scale.x;

#checks this every time
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# movement of the enemy
	move_character();
	turn();

# move function
func move_character():
	velocity.x = -SPEED if going_left else SPEED; # moves left or right whether going_left its true or not
	move_and_slide(); #starts movement
	
# turn function
func turn():
	if $WallDetection.is_colliding(): #if there´s an obstacule, turns
		flip()
func flip():
	going_left = not going_left;
	scale.x = -scale.x; #flips the direction of the movement
# when collides with the player:
func _on_area_2d_body_entered(body: Node2D) -> void:
	if ("Enemy" in body.get_name() or "Bounce" in body.get_name()) and self.name != body.get_name(): #only considers enemies different to itself
		going_left = not going_left;
		scale.x = -scale.x; #flips the direction of the movement
	if body.get_name() == "Player": #if player enters
		GameMaster.hits -= 1; # reduces the number of hits from 1
		body.recoil_from(position.x); #aplies recoil to the player

func respawn(): #sets the position to the initial again
	position.x = init_x;
	position.y = init_y;
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
		$Moving.volume_db = 2; #sets full volume
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
