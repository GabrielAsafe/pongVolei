extends RigidBody2D
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
		
		

	

	
