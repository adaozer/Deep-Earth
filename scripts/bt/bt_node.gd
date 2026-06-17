class_name BTNode
extends RefCounted

enum Status { SUCCESS, FAILURE, RUNNING }

func tick(actor) -> Status:
	return Status.FAILURE
