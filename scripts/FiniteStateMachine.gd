extends Node
class_name StateMachine

var states : Dictionary ={}
var current_state : State
@export var initial_state : State

# Definitions for state machine. From here state machine will be referred to as SM

# Play on first frame for initialization
func _ready():
	for child in get_children(): # Get all children nodes or states in SM
		if child is State: # Ensure current state is actually a State object
			states[child.name.to_lower()] = child # Add the state to our states Dictionary
			child.state_transition.connect(change_state) # See 'change_state' function below

	# Check if an initial state is available. If so, enter it and set it to our current_state
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

# Play on each frame constantly
func _process(delta):
	# If current_state has a state, update it's Update function with current 'delta' @param
	if current_state:
		current_state.Update(delta)
		

# Handle state transitions. EX. From PlayerIdle to PlayerWalk
func change_state(source_state: State, new_state_name : String):
	if source_state != current_state: # Ensure we are not switching to the same state
		return
	
	var new_state = states.get(new_state_name.to_lower()) # Grab the new state from our dictionary
	if !new_state: # Make sure the new state exists
		print("New state is empty. State does not exist!")
		return
	
	if current_state: # Leave current state
		current_state.Exit()
	
	new_state.Enter() # Safe to enter new state
	current_state = new_state # Set our current state to the new state
	

#DANGEROUS FUNCTION
# Only use force_change_state to immediately switch a state regardless of any actions currently
# taking place in the game. Will break processes if used incorrectly
func force_change_state(_new_state : String):
	pass # TODO

# For Debugging: Get the current state's name
func get_curr_state_name():
	return states.find_key(current_state)
