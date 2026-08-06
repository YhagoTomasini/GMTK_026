extends GridMap

@onready var grassPrefab = preload("res://Prefabs/grass_prefab.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cell in get_used_cells():
		print("teste", cell)
		var grassTile = grassPrefab.instantiate()
		
		grassTile.position = map_to_local(cell)
		add_child(grassTile)
		
		set_cell_item(cell, -1)
