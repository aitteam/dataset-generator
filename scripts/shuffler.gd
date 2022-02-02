extends Node

signal shuffled(node, index)

var children: Array
var counter := 0

var first_time := true


func _ready():
	children = get_children()


func _process(_delta):
	set_invisible()

	var index = counter % children.size()
	var node = children[index]

	node.visible = true
	node.shuffle()

	counter += 1

	if first_time:
		first_time = false
		return

	var prev_index = (counter-2) % children.size()
	var prev_node = children[prev_index]
	emit_signal("shuffled", prev_node, prev_index)


func set_invisible():
	for child in children:
		child.visible = false
