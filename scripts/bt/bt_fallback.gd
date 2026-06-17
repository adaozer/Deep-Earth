class_name BTFallback
extends BTNode

var children: Array

func _init(children_array: Array):
	children = children_array
	
func tick(actor) -> Status:
	for child in children:
		var result = child.tick(actor)
		if result != Status.FAILURE:
			return result
	return Status.FAILURE
