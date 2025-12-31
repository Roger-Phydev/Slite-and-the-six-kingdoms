extends Area2D

var respawn_position = Vector2(0,0);
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.get_name().contains("(") and self.get_name().contains(")"): #if contains coordinates
		var position_in_name = self.get_name().split("(")[1].replace(")","").split(","); #gets the number of every axis
		respawn_position = Vector2(float(position_in_name[0]),float(position_in_name[1])); #updates the respawn position
	else:
		respawn_position = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		if respawn_position:
			body.respawn_at(respawn_position);
		else:
			body.respawn();
		if "Flip" in self.get_name():
			body.flip();
