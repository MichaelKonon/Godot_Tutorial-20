extends KinematicBody
var velocity = Vector3() #Говорит движке о пространстве и о том где находится обьект и о его скорости
const SPEED = 5.0 #Скорость
const JUMP_VELOCITY = 4.5 #сила прыжка

#Оружие
var current_weapon = null
var rifle = preload ("res://weapons/rifle.tscn")
onready var weapon_position = get_node("weapon_Position3D")


var gravity = 9.8

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	#########################Мышь#################
	
	var mouse_motion = get_viewport().get_mouse_position()

	#Проверяем наличие оружия в радиусе игрока на земле и подбираем его
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if body.name == "rifle":
			current_weapon = "rifle"
			print(body.name)
			body.queue_free()
			weapon_position.add_child(rifle.instance())
			
	

	 #функция которая работает всегда и выполняется каждую милисекунду
	# добавляем гравитацию
	if not is_on_floor():
		velocity.y -= gravity * delta

	# реализация прыжка с помошью кнопки пробел
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Получаем данные о том нажимает ли игрок на клавиши движения в рахные стороны
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#немного вычислений для опредиления направления нашего игрокаи его нормализации
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#реализация движения игрока по всем осям
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide(velocity, Vector3.UP, true) #метод который используя данные о том как движется объект опредиляет как он сталкивается
	#####################Нажатия клавиш####################################
	if Input.is_action_just_pressed("CLOSE_GAME"):
		get_tree().quit()

#######################Обработка мышки и ее движений#############################
func _unhandled_input(event):
	var mouse_sensitivity = 0.002
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -60, 60)
		$weapon_Position3D.rotation_degrees.x = clamp($Camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -60, 60)
		
