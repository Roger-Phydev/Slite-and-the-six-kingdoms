extends Node

#############################################
# Propierties:
#############################################

#scalars propierties:
var coinsCount = 0; #coins counter
var world = 1; #world number
var level = 1; #level number
var success = false; #win variable
var loose = false; #loose variable
var hero_mode = false; #a variable that sets when its playing with finite lifes
var lifes = 5; # lives in case of hero mode
var hits = 3; # number of hits that remains to loose a life
var reload = false;
var reload_lifes = 0;
var credits_from_menu = false;

var respawn_position = Vector2(0,0);
#array propierties
var coins = [ #coin for every world and course
[12,20,12,25,20,28], #world1
[10,15,20,12,12,18], #world2
[8,10,12,8,15,5], #world3
[10,14,20,20,28,12], #world4
[4,6,7,7,5,5], #world5
[20,20,20,20,20,30], #world 6
]

##################################################
# Basic operation
##################################################
func _ready() -> void:
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if coins[world-1][level-1] and coinsCount == coins[world-1][level-1]: #if we reach the max count of coin for the level
		success = true; #it indicates that the level is complete

######################################################################
# methods:
######################################################################

func start_world_level_scene(w:int,l:int):
	var next_scene = "res://Scenes/levels/world_"+str(w)+"/world_"+str(w)+"_level_"+str(l)+".tscn"; #building the string of the next scene
	get_tree().change_scene_to_file(next_scene); 

func start_menu(name_of_menu:String):
	var next_scene = "res://Scenes/"+name_of_menu+"_menu.tscn"; #building the route
	get_tree().change_scene_to_file(next_scene);

func coins_increment(): #increment the coincount in one
	coinsCount += 1;
	
func set_next_world_and_level(): # this function calculates next level and world given the actual world and level
	if level == 6: #if it's the last level of the world
		world += 1; #increments the world
		level = 1; #and set the level in 1
	else: #otherwise
		level += 1; #increments the level
func start_next_level():
	set_next_world_and_level();
	coinsCount = 0; #resets coins number
	success = false;
	loose = false;
	if world < 7: #if it's a valid world
		start_world_level_scene(world,level); #starts the level
	else:
		world = 1;
		level = 1; #sets the initial values of the world and level
		credits_from_menu = false;
		get_tree().change_scene_to_file("res://Scenes/credits.tscn"); #go to credits

func reload_level():
	coinsCount = 0; #resets couins count
	success = false;
	get_tree().reload_current_scene(); #reload actual scene

func exit():
	get_tree().quit(); #exits the game
