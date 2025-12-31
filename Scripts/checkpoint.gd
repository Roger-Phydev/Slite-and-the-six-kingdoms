extends Node2D
var activated = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player" and not activated: #when the player enters
		$AnimationPlayer.play("active"); #activates the animation
		body.respawn_position = Vector2(position.x-6,position.y+9); #sets the new respawn position of the player
		$Checkpoint.play();
		activated = true; #and sets the activated variable as true, so it can't enter here twice
