extends MeshInstance
class_name Class

var base_trans: Transform

var camera: Camera
var viewport: Viewport


func _ready():
	viewport = get_viewport()
	camera = viewport.get_camera()

	base_trans = transform


func shuffle() -> void:
	transform = base_trans
	var new_trans := base_trans

	var angle := PI/4.0
	var rot_x := rand_range(-angle, angle)
	var rot_y := rand_range(-angle, angle)
	new_trans = new_trans.rotated(Vector3.RIGHT, rot_x)
	new_trans = new_trans.rotated(Vector3.UP, rot_y)

	var scalar := rand_range(0.3, 2.0)
	new_trans = new_trans.scaled(Vector3(scalar, scalar, scalar))

	var temp := self.duplicate()
	temp.transform = new_trans
	
	var size := utils.find_bounding_box(temp, viewport).size * camera.size

	var border := Vector2(camera.size - size.x, camera.size - size.y) / 2.0
	var pos := Vector3(rand_range(-border.x, border.x), rand_range(-border.y, border.y), 0.0)
	translation = pos

	rotate_x(rot_x)
	rotate_y(rot_y)
	
	scale_object_local(Vector3(scalar, scalar, scalar))
