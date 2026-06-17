class_name BTAction
extends BTNode

var action: Callable

func _init(action_callable: Callable):
	action = action_callable
	
func tick(actor) -> Status:
	return action.call(actor)
	
