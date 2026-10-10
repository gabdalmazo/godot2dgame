TOCA DA TIGRA — PROTÓTIPO 2D

PROJETO ATIVO

Abra este project.godot, dentro de game-inicial/. O project.godot da pasta pai
é o protótipo 3D legado. A direção FPS foi cancelada; não executar sua cena
player.tscn para testar o jogo atual.

REQUISITOS E EXECUÇÃO

Godot 4.4+ padrão, GDScript. Validado no Godot 4.4.1 nesta máquina.
1. Pare qualquer execução com F8 e reabra este projeto no editor se já estava
   aberto durante as alterações de project.godot.
2. Pressione F5. A Main Scene é scenes/world/prototype_2d.tscn.
3. Alternativa: abra essa cena de mundo e use F6. Não execute player_2d.tscn
   isoladamente: ela não contém chão.
4. A/D ou setas movem. Espaço pula. O mouse fica livre. Esc não pausa o 2D.
5. Pare a execução pelo editor com F8.

PLAYER NO EDITOR

Player (CharacterBody2D) — scripts/player/platformer_player.gd
  Visuals (Node2D)
    Sprite2D — assets/placeholders/player.svg
  CollisionShape2D — RectangleShape2D
  Camera2D

A cena scenes/player/player_2d.tscn já está montada:
- Origem do Player nos pés; escala (1, 1), rotação zero.
- Colisor retangular de 24 × 40 px em (0, -20).
- Sprite em (0, -20), mesma dimensão, filtro nearest. O olho e braço indicam
  direção. A inversão altera somente flip_h, sem espelhar corpo ou câmera.
- Inspector > References > Sprite aponta para Visuals/Sprite2D.
- Layer 2 (Player), Mask 1 (World). O cenário colide na layer 1.
- Motion Mode Grounded, Up Direction (0, -1).
- Camera2D habilitada, posição (0, -70), callback Physics; segue sem suavização.
- Para reutilizar, instancie o Player acima de um piso com StaticBody2D e colisor.

INSPECTOR

move_speed         220 px/s
acceleration       1800 px/s²
deceleration       2200 px/s²
jump_velocity      -480 px/s (negativo sobe)
gravity_multiplier 1.2
sprite             Visuals/Sprite2D

Gravidade base: Project Settings > Physics > 2D > Default Gravity = 980.
Mude os valores, salve a cena e execute novamente. A aceleração e o controle
horizontal também se aplicam no ar. O pulo tem altura fixa e requer novo toque
no chão; segurar Espaço não produz saltos repetidos.

CENA DE TESTE

Prototype2D (Node2D)
  Geometry (Node2D)
    LeftFloor / LowerFloor / RightFloor
    Step / FirstPlatform / HighPlatform / ReturnPlatform / Obstacle
    LeftWall / RightWall
  Player (instância)
  DebugHUD (CanvasLayer)
    Controls (Label)

Cada sólido possui StaticBody2D, Polygon2D e CollisionPolygon2D coincidentes.
O chão principal fica em Y=500, o desnível em Y=540. Degrau de 32 px, plataformas
em Y=420 e Y=340 (subidas de 80 px), obstáculo de 48 px. A sala possui paredes
nas extremidades e piso contínuo para evitar queda infinita sem criar respawn.

INPUT MAP

Ativas no 2D: move_left (A/←), move_right (D/→), jump (Espaço).
Preservadas para legado: move_forward (W), move_backward (S), sprint (Shift),
pause (Esc). Essas quatro ações não fazem nada no novo controlador.
Ações de combate, inventário e habilidades ainda não foram criadas.

TESTE MANUAL

1. Inicie com F5. Verifique título PROTÓTIPO 2D, personagem e geometria.
2. Ande para ambos os lados com A/D e depois com setas; confira aceleração,
   frenagem e orientação. Soltar a direção mantém o sprite virado para aquele lado.
3. Aperte Espaço no chão. Solte e aperte no ar: não deve haver segundo pulo.
   Segure Espaço até pousar: não deve saltar automaticamente outra vez.
4. Ande contra o degrau laranja: ele bloqueia. Pule para subir/saltar sobre ele.
5. Aproxime-se pela esquerda da primeira plataforma verde e pule lateralmente
   para pousar nela. Pule dela para a plataforma ocre mais alta à direita.
   Plataformas são sólidas: pular diretamente por baixo bate na parte inferior.
6. Saia da plataforma alta para a direita: deve cair no piso rebaixado.
   Pule para vencer o ressalto de retorno ao chão mais alto.
7. Avance pelo restante da sala e teste o obstáculo e as paredes laterais.
8. Observe a Camera2D seguindo o Player. HUD deve continuar fixo na tela.
9. Verifique Output/Debugger: não deve haver erros da implementação 2D.

TESTES AUTOMATIZADOS

A partir desta pasta, substitua godot pelo executável disponível:

godot --headless --path . --editor --import --quit
godot --headless --path . --script res://tests/platformer_player_test.gd
godot --headless --path . --quit-after 120

Resultado validado: 29 verificações aprovadas, zero falhas, no Godot 4.4.1.
Inicialização por 120 frames sem erros; renderização real em Compatibility
conferida em duas capturas (spawn e plataforma elevada).
O teste usa a física real da Main Scene e retorna código 1 em caso de falha.
Isso não substitui a avaliação manual de sensação e teclas físicas.

LEGADO E LIMITAÇÕES

Cenas player.tscn e controller_test.tscn, script first_person_player.gd e teste
player_controller_test.gd pertencem ao FPS antigo. Foram preservados sem
alterações; não são carregados pela nova Main Scene. Não os use no gameplay 2D.
Inventário completo e dependências: docs/ARCHITECTURE.md.

Sem arte final, animações, combate, inimigos, inventário, save, menu de pausa,
limites de câmera ou transições. A câmera pode mostrar regiões vazias fora da
sala. Sem coyote time, jump buffer, pulo variável, dash, double jump ou wall jump.

DOCUMENTAÇÃO VIVA

AGENTS.md                 — regras, visão, arquitetura e estado para agentes.
docs/PROJECT_STATUS.md    — estado atual e validação.
docs/CHANGELOG_DEV.md     — mudanças realizadas.
docs/ARCHITECTURE.md      — sistemas, relações e inventário legado.
docs/DECISIONS.md         — decisões e motivos, incluindo migração 3D → 2D.
docs/TODO.md              — NOW / NEXT / LATER.

Próximo passo: validar a sensação de movimento; somente depois de solicitação,
avaliar coyote time, jump buffer, pulo variável e animações. Não iniciar combate.
