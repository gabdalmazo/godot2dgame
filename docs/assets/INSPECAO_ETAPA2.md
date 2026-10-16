# Inspeção visual e técnica — etapa 2

Todos os 18 originais foram abertos para leitura. Inspeção visual: mapa e mapa anotado em resolução original; demais imagens em prancha de contato. Contagem completa de pixels em `pixel_audit.json`, reproduzível por `python tools/audit_assets.py`.

**Nenhum arquivo contém transparência efetiva:** zero pixels com alfa menor que 255 em todos os originais, inclusive os PNGs que tinham canal alfa. O quadriculado é parte dos pixels. Não foi feito recorte automático, remoção de fundo ou regeneração. Isso evita apagar neve, olhos, brilhos ou partes do personagem junto com o fundo.

## Spritesheets

São visíveis seis poses em disposição aproximada 3×2 nas sete folhas. Isso não comprova grade regular, continuidade de ciclo ou pivôs consistentes. Nenhuma folha foi liberada para uso em SpriteFrames.

| Original | Resolução | Grade planejada | Conteúdo observado | Estado |
|---|---|---|---|---|
| mob_gremlin_walk_e.jpg | 2400×1792 | 800×896 por célula seria aritmeticamente possível | Gremlin de frente/3/4 voltado à direita; seis poses | Fundo incorporado, alinhamento fino e pivôs não aprovados |
| mob_gremlin_walk_n.jpg | 2048×2048 | Largura não divisível por 3 | Gremlin de frente/3/4, semelhante à direção leste; não é norte/de costas | Direção incorreta, grade e alfa pendentes |
| mob_gremlin_walk_s.jpg | 2048×2048 | Largura não divisível por 3 | Gremlin visto de costas com mochila; não é sul/frente | Direção incorreta, grade e alfa pendentes |
| mob_gremlin_walk_w.jpg | 2048×2048 | Largura não divisível por 3 | Contém **golem**, de frente/3/4 à direita | Personagem incorreto; não usar como gremlin |
| mob_golem_walk_n.jpg | 2400×1792 | 800×896 por célula seria possível | Golem de frente/3/4; não norte/de costas | Direção, fundo e pivôs pendentes |
| mob_golem_walk_s.jpg | 2400×1792 | 800×896 por célula seria possível | Golem de costas; não sul/frente | Direção, fundo e pivôs pendentes |
| mob_golem_walk_w.jpg | 1024×765 | Dimensões não divisíveis por 3×2 | Golem de frente/3/4 voltado à direita | Direção oeste não confirmada; fundo e grade pendentes |
| mob_golem_walk_e | Ausente | — | Não encontrado | Espelhamento futuro de oeste preparado, condicionado a oeste aprovado |

Os pivôs finais dependem do recorte correto: usar os pés como origem comum, sem oscilar entre quadros. Não foi inventado um pivô para folhas rejeitadas.

## Demais imagens

- `mapa.png`: apropriado como fundo opaco. Copiado byte a byte para `res://assets/maps/aurora_valley/aurora_valley.png`.
- `mapa_rotas.png`: referência de engenharia, mantida fora de `res://`; jamais carregada pela cena.
- `torre1/2/3.png`, `mostro1/2.png`: silhuetas identificáveis e úteis como referência, mas fundos quadriculados incorporados. Não usados como recortes no gameplay.
- `projetos_particulas.jpg`: flecha, cristal, orbe, explosões e neve visíveis; fundo incorporado. Ataques recriados como formas nativas simples.
- `element_visuais.jpg`: coração, moeda, bandeira, botões e molduras; atlas opaco sem regiões aprovadas. HUD usa Controls nativos.
- `Decorações_avulsas.jpg`: árvore, rocha, cristais, lampião e outros elementos sobre quadriculado. Não importado nesta versão.
- `texturas.png`: prancha de direção artística com texto e amostras, não textura repetível pronta. Preservada como referência.

## Mapa, rota e bases

O mundo inteiro usa coordenadas do original 1024×572, com pai World em `(0, 2.5)` e escala uniforme `(1.25, 1.25)`. Resultado 1280×715 dentro do viewport 1280×720, sem deformação.

A curva segue a linha vermelha superior da referência e termina no acesso à edificação. A estrada inferior desenhada no mapa permanece visual, sem segunda rota de gameplay. A representação de engenharia em `route_validation.png` foi gerada a partir dos pontos reais da cena; não é screenshot do Godot.

| Base | Centro no mapa | Decisão |
|---|---|---|
| 1 | (165, 301) | Plataforma circular válida |
| 2 | (311, 286) | Plataforma circular válida |
| 3 | — | Rejeitada: rochas, sem espaço livre |
| 4 | (357, 190) | Plataforma circular válida |
| 5 | (536, 229) | Plataforma circular válida |
| 6 | (550, 357) | Plataforma válida; alcances ajustados para atingir a rota superior |
| 7 | (766, 267) | Plataforma circular válida |
| 8 | (735, 371) | Plataforma circular válida |

## Substituição dos placeholders

`TDEnemyData.walk_frames` aceita SpriteFrames com `walk_n`, `walk_s`, `walk_e`, `walk_w`. Para o golem, `mirror_east_from_west = true` permite `walk_w` espelhada em leste quando houver folha oeste válida. Hoje nenhum SpriteFrames foi atribuído: os dois inimigos usam animação procedural, cores e marcadores direcionais, com origem nos pés.

Torres recebem `texture`, `texture_scale` e `texture_offset` em seus recursos. Enquanto nulos, desenham silhuetas distintas por `_draw`. Projéteis e impactos são formas nativas. Pastas de imagens ainda sem arte aprovada não foram criadas vazias.

Origem informada pelo usuário: produção por IA/Nano Banana 2. Uso autorizado neste protótipo; comprovação de condições de distribuição comercial não foi examinada nesta tarefa.
