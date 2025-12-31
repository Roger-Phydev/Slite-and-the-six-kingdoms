extends CharacterBody2D
var launching = -400;
@onready var sound = $Jump;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "Low" in self.name:
		sound = $LowJump;
		launching = -350
	elif "High" in self.name:
		sound = $HighJump;
		launching = -500


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": # if the playere enters
		if "Left" in self.get_name():
			body.launching(Vector2(-3000,0));
		elif "Right" in self.get_name():
			body.launching(Vector2(3000,0));
		else:
			body.launching(Vector2(0,launching)); #launch it
		$AnimationPlayer.play("bounce"); # and play the animation
		sound.play();
