GDPC                �                                                                      *   T   res://.godot/exported/133200997/export-1c4ccf19c30d991060cce856f8e5d8a4-inimigo.scn @:      
      	o �u�3*Hb���*�    \   res://.godot/exported/133200997/export-3b2fbc77166f8b536a3588cf73d1bfce-trainingScene.scn   �      ?      �~�����چ�8j�    P   res://.godot/exported/133200997/export-9b393373c1eb3e45f7e6ce3ec7e7dd25-Game.scn�      q      Z.P'�i}��	%>    P   res://.godot/exported/133200997/export-9c07980d7a1263140368f3e964e9708c-bola.scn�4      �      �_�G^p�WW�����    \   res://.godot/exported/133200997/export-d7c74871e067b7f556e00c49a884797a-MultiplayerGame.scn �      �      ����.�6T<���	���    X   res://.godot/exported/133200997/export-e24d008fb2660b537467a44d215dea02-StartScreen.scn  [      �      �}�^�c�4,)%Ƈ�    `   res://.godot/exported/133200997/export-e3e0d61ab0643fb42c64fb6717e76da1-MultiplayerConfig.scn    T      ;      �\�F�>��:[�g�*    T   res://.godot/exported/133200997/export-f23b9c5ad574c3dc2dab589a07ecd601-Player.scn  �L      e      �y� �6��4�� ����    ,   res://.godot/global_script_class_cache.cfg  0t             ��Р�8���8~$}P�    D   res://.godot/imported/bola.png-60e3e58a7cd5f46307cfb625b2a2955f.ctex@0      �      �H)��V�C�]��    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�b             �u�-�Q��^����R�    H   res://.godot/imported/player.png-b12d81cacd41edd115dbd315254b5ad9.ctex  pK      Z       ��Hڸt���4)2�    H   res://.godot/imported/player1.png-33ccefbfcb05d4bd459d111079f53c27.ctex P>      �      �P�ot�0�bȉ�-��    H   res://.godot/imported/player2.png-ec580a8122886e9b061562008663f542.ctex �@      �      y�q��9�O��I���rr    H   res://.godot/imported/player3.png-05631f5c7c584efcddd707072c782583.ctex �C      �      ��Y���B����D.�    H   res://.godot/imported/player4.png-903228dd024f63b1c572167fcbbe2f9c.ctex  F      �      -QH��1�\-�30��       res://.godot/uid_cache.bin  x      l      �aԈL�qK��`��m       res://Sprites/Player.gd �H      �      ⺰����;�c{#�>        res://Sprites/Player.tscn.remap �r      c       5f$���S羆�K��       res://Sprites/bola.gd   -      (      ߱'�cA�8��V8=��        res://Sprites/bola.png.import    4      �       �U�ј��VwD�&�|h        res://Sprites/bola.tscn.remap    r      a       O���ON5^��H�8�       res://Sprites/inimigo.gd�9      M       7�Ih8:�Mg?j�ٞ�        res://Sprites/inimigo.tscn.remappr      d       *�L����D�ۇ��; k        res://Sprites/player.png.import �K      �       �sڰ����i�Կ#        res://Sprites/player1.png.import @      �       %�L#�4(w1nT(        res://Sprites/player2.png.import�B      �       {�ٞ-IP\@����        res://Sprites/player3.png.import0E      �       �'��_�c
�}��u9<O        res://Sprites/player4.png.import�G      �       v�:�m�n�iy�ݯ�        res://UI/MultiplayerConfig.gd   R      �      ����%�v'~���U�M�    (   res://UI/MultiplayerConfig.tscn.remap   Ps      n       ��č�im�J}$�m       res://UI/StartScreen.gd @Z      �       �O~�V`zKy��J�v        res://UI/StartScreen.tscn.remap �s      h       �Ya!����>.;ǃ�/       res://gameScreens/Game.gd           �      �oQbc|�ohmf�
+    $   res://gameScreens/Game.tscn.remap   �p      a       �|�[�`�ŀ��N�a    $   res://gameScreens/MultiplayerGame.gdp      {      t�l+<�yxE�3'9��    ,   res://gameScreens/MultiplayerGame.tscn.remap q      l       ��`�-C������N���    $   res://gameScreens/trainingScene.gd  �      �      3"�xdj���m�^I�    ,   res://gameScreens/trainingScene.tscn.remap  �q      j       z��j�"ɣ��Ī��       res://icon.svg  Pt      �      b�pW>���d���       res://icon.svg.import   �o      �       1`ʿW^������
�q       res://project.binary�z      #      �H˩B��}�A��YXw            extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected


const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "Name"}

var players_loaded = 0



func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	if "--server" in OS.get_cmdline_args():
		hostGame()
	
	
# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
#gets called on client and server when someone connects
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	print("someone connected" + str(id))

#gets called on client and server when someone connects
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	print("someone disconnected" + str(id))

#called on client side and sends info to server
func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

#called on client side
func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()





func join_game(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


func create_game():
	hostGame()


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable","any_peer")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			#$/root/Game.start_game()
			players_loaded = 0



@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func hostGame():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	players[1] = player_info
	player_connected.emit(1, player_info)
            RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://gameScreens/Game.gd ��������      local://PackedScene_rc5tw          PackedScene          	         names "         Game    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC               extends Node2D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in Game.players:#corre no vetor de players

		var currentPlayer = PlayerScene.instantiate()# diz que current player é do tipo que foi passado por parâmetro no export
		currentPlayer.name = str(i)#quando se trata de um dicionário, se eu pegar o i é a key, se eu pehar o i[x] é o value e nesse caso o game.palyers guarda essa merda
		add_child(currentPlayer)#adiciona o player na raiz do nó mas poderia definir um nó para ser pai dele
		for spawn in get_tree().get_nodes_in_group("playerSpawnLocation"): #procura no grupo quais são os nós instanciados
			#if spawn.name == str(index): #verifica o nome do spawn position
				currentPlayer.global_position = spawn.position	#faz assign do ployer x no spawn position x
		index +=1
     RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script %   res://gameScreens/MultiplayerGame.gd ��������   PackedScene    res://Sprites/Player.tscn X��O      local://PackedScene_olyg8 R         PackedScene          	         names "   	      MultiplayerGame 	   position    script    PlayerScene    Node2D    SpawnLocations    0    playerSpawnLocation    1    	   variants       
     @�  �?                   
     �?    
     4B  �C
    `�D  �C      node_count             nodes     *   ��������       ����                                        ����                          ����                            ����                     conn_count              conns               node_paths              editable_instances              version             RSRC             extends Node2D



@onready var CounterEsquerda =$Control/Panel2/CounterEsquerda
@onready var CounterDireita = $Control/Panel/CounterDireita
@onready var bola = $Bola
@onready var paredeDireita = $paredeDireita
@onready var paredeEsquerda = $ParedeEsquerda
@onready var countDireita = 0
@onready var countEsquerda = 0
@onready var pos = Vector2(0,0)
@onready var inicialPosition = $Inimigo.position[0]

@onready var timer = $Control/Timer



func _process(delta):
	timer.text = str(Time.get_ticks_msec() / 1000)




func _physics_process(delta):
	
	pos = bola.position
	definirPosicaoInimigo(pos,delta)	
	
	print($Inimigo.position)


func definirPosicaoInimigo(pos,delta):
	 ## 276 é o tamanho do sprite e da hitbox. se a bola chegasse ao limite da tela a colisão flipa e o objeto é ejetado da tela então esses números mágicos adicionam ou subtraem a posição da hitbox
	if pos[1] == 0:
		$Inimigo.position.y = 276
	elif pos[1] == 1300:
			$Inimigo.position.y = 364
	elif $Inimigo.position[0] >= 2000.0 or $Inimigo.position[0]<0:
		$Inimigo.position.y = bola.position[1]
		$Inimigo.position.x =inicialPosition
		bola.my_velocity = Vector2(0,0)
	else:
		$Inimigo.position.y = pos[1] 




#sim os painés estão trocados
func _on_parede_esquerda_body_entered(body):
	countDireita+=1
	$Control/Panel2/CounterEsquerda.text = str(countDireita)


func _on_parede_direita_body_entered(body):
	countEsquerda +=1
	$Control/Panel/CounterDireita.text = str(countEsquerda)

          RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script    a    b 	   _bundled       Script #   res://gameScreens/trainingScene.gd ��������   PackedScene    res://Sprites/Player.tscn X��O   PackedScene    res://Sprites/bola.tscn ��XE#�96   PackedScene    res://Sprites/inimigo.tscn U��Rv�=      local://RectangleShape2D_ub0r0 �         local://SegmentShape2D_v5nlv �         local://SegmentShape2D_d4twt (         local://RectangleShape2D_weeq3 g         local://SegmentShape2D_5ledf �         local://PackedScene_i78cg �         RectangleShape2D       
     LB  &D         SegmentShape2D       
     �D  �@   
     ��  �@         SegmentShape2D       
   3��D       
     ��             RectangleShape2D       
      A @#D         SegmentShape2D       
     �� @#D         PackedScene          	         names "   3      MainScreen    script    Node2D    Player 	   position    scale    Bola    collision_layer    collision_mask    ParedeEsquerda    monitorable    Area2D    CollisionShape2D    shape    limiteInferior    StaticBody2D    limiteSuperior    visible    paredeDireita    Control    layout_mode    anchors_preset    offset_right    offset_bottom    Timer    anchor_left    anchor_top    anchor_right    anchor_bottom    offset_left    offset_top    grow_horizontal    grow_vertical    Label    Panel    metadata/_edit_group_    CounterDireita    horizontal_alignment    vertical_alignment    Panel2    CounterEsquerda    PD    PE    Inimigo 	   rotation 
   autostart !   _on_parede_esquerda_area_entered    area_entered !   _on_parede_esquerda_body_entered    body_entered     _on_parede_direita_body_entered    	   variants    5                      
     �B  �C
      ?   ?         
     D  C                         
     xA  �C          
         !D               
   �N�?  �?
   ��/B  @@         
    ��D   @
     �@ @�C                    `�D     �B                  ?     8�      �     8B      B           �?     @@     �@    @u�     ��           J�     "�     JB     "B     2�      @     �B     F�     FB
    ��D             
     �?   @         
    ��D ��C   �I�      node_count             nodes     q  ��������       ����                      ���                                 ���                                          	   ����               
   	                    ����      
                           ����                                      ����                           ����      	                                      ����      	                                 ����      	                     
   	       	             ����                                 ����                                      !      ����                                                                                       "   "   ����                                !      "      #      $                #   %              !   $   ����                                          &      '      (      )                %      &                 "   '   ����                                *      +      ,                    !   (   ����                                          -      '      .      )                %      &                     )   ����      /                                ����      0                  *   ����      1                                ����      0               ���+   2         3   ,   4                           ����   -   %             conn_count             conns               /   .                     1   0              	       1   2                    node_paths              editable_instances              version             RSRC extends RigidBody2D
@onready var bola = $"."
var my_velocity = Vector2(500,500)
var reminder  = Vector2(0,0)
var cont = 0
var collision_info

func _physics_process(delta):
	collision_info = move_and_collide(my_velocity * delta)
	
	var angle = my_velocity.angle_to(Vector2.UP)
	
	if collision_info:
		my_velocity = my_velocity.bounce(collision_info.get_normal())
		if cont <=100:
			cont +=1
		#$Sprite2D.global_skew = angle
		
		
	if cont%10 == 0:
		my_velocity.y *=1.01
		my_velocity.x *=1.01
	
	if Input.is_action_just_pressed("point"):
		my_velocity = Vector2(0,0)
	if Input.is_action_just_released("point"):
		bola.position = get_global_mouse_position()
		my_velocity = Vector2(1000,1000) * Vector2(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0))
		cont = 0
		
		

	

	
        GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /� 3O�ґ��ζ]n3�Ȋ�D�܉�:2�#��ͻ�m�U��:۲%�<��s^���;p�6����B�����|�����۷>�����_��|c�����s�����X�?8��H?~9��`����j�۳D&P�,�����R5�G��W��X�,�Yh^錚�嫕�c�^T�)�((G%�Bޑ�ڈ���J��5����Q�K:)�
���K�ꌘ��_.����sF�e�/���a�B� �����;����8��:�����e��0'(� c�؃Y����0Z����'�;��)��ڡ	y�����[�����A����Z����"�u�P�w�p�w�zXf�M�,��VL��Sz`턊���#q��p�A[�u�j�Z���9U�.W�e.g�
���Kn�r�q��5.^;�*xۧ��x��.�ܶ�W��Ҷ���u�ֶ#������3�m�2�kg���e���� ��bl�|���oc;��m{x+���v6w����e�O�%�W�Ŷ9�c g\��6.p�����\�r\��
�؅����q��n{hK�3h�ۧ�b�r>hfh�X=��r�`ٔM��2�:X��3XŴ
V<�FP-M�:x-��ׂ:�-���9x.�C���,D= C��-}U�_4�i�/����8�/�g��
Q��C�	ʖ��%S�@Z
� d���#���4 �D!�1D���ʧ�H�� r��WאXߩK��Iٖ��Œ�B�;$Z9(j"Y�����;�ِx�h��F$ߧJ�誊�H�NAMZ��L��ѣ{�*��.H�j��1)&x ��h�/Q)sLDu>�D�C�oN�� �EU�{k�'�����o�dՍ~�ӯ�[�ŭ���>}���      [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://clqamu1okb54x"
path="res://.godot/imported/bola.png-60e3e58a7cd5f46307cfb625b2a2955f.ctex"
metadata={
"vram_texture": false
}
                RSRC                    PackedScene            ��������                                            
      resource_local_to_scene    resource_name 	   friction    rough    bounce 
   absorbent    script    custom_solver_bias    radius 	   _bundled       Script    res://Sprites/bola.gd ��������
   Texture2D    res://Sprites/bola.png ѿ,�C�hM      local://PhysicsMaterial_3ylht �         local://CircleShape2D_2rgqc          local://PackedScene_vxyi4 ,         PhysicsMaterial             CircleShape2D          6|BB         PackedScene    	      	         names "         Bola 	   position    scale    collision_layer    collision_mask    physics_material_override    script    RigidBody2D 	   Sprite2D    texture    CollisionShape2D    shape    	   variants    	   
     D  C
   :��?  �?                                
      ?   ?                        node_count             nodes     '   ��������       ����                                                          ����         	                  
   
   ����                   conn_count              conns               node_paths              editable_instances              version             RSRC         extends CharacterBody2D

func _physics_process(delta):
	move_and_slide()
   RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://Sprites/inimigo.gd ��������
   Texture2D    res://Sprites/player2.png �y�#f�       local://RectangleShape2D_com5p �         local://PackedScene_rvlmg �         RectangleShape2D       
     �B  �C         PackedScene          	         names "   	      Inimigo    collision_mask    script    CharacterBody2D    CollisionShape2D 	   position    shape 	   Sprite2D    texture    	   variants                       
     �  ��                         node_count             nodes        ��������       ����                                  ����                                 ����                   conn_count              conns               node_paths              editable_instances              version             RSRC      GST2   �   %     ����               � %       �  RIFF�  WEBPVP8L|  /� I' Ha�/$H��ئX0ŻRIA������^b	HRdEDhGm$I�R
��R@��Oj������ Dmۨ`
`R!�?���~��p�F�$%��R@��O��7��3��p��P�\ݍ�7sn�n\�Zk�c+��Z#I{�,���9�
�/5�|��Ϣ
 �
>50�R���Ϧ@T�@��������:�@�����K����J S�]�t���]��0D=�JT�]�J�q�W���2��(������7ҩ�H���HI/S���S���(�A�+���<Bc�"�G�<"CtE ��!xD���G�7�#��:" g�����'袞��zB.z(P�����9ޥ<=�LZ��2�        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://xitcbkeo2kw5"
path="res://.godot/imported/player1.png-33ccefbfcb05d4bd459d111079f53c27.ctex"
metadata={
"vram_texture": false
}
              GST2   �   %     ����               � %       |  RIFFt  WEBPVP8Lg  /� I0�1��$��f��% I��!G��H�#�Z���c��E8�kI�W���"�?�"Ɋ�4$�+�I|"�$��/U�G�$��H	�>�Z	}���ևsD�'`tރ�z������S�1���^>�J�Q)��i�|6�ư��Z����F A�"�A�6@$r#3wlA1�Abn[6��(rc`nH��al)�ȍ��d$6�b���B2WpJ6'#Q.��Ɨ��t�e���߿�o�v�EH߅��i�4��I�>"R}� gi�>"1�ѱ6��*
7C��cmHGP����ѱ6$�p3��Րp��!�&�
�&��^Po�KA�vQ��%PW�VQxo�tD:�l             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://8qj67t7ut1c7"
path="res://.godot/imported/player2.png-ec580a8122886e9b061562008663f542.ctex"
metadata={
"vram_texture": false
}
              GST2   �   %     ����               � %       p  RIFFh  WEBPVP8L\  /� I0�>$�$��f8�X�Y�Q$۪iOB���'!�%���z�&����m$g��m!.�� r�wRD��q#I�Ԧ�	���	�~��t�ɃwD�'`��h6g�,(����և�Z�u]����k7�� �� ��)֝ n�)�S;Ap5@

��9��#�NP8��aI�S��anICHjg�h(��ǘ����Hn��Q�c�k����>�I������E���n��PvN��PYǸR#�R$33:�͐��!��B�f��`���9n�CR��p1̨��Np3V��Np1j'��EP;A�� �k�(P����fQxo�tD:�G        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://qp47akkno7da"
path="res://.godot/imported/player3.png-05631f5c7c584efcddd707072c782583.ctex"
metadata={
"vram_texture": false
}
              GST2   �   %     ����               � %       �  RIFF�  WEBPVP8Lw  /� I' H�~�!	�����!b	HRdEDhX�m��
	���]�����M�a���� j�FS �
���ew�����F�$I!� ��(���{<#�?�=��?>]�Ѓӳ���q�ֲ�w�>U�F'�,��K8^j��Q�q�Y�T`T!G� 0�`���`���z�0��%�Q��q	`��%�tq�t� \"]Fo��yW܂*�yW�~��[������(���翏Qɇ��hX}$'�\)Ê�cV)Ê�㤠2�R�!]�-x����!�%<B@W��G�xD�z� :" ޠ�#p6( ޠ���z�.�	��'�g�r�� ��Oy��/��)O��%�)C�             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cfs6e75tqil0k"
path="res://.godot/imported/player4.png-903228dd024f63b1c572167fcbbe2f9c.ctex"
metadata={
"vram_texture": false
}
             extends CharacterBody2D

@onready var player = $"."

const speed = 1000
var score:int = 0
#signal _marcarPontos(score)

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())#faz com que cada player seja seu próprio multiplayerAuthority. assim os movimentos que ele fizer só vao ser refletidos nele mesmo

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * speed

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		get_input()
		move_and_slide()
		if player.get_last_slide_collision():
			score +=1
			#emit_signal("_marcarPontos",score)
        GST2   4   �      ����               4 �        "   RIFF   WEBPVP8L   /3�2 �DD�      [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://x8s10b88xyms"
path="res://.godot/imported/player.png-b12d81cacd41edd115dbd315254b5ad9.ctex"
metadata={
"vram_texture": false
}
               RSRC                    PackedScene            ��������                                                  . 	   position    resource_local_to_scene    resource_name    custom_solver_bias    size    script    properties/0/path    properties/0/spawn    properties/0/replication_mode 	   _bundled       Script    res://Sprites/Player.gd ��������
   Texture2D    res://Sprites/player1.png ��*��      local://RectangleShape2D_gsd5f !      %   local://SceneReplicationConfig_ao2hr R         local://PackedScene_vxlai �         RectangleShape2D       
     0A ��C         SceneReplicationConfig                            	                  PackedScene    
      	         names "         Player 	   position    collision_mask    script    CharacterBody2D    CollisionShape2D    shape 	   Sprite2D    texture    MultiplayerSynchronizer    replication_config    	   variants       
     �A  �B                
     ��  ��                                  node_count             nodes     *   ��������       ����                                        ����                                 ����                     	   	   ����   
                conn_count              conns               node_paths              editable_instances              version             RSRC           extends  Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_host_button_down():
	var valor = Game.create_game()
	print("aguardando jogadores")
	
	if valor != null:
		$Panel/Label.text = "Servidor já criado no pi " + Game.DEFAULT_SERVER_IP
		
	
func _on_join_button_down():
	Game.join_game()
	


func _on_play_button_down():
	Game.player_loaded.rpc()
	Game.load_game.rpc("res://gameScreens/MultiplayerGame.tscn")
	
	
	
   RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://UI/MultiplayerConfig.gd ��������      local://PackedScene_1dtp1          PackedScene          	         names "         Lobby    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    Control    Panel    GridContainer    anchor_left    anchor_top    offset_left    offset_top    offset_right    offset_bottom    Host    text    Button    Join    Play    _on_host_button_down    button_down    _on_join_button_down    _on_play_button_down    	   variants                        �?                                  ?     �     ��     B     �B      Host       Join       Play       node_count             nodes     h   ��������       ����                                                          	   	   ����                                                  
   
   ����                                                	      
                                      ����                                ����                                ����                         conn_count             conns                                                                                      node_paths              editable_instances              version             RSRC     extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://gameScreens/trainingScene.tscn")


func _on_multiplayer_pressed():
	get_tree().change_scene_to_file("res://UI/MultiplayerConfig.tscn")
     RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://UI/StartScreen.gd ��������      local://PackedScene_gohgg          PackedScene          	         names "         Control    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    Panel    offset_right    offset_bottom    Label    anchor_left    offset_left    text    horizontal_alignment 	   ItemList    anchor_top    offset_top    SoloPractice    Button    multiplayer    _on_button_pressed    pressed    _on_multiplayer_pressed    	   variants                        �?                            �D    @"D                  ?    �K�    �KC     �B   (   Best version of pong you will ever play            ��     �     �C     C     ~�     ��     ~B     �A      Solo practice      x�     B     |B     �B      Multiplayer       node_count             nodes     �   ��������        ����                                                                ����         	      
                       ����
            	      
      
         	      
                                         ����                  
      
      
      
               	      
                                   ����                  
      
      
      
               	      
                                         ����                  
      
      
      
               	      
                                  conn_count             conns                                                              node_paths              editable_instances              version             RSRC      GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,�젮�N{2n�d��5���$I������ԇ$W�NT���H�ɊȌ�j���k��f�v칢�����n�d'��3���Gu��^�6R�Lw��@m��B���fZ��X�m���n�ضgֶm۶1�Iw=Ou*��۶����O�ii;@T�֏ٶڶ���vzw�WK��Cp#I��\ރخ}C\A6���$
2#�E.@$���A.��	G��( RD!F�JWl��$@G����� ����:ȁ�)��D]Rٴ"����P��ZK�*�F�Ww$+�wz=˻>�Ӗn�8�]�f���bw��C�AK�����貂���-ݺq��EO��U��1b8���KK���]�h�{Bb�k@#�Nu��m�h
�C��Cȩ��[�U�P.e�F�#��jqc���m�w��,ݺ�|���AfZ_���u2�Żm�ҭS�wj [ȅq=K�\�����q�G���� ����>�.W6�?�(ݺh���|��y��o��FRo�����w����N��I��e��Y��L�78�c%��ڔ[.�7l�NH�9�ʘ�\�Yʶ)vO\~�P��!�?�\��+P�o��Ⱥ�ŬZ���R�w�^5:!�Ta:Y�p��`��CJ���	)�z5�RF�u�5��$�,�M�0���n�m1�j�	�5��6h%sË�ص�R�:TB��W�q��6�o�=���V�_¡E0��y�ѬWT U�b�6Y�����?�xJJ1��z��ǃ�V���������Y�O�I����;����mM��d)sN��K�|)�z-Z�=��=�JI����J�k�OF��R��Te;m���m�$G��6�Ka����X�$�s�(�W�o��3!�l8s?+Ő�WS�t`��gojQ��F�Ӣ�VS���wuZRl�ס���^T�(_�^�*$��!�,����T�P���o�#��%�	����?�K������'Yʂ&9]����ˢ�Y��N�/YaZY�¦JƧ�#�?�R8��ʅ���,�R9�Q	�ZJ��`x�j݋�̝�!��X��,�o5�?���J�-��㳨փ�*L�R=4�;-��'���Pq�{1�YL�����	Q�:ET�:!�"ng%"�}�P	�L�ף����B.o��/�r���5,=���5���\�>�Ĺ��������/l�p�=d���{�_E�G��{���_��Y��θ���`X�3Pq���I+���@ 8;��>��	��+��o�6��
PEL�B�H�N�`������c�Q7Q2�+qQ�y�j�OC�C��?��DDb=�5~ħA ����Y���2���J]_�� A��zb�4/��ݏ:4o���$�+�B�  :���W�L |�����U+5�-�A�l�Ol}�ͭvD=��p"V��S��`�q|r�l	F� 4�1{�V'&�Y 鉡|pj� ߫'�?��Ȩ&�o�H#b��K����@D�˅ �x?Y-�pfV� ,!f�.�"86��j"�� '�J��CM�+ � Ĝ��"���,� ���Wo��	�0C����q'�5.��z@�S1,5ڴ�^��~L�t"�"�RS��Xw.�m[/����;�P�9��L��L�*]_����ur��s�3Ȗ+�^� �>�nnq�E�!R,<�D?����K�n�f�����m�QP�n�:b3�+��6�Yd)� e��-�� �z�`b=�;q�~�k��,�ܝj�?�W�X� @OwV�Џ�j��c��Ds�V�X ���\f�E���y��c��⋹�hx���ӗի�R�]�g�r�˶/����n�;�SSup`�S��6��u����f;Z�INs�|�oh�f�Pc�����^��gzt����x��)wq�Q�My53jƓa���8�6��,�F�ڸ����2��#�)���"�u���}'�"�>�����ǯ[����82һ�n�ٵ0�<v�ݑa}.+n��'����W:4Y�����P��(�k�Mȫۿ�Ϗ��?����Ӧ�K�|y�@suy��<�����{��x}~������~�IN=�s�ޝ�GG�����[�L}~�`�f%T�R!1�no���������v!�G���]��qw��m���E�Br�5���\1/.�j���c��g�\���p�,50l�>=}��
0���l�b�Y�+��dz����v+2ǚ�Ȋl	�Ȭ��"�H�Y&5�M���	ɗN�e؈�3�����n���|0X���
�W�C%�&5<��u�L��&9�6�#e��I��^e_ �G=�I�cΆ�J���>���N�/��׷�G��[���\��T��Ͷh���Qg?1��O��4{s{�����1�Y�����91Qry��=����y=/~٦h'�����[�tD�j��P����� *b��QN��������7��+K�e��T�@j��)��9;�J��JF�#������c��l���I{x�O��K��U��_]>>=_~}�����?��h�:� 5~}���/���߷˿˅8=+����ӝu��;镜�����\Ir�c��,���װ��ު�L�G���8�� �lG��Jr�){�|[�`��iO?޿�$�>�X��-<���r��r�x�������]_n�\
�^������o��u�w	������n�t{8���揫/�������7K�sp��~/{�$'mm�s�`z�wY������i�*��I�)���8t �?i�g�;].� ^ױ�[�o��[��R��w�*A��,�2h�f������}F��[�z!�p5���2hѥ�K���^	d��,������ps6��{���y;�2���=�<��s2�f��#=�bFsТ��i�CZ�A,��d���:T�;X�5�&hхͻ��1C�!hѮ^��7�������o�,��l@b��ze�� 1�w}���l�D.��Yz�r���T�#O�<��l��i#�S��!GĶ�EO}r�K����A�\�<N�zd!E��
R��z�S����x�ö�\.�2)"E �@3o9u�.y�@��e*H�m����]�h�HB.�#bD�j��V8ߥ��Eh���\�ejL�ku�;����l�>N{;����)�P���ʘ�R(E�����n�P.�5a��R7 �0bo��Y���k�%E��;����ÆB�2]m��ր^�Ȗ�4���1h�O������
(�WX[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bmrnfs2jybsgw"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-9b393373c1eb3e45f7e6ce3ec7e7dd25-Game.scn"
               [remap]

path="res://.godot/exported/133200997/export-d7c74871e067b7f556e00c49a884797a-MultiplayerGame.scn"
    [remap]

path="res://.godot/exported/133200997/export-3b2fbc77166f8b536a3588cf73d1bfce-trainingScene.scn"
      [remap]

path="res://.godot/exported/133200997/export-9c07980d7a1263140368f3e964e9708c-bola.scn"
               [remap]

path="res://.godot/exported/133200997/export-1c4ccf19c30d991060cce856f8e5d8a4-inimigo.scn"
            [remap]

path="res://.godot/exported/133200997/export-f23b9c5ad574c3dc2dab589a07ecd601-Player.scn"
             [remap]

path="res://.godot/exported/133200997/export-e3e0d61ab0643fb42c64fb6717e76da1-MultiplayerConfig.scn"
  [remap]

path="res://.godot/exported/133200997/export-e24d008fb2660b537467a44d215dea02-StartScreen.scn"
        list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
            �������b   res://gameScreens/Game.tscn��u�p�!   res://gameScreens/MainScreen.tscnѿ,�C�hM   res://Sprites/bola.png��XE#�96   res://Sprites/bola.tscnU��Rv�=   res://Sprites/inimigo.tscn��*��   res://Sprites/player1.png�y�#f�    res://Sprites/player2.png�е�>
   res://Sprites/player3.png(\����G   res://Sprites/player4.png2D�a]   res://Sprites/player.pngX��O   res://Sprites/Player.tscnY�{�yx   res://UI/MultiplayerConfig.tscnIG�<�@�O   res://UI/StartScreen.tscn#EM�N-   res://icon.svg �L�T)�4&   res://gameScreens/MultiplayerGame.tscn��u�p�$   res://gameScreens/trainingScene.tscn    ECFG      application/config/name         Pong   application/run/main_scene$         res://UI/StartScreen.tscn      application/config/features   "         4.2    Mobile     application/config/icon         res://icon.svg     autoload/Game$         *res://gameScreens/Game.gd     input/up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script      
   input/down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/point�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script         input/right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script      
   input/left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         layer_names/2d_physics/layer_1         player     layer_names/2d_physics/layer_2         bola   layer_names/2d_physics/layer_3         parede  #   rendering/renderer/rendering_method         mobile               