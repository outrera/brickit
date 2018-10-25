extends Control


onready var bricks = $Field/Bricks


func _ready():
	GLOBAL.connect("level_changed", self, "change_level")
	# boot level 1
	change_level(1)

func is_level_clear():
	return bricks.get_child_count() == 0


func clear_level():
	for node in bricks.get_children():
		node.queue_free()

func change_level( to ):
	clear_level()
	yield( get_tree().create_timer(1.0), "timeout" ) #wait a second 
	var map = load("res://Game/Levels/Level %d.tscn" % to )
	if map:
		map = map.instance()
		for cell in map.get_used_cells():
			var brick_name = map.tile_set.tile_get_name( map.get_cellv( cell ) ) 
			var brick = load("res://Brick/%s.tscn" % brick_name )
			if brick:
				brick = brick.instance()
				bricks.call_deferred("add_child", brick)
				brick.position = map.map_to_world(cell) - bricks.position
		
		
		map.queue_free()
	


func _on_Ball_brick_broke():
	GLOBAL.score += GLOBAL.BRICK_VALUE
	if is_level_clear():
		GLOBAL.next_level()
