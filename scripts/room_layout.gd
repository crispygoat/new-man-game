extends Node2D

const TILE_SIZE := 46

## Multi-line map string. Rows are lines, columns are characters.
## '#' = wall (solid), '.' = floor, 'W' = window (solid), ' ' = empty (no tile).
@export_multiline var layout: String = ""
@export var floor_texture: Texture2D
@export var wall_texture: Texture2D
@export var window_texture: Texture2D

## Shrinks the rendered tile art relative to its native 46px size, without
## touching the character's scale. The source tile/furniture sheets were
## drawn at a noticeably bigger scale than the player sprite.
@export var tile_scale: float = 1.0


func _ready() -> void:
	_build()


func _build() -> void:
	var cell := TILE_SIZE * tile_scale
	var lines := layout.split("\n")
	for row_index in lines.size():
		var line := lines[row_index]
		for col_index in line.length():
			var ch := line[col_index]
			var pos := Vector2(col_index * cell, row_index * cell)
			match ch:
				"#":
					_add_tile(pos, cell, wall_texture, true)
				".":
					_add_tile(pos, cell, floor_texture, false)
				"W":
					_add_tile(pos, cell, window_texture, true)


func _add_tile(pos: Vector2, cell: float, texture: Texture2D, solid: bool) -> void:
	if texture == null:
		return
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = pos
	sprite.scale = Vector2(tile_scale, tile_scale)
	add_child(sprite)

	if solid:
		var body := StaticBody2D.new()
		body.position = pos
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = Vector2(cell, cell)
		shape.position = Vector2(cell / 2.0, cell / 2.0)
		shape.shape = rect
		body.add_child(shape)
		add_child(body)
