extends MeshInstance3D

var groundMap
@export var ground : Mesh
var groundSurface

@onready var colShape = get_parent().get_node("collision")

# Called when the node enters the scene tree for the first time.
func _ready():
	ground = self.mesh
	groundMap = self.mesh.surface_get_arrays(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
