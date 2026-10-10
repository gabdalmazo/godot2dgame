# Arquitetura

## Auditoria anterior à migração

Foram encontrados dois projetos: o original na pasta pai e a cópia ativa
`game-inicial/`, identificada pelo projeto aberto pelo usuário. Ambos tinham
somente o protótipo FPS; não havia sistemas 2D, autoloads ou recursos de itens.
Pastas de templates/perfis/temas estavam vazias e não são sistemas do jogo.

A Main Scene ativa era `scenes/world/controller_test.tscn` (Node3D). Ela
instanciava `scenes/player/player.tscn` (CharacterBody3D), ligado ao script
`scripts/player/first_person_player.gd`, classe FirstPersonPlayer. O teste
`tests/player_controller_test.gd` carregava diretamente o mundo 3D.

Input Map anterior: move_forward, move_backward, move_left, move_right, sprint,
pause. Configuração ativa anterior: Forward+, D3D12 no Windows, Jolt para 3D.
O projeto da pasta pai usava Compatibility. O ícone existente foi preservado.

Reaproveitamento: organização scenes/scripts/tests, ações esquerda/direita,
convenções de nomes e padrão de testes sem framework. Não reutilizamos o código
físico 3D nem adaptamos sua classe para 2D.

## Fluxo ativo

```text
project.godot
  -> scenes/world/prototype_2d.tscn (Node2D)
       -> Geometry (Node2D)
            -> StaticBody2D + Polygon2D + CollisionPolygon2D
       -> Player (instância de player_2d.tscn)
       -> DebugHUD (CanvasLayer -> Label)

Player (CharacterBody2D, platformer_player.gd)
  -> Visuals (Node2D)
       -> Sprite2D (player.svg)
  -> CollisionShape2D (RectangleShape2D, 24 × 40)
  -> Camera2D
```

Nenhuma dependência de cena, script ou nó 3D é carregada pela nova Main Scene.

## Jogador e física

Origem do Player nos pés; sprite e colisor centralizados em (0, -20).
Layer 2 = Player; mask 1 = World. Geometria usa layer 1. Gravidade positiva em Y,
eixo vertical da Godot 2D. O corpo não é escalado/espelhado: somente sprite.flip_h.

O Inspector expõe move_speed=220 px/s, acceleration=1800 px/s²,
deceleration=2200 px/s², jump_velocity=-480 px/s, gravity_multiplier=1.2 e
referência sprite. A gravidade do projeto é 980 px/s².

Cada tick físico lê o eixo horizontal, aproxima velocity.x da velocidade alvo,
aplica gravidade, aceita novo pulo somente no chão, chama move_and_slide() e
atualiza orientação visual. Nenhuma busca de árvore ou alocação de recursos por
tick. Sprite ausente ou Input Action ausente gera erro e desativa a física.

A câmera filha segue a posição do jogador com offset local (0, -70), atualizada
em física, sem suavização, limites ou lógica própria. Nada impede usar depois
as propriedades nativas de Camera2D ou um componente dedicado quando solicitado.

## Sala e alcance

Sala fechada lateralmente, largura 2200 px. Piso em Y=500, trecho rebaixado em
Y=540. Degrau de 32 px, obstáculo de 48 px. Plataforma inicial em Y=420 e elevada
em Y=340; cada subida é de 80 px, dentro do pulo atual (~94 px discretizado).
Plataformas são sólidas também por baixo e pelos lados; aproxime o salto pela
lateral. HUD permanece fixo na tela, separado da câmera do mundo.

## Testes

`tests/platformer_player_test.gd` instancia a Main Scene real, injeta Input
Actions e avança ticks de física. Verifica 29 condições de comportamento,
incluindo alcance real das duas primeiras plataformas, colisão por baixo,
ausência de salto aéreo/repetição por botão segurado e ausência de nós 3D.
Reposicionamento direto aparece somente no setup dos testes.

## Inventário de legado e dependências

| Arquivo preservado | Dependência |
| --- | --- |
| scenes/world/controller_test.tscn | scenes/player/player.tscn |
| scenes/player/player.tscn | scripts/player/first_person_player.gd |
| scripts/player/first_person_player.gd e .uid | CharacterBody3D e ações FPS |
| tests/player_controller_test.gd e .uid | mundo 3D e classe FirstPersonPlayer |

A mesma cadeia existe na pasta pai, com seu project.godot antigo. Os arquivos
não foram movidos para evitar quebrar os caminhos res:// do protótipo antigo.
Nenhum deles é usado pelo novo Player 2D. Futuramente remover/arquivar a cadeia
inteira, junto às ações exclusivas do FPS, após confirmar que não será mais útil.
Não remover apenas o controlador, pois o mundo/teste legado ainda o referencia.

## Referências de API

- https://docs.godotengine.org/en/4.4/classes/class_characterbody2d.html
- https://docs.godotengine.org/en/4.4/classes/class_camera2d.html
