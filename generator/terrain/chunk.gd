extends StaticBody3D

@export var ground : Mesh
var groundMap : Array

@onready var colShape = $collision
@export var colShapeSize = 26
@export var colShapeSizeRatio = 1.0
@export var heightRatio = 1.0

var img = Image.load_from_file("res://terrain/heightmaps/sample.jpg")
var imgChunk
var shape = HeightMapShape3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	ground = ArrayMesh.new()
	groundMap = $ground.mesh.surface_get_arrays(0)
	groundMap[0] = Array()
	ground.clear_surfaces()
	
	imgChunk = img.get_rect(Rect2i(0,0,333,333))
	imgChunk.convert(Image.FORMAT_RF)
	imgChunk.resize((colShapeSize + 1)*colShapeSizeRatio, (colShapeSize + 1)*colShapeSizeRatio)
	
	var w = imgChunk.get_width()
	var h = imgChunk.get_height()
	var data = imgChunk.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *= heightRatio
		
	var k = 0
	for y in range(0, h):
		for x in range(0, w):
			groundMap[0].append_array([x, data[k], y])
			k += 1
	
	var mdt = MeshDataTool.new()
	mdt.create_from_surface($ground.mesh, 0)
	ground.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, groundMap[0])
	mdt.commit_to_surface(ground)
	$ground.mesh = ground
	
	shape.map_width = colShapeSize + 1
	shape.map_depth = colShapeSize + 1
	shape.map_data = data
	colShape.shape = shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
