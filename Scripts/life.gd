extends Node2D

var taken = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("expand");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player" and not taken: #if the player takes but it hasn't been taken
		GameMaster.lifes += 1;#increases the lifes
		$Life.play(); #plays this sound
		$Sprite2D.visible = false; #disapears images
		taken = true; #changes the taken variable
		await get_tree().create_timer(3.02).timeout; #awaits for the sound
		queue_free(); #and dissapears
