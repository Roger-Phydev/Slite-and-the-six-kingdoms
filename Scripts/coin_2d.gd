extends Node2D

#animation variables
@onready var animationPlayer = $AnimationPlayer
var taken = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer.play("spin");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_coin_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player" and not taken: #if player touchs it and it hasn't been taken
		$coin.play();#reproduces the sound
		GameMaster.coins_increment(); #and increments the coin counter
		$CoinGold.visible = false; #disapears sprite
		taken = true;
		await get_tree().create_timer(0.1).timeout; #awaits 0.3s 
		queue_free(); #desapears
