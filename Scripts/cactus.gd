extends CharacterBody2D


func _ready() -> void:
	$AnimationPlayer.play("idle");#starts iddle animation

func _physics_process(delta: float) -> void:
	pass

func die():
	queue_free();


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": #if player enters
		GameMaster.hits -= 1; # reduces the number of hits from 1
		$AnimationPlayer.play("touch"); #reproduces the animation of touching
		body.recoil_from(position.x); #aplies recoil to the player
		await get_tree().create_timer(0.25).timeout;#and waits for the animation
		$AnimationPlayer.play("idle");
