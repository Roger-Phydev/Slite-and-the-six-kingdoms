extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spin"); #starts the animation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": #if player enters
		GameMaster.hits -= 1; # reduces the number of hits from 1
		body.recoil_from(position.x); #aplies recoil to the player
	if "Enemy" in body.get_name(): #it kills enemies if they entered
		body.respawn();

#controls when the sound is played
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Saw.play();


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$Saw.stop();
