extends Node2D

@onready var tutorial_text = $Player/Camera2D/PlayerUI/PlayingInterface/TutorialInfo/Info; #info to the tutorial
@onready var coins_arrow = $Player/Camera2D/PlayerUI/PlayingInterface/CoinssArrow; #arrow that points at the coins marker
@onready var hits_arrow = $Player/Camera2D/PlayerUI/PlayingInterface/HitsArrow; #arrow that points at the hits marker
var show_coins_arrow = false; #controls whether each arrow shows or not
var show_hits_arrow = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#preparing the buttons of menu to show info:
	$Player/Camera2D/PlayerUI/PauseMenu/Panel/VBoxContainer/Continue.mouse_entered.connect(show_continue_info);
	$Player/Camera2D/PlayerUI/PauseMenu/Panel/VBoxContainer/MainMenu.mouse_entered.connect(show_main_menu_info);
	$Player/Camera2D/PlayerUI/PauseMenu/Panel/VBoxContainer/ResetLevel.mouse_entered.connect(show_reset_level_info);
	$Player/Camera2D/PlayerUI/PauseMenu/Panel/VBoxContainer/Exit.mouse_entered.connect(show_exit_level_info);
	#UI overwrite when it's disabled or enabled
	$Player/Camera2D/PlayerUI.draw.connect(enter_menu_info);
	$Player/Camera2D/PlayerUI.hidden.connect(exit_menu_info);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##### showing or hiding the arrows
	if show_coins_arrow:
		show_arrow(coins_arrow,delta);
	else:
		hide_arrow(coins_arrow,delta);
	if show_hits_arrow:
		show_arrow(hits_arrow,delta);
	else:
		hide_arrow(hits_arrow,delta);

#######################
# Functions
#######################
# show_arrow:
func show_arrow(arrow,time):
	arrow.color[3] += time*0.8 if arrow.color[3] < 0.8 else 0;
func hide_arrow(arrow,time):
	arrow.color[3] -= time*0.8 if arrow.color[3] > 0 else 0;
# write a tutorial message
func print_tutorial_message(message:String):
	tutorial_text.text = message;

########################
# Areas
########################
# Jump area
func _on_jump_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Salta, Slite! Salta!!!\nA/LT(Xbox)   X/L2(Ps)\nB/ZL(Nswitch)   Space/Enter(PC)");
		show_hits_arrow = false;
# Fall area first time
func _on_fall_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Mira, un hueco, Slite! \n intenta tirarte a este hueco");
# Fall area second time
func _on_fall_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Muy bien, ahora vamos a cruzar\n Salta al otro lado, Slite!");
# Updating areas
func _on_update_fall_areas_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if $Areas.find_child("Fall1"): #checks if the Fall1 exists
			$Areas/Fall2/CollisionShape2D.position.y = $Areas/Fall1/CollisionShape2D.position.y; #equals height
			$Areas/Fall1.queue_free(); #dissapears first area
		print_tutorial_message("Al caer por un precipicio \n reaparecerás al inicio...\ny perderás un corazón!");
		show_hits_arrow = true;
# Enemies area
func _on_enemies_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Mira ahí arriba, Slite!\nEstos pobres sucumbieron al hechizo\nten cuidado, te pueden dañar!");
# Checkpoints
func _on_checkpoints_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Eso de ahí es un checkpoint!\nAl activarlo acercándote te permite\n reaparecer en su posición");
# enviromental damage area
func _on_enviromental_damage_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_hits_arrow = false;
		print_tutorial_message("Eso de ahí adelante te puede dañar, Slite!\n evitalo saltando, o disminuirá tu vida");
# enviromental damage area 2
func _on_enviromental_damage_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_hits_arrow = true;
		print_tutorial_message("Recuerda siempre mirar tus corazones\nSi pierdes todos volverás al último checkpoint");
func _on_fall_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_hits_arrow = false;
		print_tutorial_message("Mira, otro precipicio, Slite!\nEsta vez al caer volverás\nal último checkpoint, inténtalo");
	# update fall areas 2
func _on_update_fall_areas_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Areas/Fall3/CollisionShape2D.position.y = -1500;
		print_tutorial_message("Lo ves, ahorramos tiempo\nVamos, ahora salta al otro lado!");
# portals area
func _on_portals_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_hits_arrow = false;
		print_tutorial_message("Adelante, Slite! eso de ahí es...\nUn portal!, al entrar a él\nirás a otra zona, vamos!");
# portals area 2
func _on_portals_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Solo ten cuidado\nal cruzar un portal\nno podrás volver!");
# pause area
func _on_pause_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameMaster.tutorial_pause = true;
		print_tutorial_message("Qué cansado, pausemos!\nmenú (Xbox)   start(Ps)\n+(Nswitch)   backspace(PC)");
# coins area
func _on_coins_collect_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Mira! medallas!!!\nTómalas acercándote a ellas\nrecuerda reunir todas!");
# bouncepad area
func _on_bounce_pads_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_coins_arrow = false;
		print_tutorial_message("Ese de ahí es un resorte!\nIntenta saltar encima de él!");
# coins number area
func _on_coins_number_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_coins_arrow = true;
		print_tutorial_message("No olvides tu misión!\nMira cuantas medallas llevas\ny cuántas faltan en esta zona");
# final message areas
func _on_final_message_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		show_coins_arrow = false;
		print_tutorial_message("Este es el inicio de tu aventura\nHabrán más enemigos\ny medallas!");
func _on_final_message_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Habrán muchos obstáculos, también\nPor favor, no vayas a rendirte\nLlega hasta el fin, Slite!");
func _on_final_message_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print_tutorial_message("Toma la última moneda de aquí\nConfio en tí\nSálva el mundo, Slite!");
#######################################
# Pause menu functions
#######################################
func show_continue_info():
	$Player/Camera2D/PlayerUI/PauseMenu/TutorialInfo/Info.text = "Esta opción permite reanudar la acción";
func show_main_menu_info():
	$Player/Camera2D/PlayerUI/PauseMenu/TutorialInfo/Info.text = "Esta opción te permite volver al menú"
func show_reset_level_info():
	$Player/Camera2D/PlayerUI/PauseMenu/TutorialInfo/Info.text = "Esta opción permite reiniciar la zona";
func show_exit_level_info():
	$Player/Camera2D/PlayerUI/PauseMenu/TutorialInfo/Info.text = "Esta opción permite salir del juego";
func enter_menu_info():
	$Player/Camera2D/PlayerUI/PauseMenu/TutorialInfo/Info.text = """Este es el menú de pausa
Con control muevete con las flechas o el stick izquierdo
En PC puedes usar el mouse para seleccionar una opción""";
func exit_menu_info():
	$Player/Camera2D/PlayerUI/PlayingInterface/TutorialInfo/Info.text = "Listo, vamos a continuar";


func _on_continue_button_down() -> void:
	pass # Replace with function body.


func _on_continue_button_up() -> void:
	pass # Replace with function body.
