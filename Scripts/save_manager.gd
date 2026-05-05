extends Node

var save_path = "user://save.json"; #save file path

var initial_save_data = {#save data structure
	"initial_scene_watched":false,
	"tutorial_completed":false, 
	"level_completed":{
		"world1":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},#each world includes in an array the levels completed
		"world2":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world3":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world4":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world5":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world6":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
	},
	"continue_level":[0,0],
	"normal_mode_completed":false,
	"hero_mode_completed":false
};

var save_data = {#save data structure
	"initial_scene_watched":false,
	"tutorial_completed":false, 
	"level_completed":{
		"world1":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},#each world includes in an array the levels completed
		"world2":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world3":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world4":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world5":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
		"world6":{
			"level1":false,
			"level2":false,
			"level3":false,
			"level4":false,
			"level5":false,
			"level6":false
		},
	},
	"continue_level":[0,0],
	"normal_mode_completed":false,
	"hero_mode_completed":false
};

func save_game(): #save game method, updates the file
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))

func load_game(): #load method, charges or creates the save file
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var content = file.get_as_text()
		save_data = JSON.parse_string(content)
	else:
		save_game();
	return save_data;

func complete_level(world:int, level:int): #complete level method, sets true the level-world value of levels
	var w = "world"+str(world);
	var l = "level"+ str(int(level));
	save_data["level_completed"][w][l] = true;
	if world != 6 or level != 6:
		if level != 6:
			save_data["continue_level"] = [world,level+1];
		else:
			save_data["continue_level"] = [world+1,1];
	else:
		save_data["continue_level"] = [6,6];
	save_game() #and saves

func reset_save_data(): #resets the save_data to the initial value;
	save_data = initial_save_data;
	save_game();
func completed_tutorial(): #sets true the variable to tutorial_completed
	save_data["tutorial_completed"] = true;
	save_game();
func completed_initial_scene(): #sets true the variable to initial_scene
	save_data["initial_scene_watched"] = true;
	save_game();
func completed_normal_game(): #sets true the normal_mode_completed
	save_data["normal_mode_completed"] = true;
	save_game();
func completed_hero_mode_game(): #sets true the hero_mode_completed
	save_data["hero_mode_completed"] = true;
	save_game();
	
	
func unlock_all_levels(): #sets true all levels completed
	save_data = {
	"initial_scene_watched":true,
	"tutorial_completed":true, 
	"level_completed":{
		"world1":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},#each world includes in an array the levels completed
		"world2":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
		"world3":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
		"world4":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
		"world5":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
		"world6":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
		},
		"continue_level":[6,6],
		"normal_mode_completed":false,
		"hero_mode_completed":false
	};
	save_game();

func unlock_all(): #unlocks all levels and modes
	save_data = {
	"initial_scene_watched":true,
	"tutorial_completed":true, 
	"level_completed":{
			"world1":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},#each world includes in an array the levels completed
			"world2":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
			"world3":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
			"world4":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
			"world5":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
			"world6":{
				"level1":true,
				"level2":true,
				"level3":true,
				"level4":true,
				"level5":true,
				"level6":true
			},
	},
	"continue_level":[6,6],
	"normal_mode_completed":true,
	"hero_mode_completed":true
	};
	save_game();

func is_level_completed(world:int, level:int): #indicates if a level of a world is completed
	var w = "world"+str(world);
	var l = "level"+ str(int(level));
	return save_data["level_completed"][w][l];
	
func is_world_available(world:int): #indicates if a world is available to play
	var levels = save_data["level_completed"]["world"+str(world)]; #access to the dict of levels
	var res = false; #set this initially as false
	for i in levels.keys(): # moves on the levels by key
		res = levels[i] or res; #aplies an or to the res, then if at least one is true it become true
	return res;
func get_latest_world_level():
	return save_data["continue_level"];
func is_normal_game_completed():
	return save_data["normal_mode_completed"];
func is_hero_game_completed():
	return save_data["hero_mode_completed"];
