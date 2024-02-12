extends Node
class_name State # State base-class definition

# Define a reference to the state machine
signal state_transition

func Enter():
	pass

func Exit():
	pass

func Update(_delta:float):
	pass
