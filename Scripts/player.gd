extends CharacterBody2D

# Physics parameters
const SPEED = 100.0
const JUMP_VELOCITY = -280.0
var respawn_position = Vector2(0,0);

# animation parameters
@onready var sprite = $Sprite2D;
@onready var animationPlayer = $AnimationPlayer;
func _ready() -> void:
	respawn_position = position; #sets the original position as respawn position by default
	GameMaster.reload_lifes = GameMaster.lifes; #sets the reload lifes quantity

# normal operation:

func _physics_process(delta: float) -> void:
	check_hits_and_lifes(GameMaster.lifes,GameMaster.hits); #checking and updating the statistic of lifes and hits
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animationPlayer.play("jump");
		$JumpingSound.play();

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if Input.is_action_just_pressed("left") or Input.is_action_pressed("left"):
		$Sprite2D.flip_h = false;
	if Input.is_action_just_pressed("right") or Input.is_action_pressed("right"):
		$Sprite2D.flip_h = true;
	if direction:
		velocity.x = direction * SPEED;
		animationPlayer.play("walk");
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
		animationPlayer.play("idle");
	move_and_slide()

# cheking lifes and hits:
func check_hits_and_lifes(lifes:int,hits:int):
	if (lifes != 0 or not GameMaster.hero_mode) and hits == 0: #if there's no more hits, but there are lifes or it's not hero mode
		GameMaster.hits = 3; #resets number of hits
		GameMaster.lifes -= 1; #reduces by one the number of lifes
		GameMaster.reload = true; #sets reload sound
		respawn();
	if lifes == 0 and GameMaster.hero_mode: # if there are no lifes and its hero mode
		GameMaster.loose = true;

# recoil function
func recoil_from(position_of_impact:float):
	velocity.x = -400 if position.x < position_of_impact else 400; # moves right or left whether the position of impact is left or right from the player
	velocity.y = -200;
	$HitSound.play();
	move_and_slide(); #aplies the movement
func recoil_little_from(position_of_impact:float):
	velocity.x = -200 if position.x < position_of_impact else 200; # moves right or left whether the position of impact is left or right from the player
	velocity.y = -200;
	$HitSound.play();
	move_and_slide(); #aplies the movement
# launching function
func launching(velocity_of_launching:Vector2):
	velocity.x += velocity_of_launching.x;
	velocity.y += velocity_of_launching.y;
	$HitSound.play();
	move_and_slide();

# respawn function
func respawn():
	position = respawn_position;
	if GameMaster.reload: #if reload its true
		$DeathSound.volume_db = 20;
		$DeathSound.play(); #sounds death
		GameMaster.reload = false;
	else: #else
		$RespawnSound.play(); #sounds respawn
func respawn_at(pos:Vector2):
	position = pos;
	respawn_position = pos;
func flip():
	$Sprite2D.flip_h = not $Sprite2D.flip_h;
