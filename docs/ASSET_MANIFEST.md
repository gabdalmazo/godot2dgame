# Manifesto de assets — etapa 3

Atualizado em 2026-10-15. Originais em img/ preservados. res:// corresponde a game-inicial/. Origem informada pelo usuário: IA/Nano Banana 2, autorizada para este protótipo; condições comerciais não verificadas.

Todos os 18 originais têm 100% dos pixels opacos, medidos por Pillow. Canal alfa presente não significou transparência útil. Detalhes, direções e pivôs em [inspeção visual](assets/INSPECAO_ETAPA2.md) e [contagem de pixels](assets/pixel_audit.json).

| Original | Destino res:// / finalidade | Dimensões / formato | Frames e transparência | Estado |
|---|---|---|---|---|
| img/Decorações_avulsas.jpg | — referência externa; não carregada | 1024×765 / JPEG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
| img/element_visuais.jpg | — referência externa; não carregada | 1024×765 / JPEG | Imagem estática; opaca | Original opaco preservado; consultar derivadas abaixo |
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
| res://scenes/ui/game_hud.tscn | Controls/tema nativo | HUD provisório, sem fontes/ícones externos |

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
