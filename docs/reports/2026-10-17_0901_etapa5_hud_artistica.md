# Etapa 5 — HUD artística do Vale do Sino da Aurora

Data local: **2026-10-17 09:01**, America/Sao_Paulo. Projeto ativo: `game-inicial/project.godot`, configurado para Godot 4.7/GL Compatibility. **Implementação e validação estática realizadas; teste no editor pendente.**

## Objetivo, estado anterior e exame

O usuário pediu reconstruir a aparência da HUD segundo uma referência Nano Banana 2, mantendo economia, torres, ondas, pausa, áudio e Sino da Aurora. Antes, a Etapa 4 deixara uma HUD translúcida genérica, já com sinais e mecânicas conectados, mas ainda sem confirmação de runtime. Foram lidos os AGENTS.md, STATUS, DECISOES, ASSET_MANIFEST, TESTE_MANUAL, índice e último relatório, cena/script da HUD, nível, dados de torres, carregador de texturas, projeto e Git. Havia alterações não commitadas da Etapa 4; elas foram preservadas.

O arquivo anunciado como `img/hub_nova.png` não existia. O usuário o acrescentou como **`img/hud_nova.jpg`** durante esta interação. A inspeção visual e o Pillow confirmaram **1024×572, JPEG RGB opaco**: placas e cartões são compostos ao mapa, com textos e números fundidos. **Nenhum elemento foi extraído** nem a imagem inteira carregada no jogo, pois os recortes ficariam contaminados. O original do usuário permaneceu intacto em `img/`.

Antes da edição, foram copiadas a cena e o script da HUD da Etapa 4 para `.tools/etapa5_baseline/` (diretório ignorado pelo Git). SHA-256: `game_hud.tscn` `4F5B3381364B7AF8A00126692DD673B93AC13977CF4157E0A509BD2BC8A4BAE5`; `game_hud.gd` `BBB9A63B283CCA07460E2CDC9BF64C86BE57E45E6EA0DF5E66C96B2D29BE0556`.

## Implementado

- Barra superior em placas individuais com título dinâmico, vida, moedas, estandarte azul de onda e botão de pausa com engrenagem; contadores continuam ligados ao `level.gd`.
- Painel de construção em madeira/bronze com bordas claras, três cartões azulados e imagens das torres lidas de `TDTowerData.texture_path` via `AuroraVisualAssets`. Preço, descrição, tooltip, habilitação e custo insuficiente vêm dos dados reais. Base ocupada oculta compras e reduz o painel.
- Rodapé temático com status compacto, Sino com ícone e ProgressBar de recarga, botão verde de iniciar onda e reinício; toasts e sobreposições de pausa/vitória/derrota adotam o mesmo tema.
- Pequeno fade de entrada do menu, hover discreto dos cartões e pulso de cor quando moedas/vidas mudam. Anchors, containers e layout ajustado em larguras menores preservam controles e reduzem textos quando necessário.
- Quatro ícones SVG originais em código: coração, moeda, engrenagem e sino. A neve é aproximada por bordas claras de StyleBoxFlat; madeira, bronze, azul e verde são estilos nativos. Não foi criado ou copiado PNG adicional para a HUD.
- Contrato de sinais e métodos da HUD mantido. Nenhum arquivo de regra de gameplay foi editado na Etapa 5; cooldown e duração continuam 24 s/3 s no nível.

## Arquivos criados, alterados, movidos ou excluídos

**Criados pela Etapa 5:** `game-inicial/assets/ui/aurora/heart.svg`, `coin.svg`, `gear.svg`, `bell.svg`; `tools/validate_stage5.py`; `docs/validation/etapa5_static.json`; `docs/assets/etapa5_route_validation.png` (prévia de engenharia da rota, não captura do jogo); este relatório. Backup recuperável local: `.tools/etapa5_baseline/game_hud.tscn` e `game_hud.gd`.

**Adicionado pelo usuário:** `img/hud_nova.jpg`, referência externa preservada.

**Alterados pela Etapa 5:** `game-inicial/scenes/ui/game_hud.tscn`, `game-inicial/scripts/ui/game_hud.gd`, `game-inicial/docs/TD_ARCHITECTURE.md`, `game-inicial/AGENTS.md`, `game-inicial/README.TXT`, `README.TXT`, `docs/STATUS.md`, `docs/DECISOES.md`, `docs/ASSET_MANIFEST.md`, `docs/TESTE_MANUAL.md`, `docs/assets/pixel_audit.json` (regenerado pelo auditor após a nova imagem), `docs/reports/INDEX.md`.

**Movidos/excluídos:** nenhum. As alterações não commitadas da Etapa 4 e os assets originais não foram revertidos, staged ou commitados.

## Testes efetivamente executados

| Comando na raiz do repositório | Resultado |
|---|---|
| `python tools/validate_stage4.py` | Exit 0, 190 checagens, zero erros; contrato anterior preservado |
| `& '<Python incluído no Codex>' tools/validate_td.py --output docs/validation/etapa5_static.json --preview docs/assets/etapa5_route_validation.png` | Exit 0 final, 462 checagens, 90 referências, zero erros; rota 1132,17 px e ondas 6/10/13/17/21 |
| `& '<Python incluído no Codex>' tools/audit_assets.py` | Exit 0, 19 originais auditados; `hud_nova.jpg` opaco; nenhum original alterado pelo script |
| `& '<Python incluído no Codex>' tools/validate_stage5.py` | Exit 0, 60 checagens, zero erros: caminhos de nós, sinais, SVGs, carregamento e estados |
| `& '<Python incluído no Codex>' -m py_compile tools/validate_stage5.py` | Exit 0, sintaxe Python válida |
| `git diff --check` | Exit 0, sem erros de whitespace; avisos de conversão de fim de linha em arquivos já existentes |

O `python` padrão local não contém Pillow, então `validate_td.py` e `audit_assets.py` falharam inicialmente com `ModuleNotFoundError: PIL`; foram reexecutados com o Python incluído no Codex, que contém Pillow 12.3.0. O executável Godot não foi procurado nem executado, conforme pedido. Esses testes não verificam parser GDScript, importação de SVG, renderização, foco, cliques ou gameplay em runtime.

## Não implementado, riscos e teste manual

Não foram produzidos recortes da referência, textura 9-slice, neve irregular ilustrada, relevo cartoon 3D idêntico, fontes finais, música ou alterações de balanceamento. Para maior fidelidade, pedir ao Nano Banana 2 **um atlas RGBA com fundo transparente e sem mapa, texto ou números**, contendo separadamente: placa de título, painel de construção sem inscrições, cartão de torre vazio, estandarte azul vazio, molduras dos botões de pausa/onda e uma faixa de neve para 9-slice. Cada peça precisa de margem transparente e bordas contínuas sem sombras recortadas.

P0 de teste: abrir `game-inicial/project.godot`, aguardar a importação, pressionar F5 e seguir `docs/TESTE_MANUAL.md`. Confirmar visualmente layout em 1280×720 e janelas estreitas, caminhos SVG, painel/menu, saldo, ícones, hover, toasts, Sino, pausa e resultados. O usuário deve informar a primeira mensagem completa de Output/Debugger e uma captura com dimensões da janela se algo quebrar. A cena não foi renderizada pelo Codex; a fidelidade visual final e a ausência de regressão só podem ser afirmadas após esse teste.

## Próximos Passos

- **P0 (urgente):** executar F5 e o roteiro manual da Etapa 5, corrigindo qualquer erro de parser, importação, corte ou clique; repetir cinco ondas e pausa/Sino.
- **P1 (importante):** ajustar posições, tipografia, contraste e escalas com captura real em 1280×720, 960×540, 800×600 e 640×480; avaliar a Etapa 4 (áudio/caminhada) no mesmo teste.
- **P2 (opcional):** substituir a aproximação nativa por atlas transparente específico de UI, usar NinePatchRect onde houver peças limpas, criar música e animações de sprites válidas.
