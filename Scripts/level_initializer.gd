extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var name_of_scene = get_tree().get_current_scene().name;
	#var world = int(name_of_scene.split("_")[1]); #gets the world from the name
	#var level = int(name_of_scene.split("_")[3]); #gets the level from the name
	#GameMaster.world = world; #sets the world in the gamemaster
	#GameMaster.level = level; #sets the level in the gamemaster
	GameMaster.world = 2;
	GameMaster.level = 1;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
