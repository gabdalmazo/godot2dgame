class_name AuroraVisualAssets
extends RefCounted
## Optional textures use paths so missing art cannot prevent loading gameplay Resources.

static var _cache: Dictionary = {}


static func load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if _cache.has(path):
		return _cache[path] as Texture2D
	var texture: Texture2D = null
	if ResourceLoader.exists(path, "Texture2D"):
		texture = ResourceLoader.load(path, "Texture2D") as Texture2D
	if texture == null:
		push_warning("Optional visual unavailable; using fallback: %s" % path)
	_cache[path] = texture
	return texture


static func depth_at(map_y: float) -> int:
	# Shared absolute canvas depth keeps feet-anchored actors ordered across parents.
	return 10 + clampi(roundi(map_y), 0, 2000)
