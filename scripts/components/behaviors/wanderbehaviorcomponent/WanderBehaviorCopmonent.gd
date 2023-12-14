extends Node2D

class_name WanderBehaviorComponent

## The stats sychronizer used to check if the parent node is dead or not
@export var stats_component: StatsSynchronizerComponent

## The minimum time the parent will stay idle
@export var min_idle_time: int = 3

## The maximum time the parent will stay idle
@export var max_idle_time: int = 10

## The maximum distance the parent should wander off to
@export var max_wander_distance: float = 256.0

# The parent node
var _target_node: Node

# The component used to handle the wandering
@onready var _wander_component: WanderComponent = $WanderComponent

# The avoidance ray component is used to detect obstacles ahead
@onready var avoidance_rays_component: AvoidanceRaysComponent = $AvoidanceRaysComponent


func _ready():
	# This node should only run the server side
	if not G.is_server():
		set_physics_process(false)
		queue_free()

	_target_node = get_parent()

	if _target_node.get("position") == null:
		GodotLogger.error("target_node does not have the position variable")
		return
	if _target_node.get("velocity") == null:
		GodotLogger.error("target_node does not have the position variable")
		return


func _physics_process(_delta: float):
	_behavior()


func _behavior():
	# If the parent node is dead, don't do anything
	if stats_component.is_dead:
		_target_node.velocity = Vector2.ZERO
		return

	_wander_component.wander()
