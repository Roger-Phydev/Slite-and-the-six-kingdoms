extends Area2D

var respawn_position = Vector2(0,0);
var respawn_y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.get_name().contains("(") and self.get_name().contains(")"): #if contains coordinates
		var position_in_name = self.get_name().split("(")[1].replace(")","").split(","); #gets the number of every axis
		respawn_position = Vector2(float(position_in_name[0]),float(position_in_name[1])); #updates the respawn position
	elif self.get_name().contains("Y="): #if contains this string and format like Y=230
		respawn_y = float(self.get_name().split("Y=")[1]);
	else:
		respawn_position = false; #in other case just sets false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.get_name(): #if an enemy enters respawns it
		if respawn_position: #if there's a respawn position extracted form name
			body.respawn_at(respawn_position); #respawns the enemy at that position
		elif respawn_y:
			body.init_y = respawn_y;
		else: #in  other caso
			body.respawn(); #just respawns
		if "Flip" in self.get_name(): # if contains the flip word in the area, then flips the enemy
			body.flip();
