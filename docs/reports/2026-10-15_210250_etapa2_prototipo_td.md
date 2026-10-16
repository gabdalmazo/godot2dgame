# Etapa 2 — primeiro protótipo tower defense

Data local: 2026-10-15 21:02:50, America/Sao_Paulo.

## 1. Objetivo e resultado
Preparar a primeira versão jogável de Vale do Sino da Aurora: mapa, dois inimigos, três torres, construção, cinco ondas, moedas, vidas, HUD, pausa, resultados e reinício, preservando a migração e os assets originais.
**Resultado: todos esses sistemas foram implementados em arquivos. Execução no Godot, comportamento real e balanceamento aguardam teste manual pelo usuário.**

## 2. Diagnóstico e material examinado
Projeto ativo confirmado em game-inicial/project.godot, feature 4.4 e Compatibility. Cena anterior aurora_staging.tscn preservada.
Lidos AGENTS raiz/filho, status, decisões, manifesto, índice/relatório da migração, relatório de limpeza, kit de produção e pedido completo da etapa 2.
Git em GPT-GAME, HEAD 400d9e4; as alterações da migração e assets já estavam no staging ao iniciar. Índice preservado: não houve git add, commit, checkout, reset ou nova limpeza.
Inspecionadas as 18 imagens: mapa e guia em tamanho original; demais em prancha visual, mais contagem integral de pixels alfa. Configurações, cenas, scripts e Resources novos revisados estaticamente.

## 3. Mapa, caminho e posições
Mapa original copiado sem modificação para res://assets/maps/aurora_valley/aurora_valley.png.
World usa escala uniforme 1,25 e posição Y=2,5; mapa 1024×572 torna-se 1280×715 dentro do viewport 1280×720. Todos os elementos do mundo compartilham coordenadas; HUD separado.
Path2D manual com 27 pontos/tangentes segue a linha vermelha superior do guia. Comprimento aproximado 1.132,17 px pela amostragem do verificador; travessia estimada sem combate: 23,59 s gremlin, 42,89 s golem. A estrada inferior é somente visual.
Bases válidas 1, 2, 4, 5, 6, 7, 8. Base 3 rejeitada por rochas. Cada uma tem ID, área clicável, seleção, referência à torre e ocupação.
A primeira análise revelou cobertura nula de flecha/gelo na base 6. Alcances ajustados de 145/160/180 para 180/195/210; nova análise confirmou cobertura para as três torres em todas as bases.
Evidência de geometria: ../assets/route_validation.png, gerada dos dados reais da cena; não é captura de runtime.

## 4. Assets e animações
- Importável no editor: somente mapa original, cópia byte a byte.
- Corrigidos/recortados: nenhum. Originais intactos; nenhuma edição destrutiva.
- **Todas as 18 imagens têm 100% de pixels opacos**, inclusive as que possuíam canal alfa.
- Torres, personagens, decorações, UI e partículas têm quadriculado incorporado; aguardam recortes/transparência confiáveis.
- Sete folhas mostram seis poses em 3×2 aproximado. Isso não garante grade uniforme/pivôs; todas rejeitadas para SpriteFrames.
- mob_gremlin_walk_w contém golem. Norte/sul dos dois monstros apresentam conteúdo incompatível com os nomes. Leste do golem ausente.
- Placeholders nativos: dois personagens com passos e orientação, três silhuetas de torre, flecha/cristal/orbe, impactos e interface.
- AnimatedSprite2D e Resource SpriteFrames opcional preparados para walk_n/s/e/w; nenhum SpriteFrames de folha inválida foi criado/atribuído. Espelhamento leste a partir de oeste do golem habilitável quando houver arte aprovada.
- Pivô dos placeholders nos pés; pivôs das folhas rejeitadas não foram inventados.
- Origem informada pelo usuário: IA/Nano Banana 2, uso autorizado no protótipo. Distribuição comercial não examinada.
Detalhes por imagem e direção em ../assets/INSPECAO_ETAPA2.md e ../ASSET_MANIFEST.md.

## 5. Sistemas implementados
- Resources separados para inimigos, torres e ondas; cenas reutilizáveis e comunicação por sinais.
- Inimigos: vida/dano, movimento por PathFollow2D, chegada, morte, recompensa, barra de vida, orientação e lentidão temporária. Resolução protegida contra morte/escape duplicados.
- Torres: seleção por maior progresso no alcance, intervalos, três projéteis, efeitos de gelo e área; varredura limitada quando sem alvo.
- Compra: valida moedas/estado/ocupação, reserva base e debita de forma síncrona, mostra informações de ocupadas. Preços 55/75/100.
- Projéteis: alvo validado, vida útil limitada, remoção quando alvo inválido; área aplica um dano por inimigo. Lentidão usa menor multiplicador e duração renovada, sem empilhamento multiplicativo.
- Ondas: Resources com totais 6/10/13/17/21, spawn intercalado, botão controlado e término apenas após fila vazia mais zero inimigos ativos.
- Economia: 170 moedas, 15 vidas, recompensa 8/20, escape -1.
- HUD: vidas, moedas, onda, estado, próximos inimigos ativos, compra, informações, fechar, pausa/retomar e reinício.
- Estados: preparação, onda ativa, intervalo, vitória, derrota e pausa. World/Waves pausáveis, raiz/HUD sempre ativos.
- Vitória exige cinco ondas e nenhum inimigo ativo, com vidas restantes; derrota interrompe spawns e pausa o mundo. Reinício despausa e recarrega cena.
- Debug opcional da curva e alcance visível ao selecionar/passar o mouse na torre.

## 6. Não implementado
Arte final transparente, folhas direcionais aprovadas, áudio, venda/upgrades, save, menus elaborados, oitava base artística, múltiplas rotas/fases, builds ou publicação.
Nenhum download, instalação, atualização, procura adicional ou execução do Godot foi feito. A migração anterior não foi repetida.
Não foi comprovado que todas as combinações de torres vencem a partida, nem que a duração atende 6–12 minutos; isso depende de teste e ajuste.

## 7. Arquivos novos
- docs/assets/contact_sheet.png
- docs/assets/INSPECAO_ETAPA2.md
- docs/assets/pixel_audit.json
- docs/assets/route_validation.png
- docs/reports/2026-10-15_210250_etapa2_prototipo_td.md
- docs/TESTE_MANUAL.md
- docs/validation/etapa2_changes.json
- docs/validation/etapa2_git_diff.txt
- docs/validation/etapa2_git_status.txt
- docs/validation/etapa2_initial_files.json
- docs/validation/etapa2_static.json
- game-inicial/assets/maps/aurora_valley/aurora_valley.png
- game-inicial/data/enemies/golem.tres
- game-inicial/data/enemies/gremlin.tres
- game-inicial/data/towers/arcane.tres
- game-inicial/data/towers/archer.tres
- game-inicial/data/towers/ice.tres
- game-inicial/data/waves/wave_01.tres
- game-inicial/data/waves/wave_02.tres
- game-inicial/data/waves/wave_03.tres
- game-inicial/data/waves/wave_04.tres
- game-inicial/data/waves/wave_05.tres
- game-inicial/docs/TD_ARCHITECTURE.md
- game-inicial/scenes/enemies/golem.tscn
- game-inicial/scenes/enemies/gremlin.tscn
- game-inicial/scenes/projectiles/projectile.tscn
- game-inicial/scenes/towers/tower_pad.tscn
- game-inicial/scenes/towers/tower.tscn
- game-inicial/scenes/ui/game_hud.tscn
- game-inicial/scenes/world/aurora_level.tscn
- game-inicial/scripts/core/level.gd
- game-inicial/scripts/data/enemy_data.gd
- game-inicial/scripts/data/tower_data.gd
- game-inicial/scripts/data/wave_data.gd
- game-inicial/scripts/enemies/enemy.gd
- game-inicial/scripts/projectiles/impact.gd
- game-inicial/scripts/projectiles/projectile.gd
- game-inicial/scripts/systems/wave_manager.gd
- game-inicial/scripts/towers/tower_pad.gd
- game-inicial/scripts/towers/tower.gd
- game-inicial/scripts/ui/game_hud.gd
- tools/audit_assets.py
- tools/validate_td.py

## 8. Arquivos alterados
- docs/ASSET_MANIFEST.md
- docs/DECISOES.md
- docs/reports/INDEX.md
- docs/STATUS.md
- game-inicial/AGENTS.md
- game-inicial/docs/ARCHITECTURE.md
- game-inicial/docs/CHANGELOG_DEV.md
- game-inicial/docs/PROJECT_STATUS.md
- game-inicial/docs/TODO.md
- game-inicial/project.godot
- game-inicial/README.TXT
- README.TXT

Nenhum arquivo excluído ou movido nesta etapa. Lista comparada ao snapshot inicial da etapa; contact_sheet foi criado imediatamente antes desse snapshot e foi incluído explicitamente. Dados verificáveis em ../validation/etapa2_changes.json.
Documentos históricos foram preservados com orientação para a arquitetura atual. AGENTS raiz permaneceu intacto; AGENTS local teve apenas contexto de cena/validação atualizado.

## 9. Verificações executadas e resultados
Python utilizado: C:/Users/matheus/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe.

1. **python tools/audit_assets.py** — código 0. Leitura das 18 imagens, contagem integral de alfa, dimensões/formatos/hashes e cópia idêntica do mapa. Evidência: ../assets/pixel_audit.json.
2. **python tools/validate_td.py**, rodada inicial — código 1, 346 verificações aprovadas e duas falhas de cobertura na base 6. Corrigidos alcances.
3. **python tools/validate_td.py**, rodada após ajuste — código 0, **348 verificações aprovadas**, zero falhas; **48 referências de fonte válidas**. Valida nós/parents, IDs de recursos, bindings de scripts, arquivos, classes únicas, dados de ondas/torres, modos de pausa, geometria/alcance, integridade dos originais e mapa copiado.
4. Inspeção visual da prancha de assets e da figura da curva sobre o mapa: executada. A linha segue a estrada superior e os pads correspondem às sete plataformas circulares.
5. **git diff --check** — código 0. Apenas avisos Git de normalização CRLF/LF; sem falhas de whitespace.
6. **git status --short --untracked-files=all** e **git diff --stat** — registrados em ../validation/etapa2_git_status.txt e etapa2_git_diff.txt. Diff sem staging compara esta etapa ao índice anterior; arquivos novos constam no status e na lista deste relatório.
7. Consulta pontual às APIs oficiais Godot 4.4 de CollisionObject2D e PathFollow2D; referências em game-inicial/docs/TD_ARCHITECTURE.md.

**Limites:** o verificador Python não é parser GDScript nem importador Godot. gdtoolkit/lark não estavam presentes; não instalados. Nenhum teste de runtime, input real, renderização Godot, pausa em execução ou partida completa foi executado. A responsabilidade de executar o editor nesta etapa foi explicitamente atribuída ao usuário.

## 10. Tutorial para teste
Roteiro detalhado com 26 passos: [TESTE_MANUAL](../TESTE_MANUAL.md).
1. Importar game-inicial/project.godot no editor Godot 4.4+ padrão e aguardar importação.
2. Conferir Main Scene res://scenes/world/aurora_level.tscn e executar F5.
3. Esperado: mapa nevado, sete bases, 15 vidas, 170 moedas, onda 0/5, controles e aviso de visuais provisórios.
4. Clicar base 2 e comprar Sentinela: saldo 115. Repetir clique não pode duplicar compra. Comprar gelo na base 5: saldo 40; compras caras ficam indisponíveis.
5. Iniciar onda 1: seis gremlins, torres disparando, barras de vida e recompensa por morte. Próxima onda indisponível até encerramento.
6. Testar arcana em outra partida, junto a uma Sentinela; observar área e gelo sem lentidão infinita.
7. Para escape/derrota: reiniciar sem construir, deixar seis da onda 1 escaparem (vidas 9), iniciar onda 2 sem defesa até zerar.
8. Para vitória: defender as cinco ondas; resultado apenas após resolver o último inimigo com vidas restantes.
9. Esc/Pausar deve congelar mundo/spawn/efeitos; Retomar continua, Reiniciar restaura todos os valores e remove entidades antigas.
10. Conferir Output/Debugger. Enviar primeiro erro completo, arquivo/linha, passos, screenshot e resultado observado. Próxima interação deve corrigir essas evidências antes de ampliar escopo.

## 11. Riscos, limitações e pendências
- Parsing/importação e APIs em execução precisam da confirmação no editor.
- Layout, clique, escala e desenho procedural não tiveram captura de runtime; evidências gráficas são apenas engenharia.
- Dificuldade e duração ainda não medidas; alcances ampliados podem tornar algumas estratégias fáceis.
- Sete bases provisórias conforme arte; ramo inferior visual pode sugerir rota alternativa, mas não está ativo.
- Sprites direcionais, fundos e pivôs impedem integração visual definitiva. Nenhum recorte ruim foi apresentado como pronto.
- Sem bug de runtime conhecido por evidência, pois runtime não foi executado; isso não equivale a ausência de bugs.

## Próximos Passos — P0 (urgente), P1 (importante), P2 (opcional)
- **P0:** executar o roteiro no Godot e enviar erros/screenshots; corrigir parsing, importação ou falhas do loop que forem observadas.
- **P1:** ajustar economia/alcances/cadências com uma partida completa e regenerar assets com alfa/grade/direção corretos; integrar SpriteFrames aprovados.
- **P2:** revisar oitava plataforma, substituir formas provisórias, adicionar áudio e polimento visual.

Entrega preparada para teste manual; não declarar versão validada ou publicação pronta.
