extends Node2D



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

