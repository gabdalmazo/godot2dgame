class_name TDTowerData
extends Resource

enum AttackKind { ARROW, ICE, ARCANE }

@export var display_name: String = "Torre"
@export_multiline var description: String = ""
@export var cost: int = 55
@export var damage: float = 12.0
@export var attack_range: float = 180.0
@export var attack_interval: float = 0.65
@export var projectile_speed: float = 340.0
@export var attack_kind: AttackKind = AttackKind.ARROW
@export var slow_multiplier: float = 1.0
@export var slow_duration: float = 0.0
@export var splash_radius: float = 0.0
@export var tint: Color = Color("e9bf6a")
@export_range(1, 3, 1) var level: int = 1
@export var next_level: TDTowerData
@export var texture: Texture2D
@export var texture_scale: Vector2 = Vector2.ONE
@export var texture_offset: Vector2 = Vector2(0, -28)

@export_group("Optional visual assets")
@export_file("*.png") var texture_path: String = ""
@export_file("*.png") var projectile_texture_path: String = ""
@export var projectile_texture_scale: float = 1.0
@export var projectile_texture_rotation_degrees: float = 0.0
@export_file("*.png") var impact_texture_path: String = ""
