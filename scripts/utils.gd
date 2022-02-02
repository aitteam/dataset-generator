class_name utils


class BoundingBox:
	var center: Vector2
	var size: Vector2


static func find_bounding_box(mesh: MeshInstance, viewport: Viewport) -> BoundingBox:
	var camera = viewport.get_camera()

	var vertices := mesh.mesh.get_faces()
	var xs := []
	var ys := []

	for vertex in vertices:
		var screen_coord = camera.unproject_position(mesh.transform * vertex)
		xs.append(screen_coord.x)
		ys.append(screen_coord.y)


	var bb_min := Vector2(xs.min(), ys.min())
	
	var bb_max := Vector2(xs.max(), ys.max())

	var bb := BoundingBox.new()
	bb.center = (bb_max + bb_min) / 2.0
	bb.size = (bb_max - bb_min)

	bb.center /= viewport.size
	bb.size /= viewport.size

	return bb
