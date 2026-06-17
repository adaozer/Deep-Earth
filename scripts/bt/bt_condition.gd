class_name BTCondition
extends BTNode

var condition: Callable

func _init(condition_callable: Callable):
	condition = condition_callable
	
func tick(actor) -> Status:
	if condition.call(actor):
		return Status.SUCCESS
		
	return Status.FAILURE
