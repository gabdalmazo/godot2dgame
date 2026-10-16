class_name TDEnemyData
extends Resource
## Distances and speeds use the original map's pixels (1024 x 572).

@export var display_name: String = "Inimigo"
@export var max_health: float = 35.0
@export var speed: float = 48.0
@export var reward: int = 8
@export var escape_damage: int = 1
@export var body_color: Color = Color("36b9c9")
@export var body_radius: float = 11.0
@export var is_golem: bool = false
@export var walk_frames: SpriteFrames
@export var sprite_scale: Vector2 = Vector2.ONE
@export var sprite_offset: Vector2 = Vector2(0, -16)
@export var mirror_east_from_west: bool = false

@export_group("Static visual")
@export var prefer_walk_frames: bool = false
@export_file("*.png") var static_texture_path: String = ""
@export var static_scale: float = 1.0
@export var static_pivot: Vector2 = Vector2.ZERO
@export var visual_height: float = 0.0
@export var health_bar_width: float = 36.0
@export var bob_amplitude: float = 1.0
@export var sway_degrees: float = 1.2
