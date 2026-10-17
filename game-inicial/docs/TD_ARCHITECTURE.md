# Arquitetura atual — tower defense, Etapa 4

Fonte de verdade do estado e resultados: `../../docs/STATUS.md`, `../../docs/reports/INDEX.md`. Roteiro: `../../docs/TESTE_MANUAL.md`.

## Cena e coordenadas

`scenes/world/aurora_level_extended.tscn` é a entrada de F5 na Etapa 6; `aurora_level.tscn` preserva a fase original para F6. `World` agrupa mapa, Path2D, pads, torres e projéteis, em pixels do mapa 1024×572. Escala uniforme 1,25 e deslocamento Y=2,5; CanvasLayer separado mantém HUD em 1280×720. Filtro linear, câmera fixa pela transformação do mundo, sem física de personagem ou navegação.

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

## Polimento da Etapa 4

`enemy.gd` conserva a progressão PathFollow2D e aplica a caminhada apenas ao filho `StaticArtwork`: seno lateral, vertical simétrico de baixa amplitude, pequena deformação e inclinação pela direção de deslocamento. `TDEnemyData` exporta frequência, amplitude, oscilação lateral, deformação e inclinação. Gremlin 9 rad/s e bob 0,35 px; golem 6 rad/s e bob 0,18 px. A sombra, as barras e a posição física usam a raiz, portanto não saltam junto com a textura.

`game_hud.tscn` permanece Control no CanvasLayer. A Etapa 5 troca a pele da HUD por placas separadas de madeira/bronze/neve, estandarte azul, painel contextual e três cartões ilustrados com texturas carregadas dos Resources de torre. Quatro SVGs vetoriais autorais servem de ícones. O rodapé reúne estado, Sino com ProgressBar de recarga, iniciar onda e reiniciar. Toast, sobreposições e sinais existentes continuam em `game_hud.gd`; o nó raiz ignora mouse, permitindo selecionar bases fora dos painéis. StyleBoxFlat e containers controlam a composição; a referência opaca `img/hud_nova.jpg` não é carregada no gameplay.

`scripts/audio/aurora_audio.gd` é instanciado no nó `Audio` da fase com processamento Always, pois pausas/menus também emitem sons. Carrega 13 WAVs de `assets/audio/prototype/` uma vez, distribui eventos por oito AudioStreamPlayers e limita disparos/impactos muito frequentes. Chamadas de áudio são opcionais para a regra de gameplay. A cena estendida atribui `assets/audio/music/aurora_fantasy_loop.wav`: loop nativo no AudioStreamWAV, callback `finished` como fallback, ganho de música/SFX separado e `stream_paused` na pausa. Receitas: `../../tools/generate_proto_audio.py` e `../../tools/generate_aurora_music.py`.

O nível mantém o estado e a recarga da habilidade. `bell_requested` só ativa em WAVE_ACTIVE com inimigos presentes e recarga zerada; aplica `apply_slow(0,55, 3 s)` aos inimigos ativos, sem dano. A mesma regra de lentidão de gelo evita multiplicação; o maior prazo restante prevalece. O cooldown de 24 s corre em preparação/onda/intervalo, para durante PAUSED e termina no encerramento. `World/BellPulse`, em (915,205) no mapa, desenha o anel por 0,85 s e pausa com o mundo. O efeito mecânico é imediato, independente do anel, evitando atraso de feedback e condições de corrida.

O validador geral verifica a estrutura; `tools/validate_stage4.py` compara Resources, rota, mapa e ondas com o commit anterior à etapa, além da reprodução byte a byte dos WAVs; `tools/validate_stage5.py` verifica caminhos de nós, sinais, texturas, SVGs e botões da nova HUD. São verificações estáticas, sem parser ou execução do Godot. O contrato visual da Etapa 3 permanece histórico porque a alteração de HUD/caminhada é intencional.

## Expansão da Etapa 6

`aurora_level_extended.tscn` é derivada da cena original por `../../tools/build_extended_level.py` e usa a mesma imagem do mapa. A curva segue o ramo inferior pintado (1.193,76 px contra 1.132,17 px), a base 9 ocupa a ilha central e sete Resources ficam em `data/extended/waves/`. O projeto aponta F5 para a nova cena; a original permanece intacta. `TDWaveData` traz multiplicadores de vida/velocidade com padrão 1,0 e `boss_scene` opcional; `AuroraWaveManager` intercala apoio e acrescenta o boss ao fim. O nível aplica os multiplicadores por inimigo antes de `add_child`, sem mutar os Resources compartilhados.

`TDEnemyData` recebe `is_boss`, `damage_reduction` e `slow_resistance_floor`; defaults preservam gremlin/golem. O Regente da Geada usa cena e Resource próprios, fallback desenhado em `_draw` e escapa por cinco vidas. A condição de conclusão continua `not waves.spawning and _living.is_empty()`, então boss não pode ser ignorado.

`TDTowerData.next_level` forma uma cadeia finita 1→2→3. Cada Resource de nível contém os atributos completos e o custo da transição. `AuroraTower.upgrade_to` valida o próximo Resource, atualiza o desenho e mantém um único script de ataque; o nível verifica saldo/estado/base e debita uma vez. O painel contextual de torre ocupada mostra atributos, upgrade disponível ou nível máximo. Os PNGs atuais são reutilizados até chegarem seis sprites transparentes de evolução.

`World/FinalBase` na cena estendida desenha cinco estados de brilho/rachaduras sobre o edifício incorporado ao mapa. `level.gd` chama `update_integrity` ao iniciar e após escape; a HUD expõe a condição no tooltip do status. Sem novo bitmap, não há troca física do edifício pintado.

`tools/validate_stage6.py` mede a curva e compara a fase original, confere ondas, boss, upgrade, base, música e ligações. Não executa parser/importação Godot nem simula equilíbrio real.

## Limites de validação

Etapa 2 validada manualmente pelo usuário, conforme relato no pedido. Etapas 3–6 sem Godot executado pelo Codex, conforme orientação do usuário; o usuário confirmou runtime da Etapa 3. Verificações estáticas não substituem importação, parser GDScript, layout real, input, mixagem ou testes de ponta a ponta. Sem addons, save, venda ou build comercial.

## Referências de API consultadas
- [CollisionObject2D / _input_event e input_pickable](https://docs.godotengine.org/en/4.4/classes/class_collisionobject2d.html)
- [PathFollow2D / progress, loop e rotates](https://docs.godotengine.org/en/4.4/classes/class_pathfollow2d.html)
- [AudioStreamPlayer / stream_paused e finished](https://docs.godotengine.org/en/4.4/classes/class_audiostreamplayer.html)
- [AudioStreamWAV / loop_mode e loop_end](https://docs.godotengine.org/en/4.5/classes/class_audiostreamwav.html)
- [GDScript / Resources exportados](https://docs.godotengine.org/en/4.4/tutorials/scripting/gdscript/gdscript_exports.html)
