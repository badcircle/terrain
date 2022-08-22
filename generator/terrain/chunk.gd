extends StaticBody3D

@export var ground : Mesh
var groundMap : Array

@onready var colShape = $collision
@export var colShapeSize = 200
@export var heightRatio = 7

@export var img : Image
@export var noise : NoiseTexture
@onready var mats = $ground.mesh.material

# Called when the node enters the scene tree for the first time.
func _ready():
	noise = NoiseTexture.new()
	noise = load("res://terrain/heightmaps/land_mass_noise.tres")
	await noise.changed
	img = noise.get_image()
	img.resize(colShapeSize, colShapeSize)
	$ground.mesh.size = Vector2(colShapeSize, colShapeSize)
	$ground.mesh.subdivide_width = colShapeSize - 2
	$ground.mesh.subdivide_depth = colShapeSize - 2
#	Create blank data lists
	ground = ArrayMesh.new()
	groundMap = $ground.mesh.surface_get_arrays(0)
	groundMap[0] = PackedVector3Array()

#	Look at the correct chunk
	var imgChunk = img
	imgChunk.convert(Image.FORMAT_RF)
	var w = imgChunk.get_width()
	var h = imgChunk.get_height()
	var data = imgChunk.get_data().to_float32_array()
	var shapeData = PackedFloat32Array()

#	Create data lists for heights of heightmap image
	var k = 0
	for y in range(0, h):
		for x in range(0, w):
			shapeData.push_back(data[k] * heightRatio)
			groundMap[0].push_back(Vector3(x,shapeData[k],y))
			k += 1
	
	for d in range(groundMap[0].size(), data.size()):
		data.remove_at(d)
			
	print(shapeData.size())
	print(groundMap[0].size())
	print(h)
#	Set Collision Shape
	var shape = HeightMapShape3D.new()
	shape.map_width = w
	shape.map_depth = h
	shape.map_data = shapeData
	colShape.shape = shape

#	Add new ground mesh
	var mdt = MeshDataTool.new()
	ground.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, groundMap)
	mdt.commit_to_surface(ground)
	$ground.mesh = ground
	$ground.mesh.surface_set_material(0, mats)
	
#	Generate correct shadows
	var st = SurfaceTool.new()
	st.create_from($ground.mesh, 0)
	st.generate_normals()
	st.generate_tangents()
	st.commit($ground.mesh)
	
#	Move ground to correct position
	$ground.position = Vector3(colShapeSize*-0.5,0,colShapeSize*-0.5)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
