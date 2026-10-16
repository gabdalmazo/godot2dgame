# Arquitetura atual — protótipo tower defense

Fonte de verdade do estado e resultados: `../../docs/STATUS.md`, `../../docs/reports/INDEX.md`. Roteiro: `../../docs/TESTE_MANUAL.md`.

## Cena e coordenadas

`scenes/world/aurora_level.tscn` é a entrada. `World` agrupa mapa, Path2D, pads, torres e projéteis, em pixels do mapa 1024×572. Escala uniforme 1,25 e deslocamento Y=2,5; CanvasLayer separado mantém HUD em 1280×720. Filtro linear, câmera fixa pela transformação do mundo, sem física de personagem ou navegação.

A Curve2D tem 27 pontos e tangentes suaves definidos na cena, editáveis no Inspector. Comprimento aproximado de 1.132,17 px por amostragem estática; o bake do Godot pode variar ligeiramente. Travessia sem lentidão: gremlin ~23,59 s, golem ~42,89 s.

## Dados e cenas reutilizáveis

- `scripts/data/enemy_data.gd` / `data/enemies/*.tres`: vida, velocidade, recompensa, dano de escape, visual e SpriteFrames opcional.
- `scripts/data/tower_data.gd` / `data/towers/*.tres`: preço, dano, alcance, intervalo, velocidade/tipo de projétil, lentidão/área e textura opcional.
- `scripts/data/wave_data.gd` / `data/waves/*.tres`: cenas de inimigo, contagens e intervalo. Referências e tamanhos de arrays verificados estaticamente.
- `scenes/enemies/gremlin.tscn` e `golem.tscn` usam o mesmo `enemy.gd`, baseado em PathFollow2D, sem duplicar movimento.
- `tower.tscn`, `tower_pad.tscn` e `projectile.tscn` são instanciáveis. Recursos de torres definem seus três comportamentos.
- `game_hud.tscn` possui Controls editáveis; script de HUD cuida de texto/estilo/sinais, sem alterar economia.

## Responsabilidade e eventos

`level.gd` centraliza moedas, vidas, ocupação, registro de inimigos e estado de partida. HUD emite pedidos; pads emitem seleção; torres emitem disparos. O nível cria projéteis e aceita transações somente nos estados permitidos.

`wave_manager.gd` mantém a fila de spawn, intercalando as espécies configuradas. Não cria timers assíncronos nem corrotinas que sobrevivam ao reinício. Emite `spawn_requested` e `spawning_finished`; o nível só termina a onda se a fila acabou e o registro de inimigos está vazio.

`enemy.gd` emite `resolved(enemy, killed)` uma única vez, com guarda antes do sinal. Morte concede recompensa; escape reduz vida. Sai do grupo `enemies` antes de emitir o sinal, evitando seleção por outra torre. `queue_free` fica após a resolução.

As torres escolhem o inimigo de maior progresso dentro do alcance. Varredura limitada a 10 Hz sem alvo e à cadência durante combate; aceitável para sete torres e até 21 inimigos por onda. Sem infraestrutura espacial prematura.

Projétil guiado valida o alvo a cada frame e expira se o alvo morrer/escapar. Não busca um alvo substituto. Área aplica um dano a cada inimigo elegível, sem dano direto adicional. A lentidão mantém o menor multiplicador e renova duração máxima; não se multiplica.

## Pausa e estados

Estados: PREPARING → WAVE_ACTIVE → INTERMISSION → ... → VICTORY, ou DEFEAT quando vidas chegam a zero. PAUSED guarda o estado anterior.

A raiz e HUD processam sempre. `World` e `Waves` usam PROCESS_MODE_PAUSABLE explícito, impedindo que herdem processamento contínuo da raiz. Pausa/resultado congelam SceneTree; UI ainda permite retomar/reiniciar. Reinício despausa antes de `reload_current_scene`.

## Balanceamento inicial

170 moedas e 15 vidas. Custos 55/75/100. Gremlin 35 HP, 48 px/s, 8 moedas; golem 120 HP, 26,4 px/s, 20 moedas; cada escape tira uma vida.

| Torre | Dano | Alcance (px mapa) | Intervalo | Efeito |
|---|---:|---:|---:|---|
| Sentinela | 12 | 180 | 0,65 s | Flecha |
| Lança-Geada | 8 | 195 | 1,1 s | Velocidade ×0,55 por 2 s |
| Farol Arcano | 26 | 210 | 1,5 s | Raio 48 |

Ondas: 6G; 8G+2B; 10G+3B; 12G+5B; 15G+6B, intervalos 1,4/1,3/1,15/1,05/0,95 s. A base 6 exigiu alcance maior devido à rota superior. Valores preservados na etapa 3. O usuário confirmou o loop jogável da etapa 2; não foi feita nova medição de dificuldade nesta integração visual.

## Arte — etapa 3

Mapa original preservado. Nove PNGs derivados em `assets/processed/` substituem torres, monstros, projéteis e impacto arcano. Configuração visual nos Resources: texturas opcionais por caminho, escala/offset das torres, pivô em pixels do PNG dos inimigos, altura/largura da barra, bob e balanço. Não há nova física ou alteração de raio de combate.

`scripts/visuals/visual_assets.gd` verifica e carrega Texture2D, compartilhando cache de sucesso/falha entre instâncias. Caminhos opcionais evitam ExtResources rígidos para a arte. Na ausência da imagem, o desenho nativo permanece; reexecutar F5 após corrigir uma falha para renovar o cache. Exportações futuras com seleção de recursos precisam incluir `assets/processed/` explicitamente.

Inimigos escolhem SpriteFrames válidos quando `prefer_walk_frames` está ligado, ou quando falta textura estática. Fora disso, usam StaticArtwork ancorado nos pés. Só o filho visual recebe escala com flip, bob e rotação; raiz PathFollow2D e regras de combate não mudam. Nenhum SpriteFrames foi atribuído; folhas com direção/grade/alfa inconsistentes continuam fora do runtime. O suporte `walk_n/s/e/w` e espelhamento de leste a partir de oeste permanece disponível para material futuro aprovado.

Torres/inimigos usam Z absoluto calculado por `10 + clamp(round(y), 0, 2000)` no espaço comum do mapa. Pais Towers/EnemyPath não têm transformações locais. Projéteis e impactos ficam em 3000, rota debug em 3500; HUD no CanvasLayer 10. O ponto de disparo e a mira anteriores foram mantidos. Impactos de flecha/gelo ainda são procedurais.

Prompts, proveniência, dimensões, pivôs e limites: `../../docs/assets/INSPECAO_ETAPA3.md`. As composições de inspeção foram geradas fora de res://; não são screenshots de runtime.

## Limites de validação

Etapa 2 validada manualmente pelo usuário, conforme relato no pedido. Etapa 3 sem Godot executado pelo Codex, conforme orientação do usuário. Verificações estáticas não substituem importação, parser GDScript, layout real, input ou testes de ponta a ponta. Sem addons, áudio, save, upgrades, venda ou build comercial.

## Referências de API consultadas
- [CollisionObject2D / _input_event e input_pickable](https://docs.godotengine.org/en/4.4/classes/class_collisionobject2d.html)
- [PathFollow2D / progress, loop e rotates](https://docs.godotengine.org/en/4.4/classes/class_pathfollow2d.html)
