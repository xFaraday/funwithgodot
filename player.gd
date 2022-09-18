extends KinematicBody
# physics
var moveSpeed : float = 15.0
var jumpForce : float = 15.0
var gravity : float = 12.0
# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 10.0
# vectors
var mouseDelta : Vector2 = Vector2()
# components
onready var camera : Camera = get_node("Camera")
onready var muzzle : Spatial = get_node("Camera/Muzzle")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var velocity = Vector3.ZERO
func _physics_process(delta):
	# reset the x and z velocity
	var direction = Vector3.ZERO
	
	var input = Vector2()
	# movement inputs
		
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#$Pivot.look_at(translation + direction, Vector3.UP)
		
	velocity.x = direction.x * moveSpeed
	velocity.z = direction.z * moveSpeed
	
	velocity.y -= gravity * delta

	velocity = move_and_slide(velocity, Vector3.UP)

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumpForce
		
	
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
	mouseDelta = Vector2()
