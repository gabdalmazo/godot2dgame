class_name Tower
extends Area2D

@export var attack_range: float = 150.0
@export var fire_rate: float = 1.0
@export var projectile_damage: float = 20.0
@export var is_upgraded: bool = false
@export var projectile_scene: PackedScene
@export var sprite: Sprite2D
@export var som_disparo: AudioStream = preload("res://assets/audio/sfx/laser.ogg")

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_target: Node2D = null
## Controla a cadência de tiro permitindo disparo imediato assim que um inimigo entra no alcance
var time_since_last_shot: float = 999.0

func _ready() -> void:
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
		
	if audio_player == null:
		audio_player = get_node_or_null("AudioStreamPlayer2D") as AudioStreamPlayer2D
	if audio_player == null:
		audio_player = AudioStreamPlayer2D.new()
		audio_player.name = "AudioStreamPlayer2D"
		add_child(audio_player)
		
	# Cria a colisão da Area2D para representação física e depuração
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = attack_range
	collision_shape.shape = circle_shape
	add_child(collision_shape)

func _physics_process(delta: float) -> void:
	time_since_last_shot += delta
	
	# Valida continuamente se o alvo atual ainda existe, está vivo e dentro do raio de alcance
	if not _is_target_valid(current_target):
		current_target = _find_best_target()
	
	# Se possui um alvo válido em alcance
	if current_target != null:
		atualizar_visual_mira(current_target.global_position)
		
		# Dispara assim que a recarga permitir
		if time_since_last_shot >= fire_rate:
			shoot()
			time_since_last_shot = 0.0

## Busca o inimigo prioritário dentro do raio da torre (aquele mais avançado no caminho)
func _find_best_target() -> Node2D:
	var best_target: Node2D = null
	var max_progress: float = -1.0
	var min_distance: float = INF
	
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	for node in enemies:
		if not (node is Node2D):
			continue
			
		var candidate: Node2D = node as Node2D
		if not _is_target_valid(candidate):
			continue
			
		# Identifica o progresso do inimigo ao longo do Path2D
		var progress: float = -1.0
		if candidate.get_parent() is PathFollow2D:
			progress = (candidate.get_parent() as PathFollow2D).progress
		elif candidate is PathFollow2D:
			progress = (candidate as PathFollow2D).progress
			
		# Prioridade 1: Inimigo mais próximo da base do jogador (maior progress no caminho)
		if progress > max_progress:
			max_progress = progress
			best_target = candidate
		elif progress == max_progress and progress < 0.0:
			# Prioridade 2 (caso não tenha PathFollow): Mais próximo da torre
			var dist: float = global_position.distance_to(candidate.global_position)
			if dist < min_distance:
				min_distance = dist
				best_target = candidate
				
	return best_target

## Checagem estrita de validade e distância euclidiana exata
func _is_target_valid(target: Node2D) -> bool:
	if target == null:
		return false
	if not is_instance_valid(target):
		return false
	if target.is_queued_for_deletion():
		return false
	if target.get_parent() != null and target.get_parent().is_queued_for_deletion():
		return false
		
	# Validação matemática precisa: descarta alvos fora do raio instantaneamente
	if global_position.distance_to(target.global_position) > attack_range:
		return false
		
	return true

## Rotação visual em 8 direções baseada no vetor do alvo
func atualizar_visual_mira(alvo_pos: Vector2) -> void:
	if sprite == null:
		return
		
	var direcao: Vector2 = alvo_pos - global_position
	if direcao == Vector2.ZERO:
		return
		
	var angulo_graus: float = wrapf(rad_to_deg(direcao.angle()), 0.0, 360.0)
	var frame_calculado: int = int(round(angulo_graus / 45.0)) % 8
	sprite.frame = frame_calculado

## Realiza o disparo do projétil na direção do alvo
func shoot() -> void:
	if projectile_scene == null:
		push_warning("Cena do projétil não configurada na torre!")
		return
		
	if not _is_target_valid(current_target):
		current_target = _find_best_target()
		if current_target == null:
			return
		
	var projectile = projectile_scene.instantiate() as Node2D
	
	# Injeta o dano calibrado da torre no projétil
	if "damage" in projectile:
		projectile.damage = projectile_damage
		
	# Feedback no projétil para torres aprimoradas
	if is_upgraded and "sprite" in projectile and projectile.sprite != null:
		projectile.sprite.modulate = Color(1.0, 0.85, 0.25, 1.0)
	
	projectile.global_position = global_position
	projectile.look_at(current_target.global_position)
	
	get_tree().current_scene.add_child(projectile)
	
	# Áudio posicional 2D com variação de pitch
	if som_disparo != null and audio_player != null:
		audio_player.stream = som_disparo
		audio_player.pitch_scale = randf_range(1.15, 1.35) if is_upgraded else randf_range(0.9, 1.1)
		audio_player.play()

## Aplica o aprimoramento da torre (nível único):
## 1. Define is_upgraded como true
## 2. Dobra o dano do projétil
## 3. Aumenta levemente a cadência de tiro (reduz o tempo de espera)
## 4. Altera o modulate do Sprite2D para tom dourado/neon
func aplicar_upgrade() -> void:
	if is_upgraded:
		return
		
	is_upgraded = true
	projectile_damage *= 2.0
	fire_rate = max(0.1, fire_rate * 0.75) # 25% mais rápida
	attack_range *= 1.1 # Pequeno bônus de alcance de 10%
	
	if sprite == null:
		sprite = get_node_or_null("Sprite2D")
		
	if sprite != null:
		sprite.modulate = Color(1.0, 0.85, 0.25, 1.0)
