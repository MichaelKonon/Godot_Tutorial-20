extends Position3D

var base_zombie = preload("res://Enemies/zombies/base_zombie/base_zombie.tscn") #Подгружаем сцену нашего зомби
onready var navigation_parent = $"../Navigation/NavigationMeshInstance" #Указываем что родителем зомби должен быть не точка 3д, а нода навигации


func _ready():
	pass 


func _physics_process(delta):
	pass
	
	
func spawn():
	var  navigation = navigation_parent #подгружаем переменную родителя
	var base_zombie_instance = base_zombie.instance() #спавним зомби
	navigation.add_child(base_zombie_instance) #добавляем зомби к нашей ноде навигации, что бы он мог строить маршрут
	base_zombie_instance.global_transform = $".".global_transform #указываем что его координаты должны быть-
																	#-кординаты точки спавна


func _on_Timer_timeout():
	spawn()
	print("spawn")
