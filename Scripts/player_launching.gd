extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_name()=="Player":
		GameMaster.hits -= 1;
		var player_position = body.get_position(); #getting player position
		var launching_velocity = Vector2(0,0); #setting launching velocity for the player
		if player_position.x < position.x: #setting x component camparing player and area position
			launching_velocity.x = -800;
		else:
			launching_velocity.x = 800;
		if player_position.y < position.y: #setting y component comparing player and area position
			launching_velocity.y = -400;
		else:
			launching_velocity.y = 400;
		body.launching(launching_velocity); #launching the player
		
