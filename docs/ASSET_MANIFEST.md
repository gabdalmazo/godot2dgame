# Manifesto de assets — etapa 6

Atualizado em 2026-10-17. Originais em img/ preservados. res:// corresponde a game-inicial/. Origem das imagens informada pelo usuário: IA/Nano Banana 2, autorizada para este protótipo; condições comerciais não verificadas.

Todos os 19 originais, incluindo `hud_nova.jpg`, têm 100% dos pixels opacos, medidos por Pillow. Canal alfa presente não significou transparência útil. Detalhes, direções e pivôs dos originais anteriores em [inspeção visual](assets/INSPECAO_ETAPA2.md); [contagem de pixels atual](assets/pixel_audit.json).

| Original | Destino res:// / finalidade | Dimensões / formato | Frames e transparência | Estado |
|---|---|---|---|---|
| img/Decorações_avulsas.jpg | — referência externa; não carregada | 1024×765 / JPEG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/element_visuais.jpg | — referência externa; não carregada | 1024×765 / JPEG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/hud_nova.jpg | — referência visual externa; não carregada | 1024×572 / JPEG RGB | Imagem composta, 1 quadro; opaca | Mapa/textos fundidos; nenhum recorte aprovado para runtime; origem informada: Nano Banana 2 |
| img/mapa.png | res://assets/maps/aurora_valley/aurora_valley.png / cenário | 1024×572 / PNG | Imagem estática; opaca | Copiado sem alteração; pronto para importação automática no editor |
| img/mapa_rotas.png | — guia técnico externo | 1024×572 / PNG | Imagem estática; opaca | Usado para traçar Curve2D; não aparece no gameplay |
| img/mob_golem_walk_n.jpg | — referência externa; não carregada | 2400×1792 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Rejeitado para SpriteFrames: fundo/direção/grade não aprovados |
| img/mob_golem_walk_s.jpg | — referência externa; não carregada | 2400×1792 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Rejeitado para SpriteFrames: fundo/direção/grade não aprovados |
| img/mob_golem_walk_w.jpg | — referência externa; não carregada | 1024×765 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Rejeitado para SpriteFrames: fundo/direção/grade não aprovados |
| img/mob_gremlin_walk_e.jpg | — referência externa; não carregada | 2400×1792 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Rejeitado para SpriteFrames: fundo/direção/grade não aprovados |
| img/mob_gremlin_walk_n.jpg | — referência externa; não carregada | 2048×2048 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Rejeitado para SpriteFrames: fundo/direção/grade não aprovados |
| img/mob_gremlin_walk_s.jpg | — referência externa; não carregada | 2048×2048 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Rejeitado para SpriteFrames: fundo/direção/grade não aprovados |
| img/mob_gremlin_walk_w.jpg | — referência externa; não carregada | 2048×2048 / JPEG | 6 poses visíveis, 3×2 aproximado; opaca | Conteúdo incorreto: golem em arquivo do gremlin; não importar |
| img/mostro1.png | — referência externa; não carregada | 1024×1024 / PNG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/mostro2.png | — referência externa; não carregada | 1024×1024 / PNG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/projetos_particulas.jpg | — referência externa; não carregada | 1024×765 / JPEG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/texturas.png | — referência externa; não carregada | 765×1024 / PNG | Imagem estática; opaca | Prancha de referência artística; não é textura pronta |
| img/torre1.png | — referência externa; não carregada | 1024×1024 / PNG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/torre2.png | — referência externa; não carregada | 1024×1024 / PNG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/torre3.png | — referência externa; não carregada | 1024×1024 / PNG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |

| Recurso adicional | Tipo / dimensões | Estado / origem |
|---|---|---|
| res://icon.svg + .import | SVG 128×128 | Ícone herdado, preservado; origem não confirmada; provisório |
| res://assets/placeholders/player.svg + .import | SVG 24×40 | Placeholder original descrito no histórico; órfão preservado, não usado no TD |
| res://scripts/enemies/enemy.gd | Desenho procedural, raio 11/16 px; animação de passos/direção | Fallback dos dois monstros; visual principal agora é PNG estático procedural |
| res://scripts/towers/tower.gd | Desenho procedural de três silhuetas | Fallback de torre; texturas derivadas atribuídas nos Resources |
| res://scripts/projectiles/projectile.gd e impact.gd | Flecha, gelo, orbe e impactos procedurais | Fallback nativo; PNGs de projéteis e impacto arcano atribuídos |
| res://scenes/ui/game_hud.tscn | Controls/tema nativo | HUD Etapa 5 com quatro ícones vetoriais; referências aos PNGs de torres vêm dos Resources |

## Ornamentos de UI — Etapa 5

| Caminho res:// | Tipo, dimensões e transparência | Estado e origem |
|---|---|---|
| res://assets/ui/aurora/heart.svg | SVG 64×64, vetor com fundo transparente, 1 ícone | Coração da HUD; desenho novo em código, sem recorte de `hud_nova.jpg`; importação Godot a confirmar |
| res://assets/ui/aurora/coin.svg | SVG 64×64, vetor com fundo transparente, 1 ícone | Moeda da HUD; desenho novo em código; importação Godot a confirmar |
| res://assets/ui/aurora/gear.svg | SVG 64×64, vetor com fundo transparente, 1 ícone | Engrenagem de pausa; desenho novo em código; importação Godot a confirmar |
| res://assets/ui/aurora/bell.svg | SVG 64×64, vetor com fundo transparente, 1 ícone | Sino da habilidade; desenho novo em código; importação Godot a confirmar |

As três imagens exibidas nos cartões são `res://assets/processed/towers/archer.png`, `ice.png` e `arcane.png`, lidas do `texture_path` dos Resources de torre já integrados. Não há cópia adicional dos PNGs. A referência completa permanece fora de `res://`.

## Expansão — Etapa 6

| Asset/sistema | Caminho `res://` | Dimensões, frames, transparência, estado e origem |
|---|---|---|
| Boss Regente da Geada | `res://scenes/enemies/boss.tscn`, `res://data/enemies/boss.tres` | Silhueta procedural no `enemy.gd`, sem textura/spritesheet; placeholder autoral em código; asset definitivo RGBA pendente |
| Sentinela níveis 2 e 3 | `res://data/upgrades/archer_2.tres`, `archer_3.tres` | Reutiliza `res://assets/processed/towers/archer.png` 1254×1254 RGBA/1 frame com escala/cor/anéis; PNGs de nível 2/3 pendentes |
| Lança-Geada níveis 2 e 3 | `res://data/upgrades/ice_2.tres`, `ice_3.tres` | Reutiliza `res://assets/processed/towers/ice.png` 1254×1254 RGBA/1 frame com escala/cor/anéis; PNGs de nível 2/3 pendentes |
| Farol Arcano níveis 2 e 3 | `res://data/upgrades/arcane_2.tres`, `arcane_3.tres` | Reutiliza `res://assets/processed/towers/arcane.png` 1254×1254 RGBA/1 frame com escala/cor/anéis; PNGs de nível 2/3 pendentes |
| Base final degradável | `res://scripts/world/final_base.gd` sobre `res://assets/maps/aurora_valley/aurora_valley.png` | Cinco estados procedurais de brilho/rachaduras, sem novos bitmaps; construção pintada no mapa permanece; cinco variantes RGBA definitivas pendentes |
| Trilha de fantasia provisória | `res://assets/audio/music/aurora_fantasy_loop.wav` | WAV PCM mono 16-bit/22.050 Hz, 16 s, 1 loop; síntese original local por `tools/generate_aurora_music.py`, importação/reprodução no Godot pendente |
| Fase estendida | `res://scenes/world/aurora_level_extended.tscn` | Reutiliza o mapa opaco 1024×572, curva inferior e base 9; não cria um mapa novo nem altera pixels |

Para futura arte de upgrades, fornecer seis PNGs transparentes separados em `res://assets/processed/towers/upgrades/` (Sentinela 2/3, Geada 2/3, Arcano 2/3), cada um com pivô de base coerente. Alterar apenas `texture_path`, `texture_scale` e `texture_offset` no respectivo Resource após auditar alfa/dimensões. Para o boss, fornecer RGBA recortado sem fundo, pivô nos pés e altura maior que o golem. Para a base, fornecer variantes alinhadas do mesmo edifício sem mapa ao redor, ou um atlas de rachaduras compatível com a imagem existente. Nenhuma dessas artes foi marcada como importada.

Na etapa 3 foram adicionadas as nove derivadas abaixo; os originais permanecem intactos. Nenhum SpriteFrames de arte original foi criado/atribuído porque as folhas foram rejeitadas. Suporte preparado para walk_n/s/e/w e espelhamento futuro do golem a partir de oeste aprovado. Direção leste do golem continua ausente.

docs/assets/contact_sheet.png e route_validation.png são evidências de inspeção/engenharia fora do projeto, não assets de jogo nem capturas de runtime.

## Derivadas integradas — 2026-10-15

Origem de cada derivada: arte fornecida pelo usuário + edição pela ferramenta integrada image_gen em modo background-extraction; uso no protótipo conforme pedido. Não constituem segmentação pixel a pixel. Licença/origem dos originais permanece a informada acima. Todas têm **1254×1254, PNG RGBA, 1 frame, transparência real**, estado **atribuídas no projeto; importação/runtime a confirmar pelo usuário**.

| Tipo | Caminho res:// | Fonte |
|---|---|---|
| Torre Sentinela | res://assets/processed/towers/archer.png | img/torre1.png |
| Torre Lança-Geada | res://assets/processed/towers/ice.png | img/torre2.png |
| Torre Farol | res://assets/processed/towers/arcane.png | img/torre3.png |
| Monstro gremlin | res://assets/processed/enemies/gremlin.png | img/mostro1.png |
| Monstro golem | res://assets/processed/enemies/golem.png | img/mostro2.png |
| Projétil flecha | res://assets/processed/projectiles/arrow.png | img/projetos_particulas.jpg, superior esquerda |
| Projétil gelo | res://assets/processed/projectiles/ice_shard.png | Mesmo atlas, superior segunda coluna |
| Projétil orbe | res://assets/processed/projectiles/arcane_orb.png | Mesmo atlas, superior terceira coluna |
| Impacto arcano | res://assets/processed/effects/arcane_impact.png | Mesmo atlas, inferior segunda coluna |

Escalas, pivôs, direções e limites: [inspeção etapa 3](assets/INSPECAO_ETAPA3.md). Hashes/alfa: [auditoria](assets/etapa3_processed_audit.json). Prompts e mapeamento: `tools/visual_assets_recipe.json`. Instalação sem edição de pixels: `tools/install_visual_assets.py`. Pranchas etapa3_scene_preview/etapa3_alpha_review são evidências de engenharia fora de res://, não assets nem capturas de runtime.

Na retomada da Etapa 3, os hashes dos nove PNGs aprovados, seus pixels alfa, suas margens e as referências dos Resources foram verificados sem erros. Existem nove arquivos `.png.import` junto às derivadas. Depois dessa verificação, o usuário confirmou em seu Godot que os personagens corretos aparecem e que o jogo funciona; a nova Etapa 4 ainda não foi testada em runtime.

## Áudio provisório — Etapa 4

Todos os arquivos abaixo ficam em `res://assets/audio/prototype/`, foram sintetizados localmente por `tools/generate_proto_audio.py` sem fontes externas e estão disponíveis como WAV **PCM mono 16-bit, 22.050 Hz**. Estado: arquivos gerados e associados ao carregador; importação/reprodução no Godot a confirmar pelo usuário. Origem/licença: síntese original do projeto, sem material de terceiros. Durações arredondadas:

| Arquivo res://assets/audio/prototype/ | Duração | Uso |
|---|---:|---|
| `ui.wav` | 0,075 s | Botões da interface |
| `build.wav` | 0,30 s | Construção concluída |
| `wave.wav` | 0,60 s | Início de onda |
| `arrow.wav` | 0,12 s | Disparo da Sentinela |
| `ice.wav` | 0,22 s | Disparo da Lança-Geada |
| `arcane.wav` | 0,30 s | Disparo do Farol |
| `impact.wav` | 0,13 s | Acerto de projétil |
| `kill.wav` | 0,20 s | Inimigo derrotado |
| `escape.wav` | 0,42 s | Vida perdida por escape |
| `pause.wav` | 0,15 s | Pausa/retorno |
| `victory.wav` | 1,15 s | Vitória |
| `defeat.wav` | 0,90 s | Derrota |
| `bell.wav` | 0,90 s | Sino da Aurora |

Na Etapa 4 não havia música anexada; a trilha provisória da Etapa 6 está registrada acima. O campo `AuroraAudio.music_stream` permite trocá-la, e o gerador e `docs/validation/etapa4_static_checks.json` registram os parâmetros e a reprodução byte a byte dos SFX originais.
