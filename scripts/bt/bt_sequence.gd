class_name BTSequence
extends BTNode

var children: Array

func _init(children_array: Array):
	children = children_array
	
func tick(actor) -> Status:
	for child in children:
		var result = child.tick(actor)
		if result != Status.SUCCESS:
			return result
	return Status.SUCCESS
