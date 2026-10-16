# Integração visual — etapa 3, 2026-10-15

## Origem e tratamento

Os 18 originais de `img/` foram preservados. Foram revistos as cinco artes individuais, o atlas de efeitos e a prancha das sete caminhadas. Os arquivos originais continuam opacos, com quadriculado incorporado. Mapa e guia não foram alterados.

Nove cópias derivadas foram preparadas com a ferramenta integrada **image_gen**, modo `background-extraction`, usando cada original como referência e pedindo a preservação da silhueta, cores, neve e detalhes. Os prompts exatos e a relação origem/destino estão em `tools/visual_assets_recipe.json`. São edições generativas: há pequenas diferenças de traço, saturação e brilho; **não são segmentações pixel a pixel**. Nenhuma imagem original foi sobrescrita.

Os resultados aprovados foram copiados byte a byte por `tools/install_visual_assets.py`. Essa instalação é reproduzível; gerar novamente com o mesmo prompt não garante pixels idênticos. O script recusa sobrescrever um PNG diferente e reutiliza a cópia instalada se o resultado externo não existir. Todos os PNGs entregues estão dentro do projeto; nenhuma referência de runtime aponta para `.codex/generated_images`.

## Recortes e alfa

Todos os nove PNGs são RGBA **1254×1254**, com pixels transparentes, opacos e intermediários. Limites medidos com alfa ≥32; a margem transparente mantém as extremidades visíveis. Hashes, contagens de pixels e bounding boxes: [auditoria](etapa3_processed_audit.json).

| Derivada | Fonte | Uso e ajuste em pixels do mapa |
|---|---|---|
| towers/archer.png | torre1.png | Sentinela; altura visível ~90; escala 0,078193; offset (-0,078; -38,94) |
| towers/ice.png | torre2.png | Lança-Geada; altura ~90; escala 0,080863; offset (-0,243; -40,35) |
| towers/arcane.png | torre3.png | Farol; altura ~90; escala 0,081374; offset (0,163; -40,44) |
| enemies/gremlin.png | mostro1.png | Altura ~42; escala 0,040153; pivô do PNG (650; 1180) |
| enemies/golem.png | mostro2.png | Altura ~56; escala 0,047619; pivô (640; 1218) |
| projectiles/arrow.png | projetos_particulas.jpg, superior esquerda | Escala 0,024; rotação local +45° para apontar no eixo +X |
| projectiles/ice_shard.png | Mesmo atlas, superior segunda coluna | Escala 0,028; rotação local +45° |
| projectiles/arcane_orb.png | Mesmo atlas, superior terceira coluna | Escala 0,022; centro acompanha projétil |
| effects/arcane_impact.png | Mesmo atlas, inferior segunda coluna | Expande/desaparece em 0,3 s; dano e raio da área permanecem iguais |

Caminhos relativos à pasta `res://assets/processed/`. Frames: uma imagem em cada arquivo. A altura em tela é multiplicada pela escala 1,25 de World. A barra usa largura 36/44 e posição Y = -altura-10; o pivô fica junto aos pés. Bob de 1,2/0,7 px, deformação de 1,2% e balanço de 1,2°/0,8° afetam apenas o filho visual. O personagem vira horizontalmente nas curvas, mas não possui poses específicas de costas/frente.

## Reavaliação das caminhadas

Seis poses visíveis em cada folha, arranjo aproximado 3×2. Nenhuma folha foi aprovada como ciclo: falta alfa e não há comprovação de alinhamento dos pés/pivôs entre quadros. Dimensões divisíveis não garantem uma grade útil.

| Folha JPEG | Dimensões | Direção/personagem observados | Aproveitamento futuro |
|---|---|---|---|
| mob_gremlin_walk_e | 2400×1792 | Gremlin, frente/3/4 para direita | Candidata a leste após recorte/alfa e alinhamento; grade nominal 800×896 |
| mob_gremlin_walk_n | 2048×2048 | Frente/3/4, não costas | Candidata a outra orientação após classificação; largura não divisível por 3 |
| mob_gremlin_walk_s | 2048×2048 | Costas, não frente | Candidata a norte após classificação e tratamento; grade irregular |
| mob_gremlin_walk_w | 2048×2048 | **Golem**, não gremlin | Rejeitada como gremlin; não importar |
| mob_golem_walk_n | 2400×1792 | Frente/3/4, não costas | Candidata a frente após classificação; grade nominal 800×896 |
| mob_golem_walk_s | 2400×1792 | Costas, não frente | Candidata a norte após classificação; grade nominal 800×896 |
| mob_golem_walk_w | 1024×765 | Frente/3/4 para direita | Oeste não confirmado; dimensões não divisíveis por 3×2 |
| mob_golem_walk_e | Ausente | — | Não inventar folha; espelhamento exige oeste válido |

O suporte anterior `walk_n/s/e/w` permanece opcional. `prefer_walk_frames` permite optar por um SpriteFrames futuro; na ausência de um conjunto válido, usa sprite estático ou desenho procedural. Nesta entrega nenhum SpriteFrames foi atribuído. Verificação de nomes/contagens no script não substitui aprovação artística e temporal dos frames.

## Mapa, efeitos e HUD

Mapa, rota superior com 27 pontos e sete bases mantidos. Profundidade dos atores usa os pés: `10 + clamp(round(y), 0, 2000)` em Z absoluto. Projéteis/impactos em 3000; rota de debug em 3500; HUD no CanvasLayer 10. Os pais de torres e caminho não têm transformações locais, permitindo comparar Y no mesmo espaço do mapa.

Seleção, alcance, sombra, barras de vida e sinalização de lentidão preservados. A HUD mantém painéis e contraste existentes; apenas a nota de rodapé foi atualizada. O ponto original de disparo e a mira de combate foram preservados para não alterar o tempo de viagem. Impactos de flecha/gelo continuam procedurais. `element_visuais`, `Decorações_avulsas` e `texturas` foram revistos e mantidos como referência: fundos incorporados, layout de prancha e risco de cobrir a rota não justificam adicioná-los agora.

## Evidências e limites

- [Composição sobre o mapa](etapa3_scene_preview.png): escalas, posições e ordenação dos dados reais, sem HUD. **Não é captura do Godot.**
- [Alfa em fundo claro e escuro](etapa3_alpha_review.png): nenhuma borda quadriculada óbvia, silhuetas completas, neve preservada e brilho suave. Inspeção visual também feita nas imagens individuais.
- `tools/preview_visual_assets.py` gera somente imagens de inspeção, sem modificar os PNGs do jogo.
- Nove texturas somam ~53,99 MiB RGBA antes de compressão do engine. Carregamento é compartilhado por cache; desempenho/importação não foram medidos no Godot.
- Retângulos grandes transparentes não participam de colisão/input. Distâncias de combate continuam referenciadas aos pés e raios anteriores.
- P0: verificar importação e gameplay no editor. P1: revisar recorte em movimento, origem visual dos disparos, brilho e sobreposição nas curvas. P2: produzir ciclos válidos e versões menores para distribuição.
