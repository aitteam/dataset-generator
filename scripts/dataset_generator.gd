extends Spatial

export var image_per_class = 0;
export(Vector2) var image_size
export(String) var output_folder

var total_image_count := 0
var counter := 0;
var viewport: Viewport
var camera: Camera
var background: MeshInstance
var shuffler: Node
var background_images := []


func _ready():
	camera = $Camera
	background = $Background
	shuffler = $Shuffler

	viewport = get_viewport()

	load_images("res://assets/images/")
	
	total_image_count = shuffler.get_child_count() * image_per_class

	randomize()

	save_classes()

	shuffle()


func _on_Shuffler_shuffled(node, index):
	save_viewport()
	var bb := utils.find_bounding_box(node, viewport)
	save_label(bb, index)

	counter += 1

	if counter == total_image_count:
		get_tree().quit()
		return

	shuffle()


func shuffle() -> void:
	viewport.size = image_size

	var image_index = counter % background_images.size()
	background.get_surface_material(0).albedo_texture = background_images[image_index]

	camera.environment.ambient_light_energy = rand_range(0.2, 2.0)


func load_images(path: String) -> void:
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.find("import") == -1:
				var image := load(path + file_name)
				background_images.append(image)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the image path.")


func save_viewport() -> void:
	var image := viewport.get_texture().get_data()
	image.flip_y()
	image.save_png(output_folder + "/images/" + str(counter) + ".png")


func save_label(bb: utils.BoundingBox, class_num: int) -> void:
	var label := File.new()
	var file_name: String = output_folder + "/labels/" + str(counter) + ".txt"
	label.open(file_name, File.WRITE)
	label.store_line(str(class_num) + " " + str(bb.center.x) + " " + str(bb.center.y) + " " + str(bb.size.x) + " " + str(bb.size.y))
	label.close()


func save_classes() -> void:
	var classes_txt := File.new()
	classes_txt.open(output_folder + "/labels/classes.txt", File.WRITE)
	for child in shuffler.get_children():
		classes_txt.store_line(child.name)
