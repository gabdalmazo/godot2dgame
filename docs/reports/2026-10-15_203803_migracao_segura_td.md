# Migração segura para Vale do Sino da Aurora

Data local: 2026-10-15 20:38:03 (America/Sao_Paulo).

## Objetivo solicitado
Auditar a pasta experimental, preservar recursos úteis, reconciliar AGENTS, remover legado comprovadamente obsoleto após backup e preparar base Godot 2D para receber assets TD. Não implementar o jogo completo.

## Estado anterior e exame
Dois projetos: FPS na raiz e metroidvania lateral ativo em game-inicial/. Branch GPT-GAME, HEAD 400d9e4.
AGENTS raiz modificado pelo usuário; sete documentos do kit e img/ não rastreados. Sem alteração prévia nos arquivos selecionados para descarte.
Lidos AGENTS raiz/filho, READMEs, configurações Godot/editor/Git, documentos históricos e kit de produção; inspecionados cenas, scripts, testes, referências e metadados das imagens.
Inventário recursivo de 62 arquivos, 22.530.202 bytes fora de .git; CSV registra cada caminho, tamanho e hash. Não havia docs/ de controle na raiz nem relatório anterior para ler.
Sem autoloads, addons, shaders, áudio, fontes, tilesets, .tres, caches ou build encontrados.
Features declaradas: 4.4 na raiz e 4.7 no ativo. Validação 4.4.1 era histórica; versão de engine instalada não confirmada nesta execução.

## Backup e segurança
Antes de editar conteúdo existente, cópia externa dos 62 arquivos para:
C:\Users\matheus\.codex\visualizations\2026\10\15\01a141ea-9cfe-75a2-b0e7-b4e242acb74a\backup_migracao_2026-10-15_203524

Cada arquivo copiado conferido por SHA-256; inventário e matriz gravados antes das exclusões.
Antes da primeira exclusão, todos os 19 alvos foram novamente comparados ao hash original e ao backup; caminhos absolutos conferidos dentro da raiz. Remoção por Remove-Item -LiteralPath de arquivos explícitos, sem recursão.
Git não recebeu commit/reset/checkout. Nenhuma imagem, documento autoral do kit, save ou segredo removido.
Uma primeira etapa de preparação retornou código 1 por uma linha final inválida (text='') depois de gravar backup/inventário/matriz. A linha não alterou arquivos; os artefatos foram conferidos nas etapas seguintes. Não houve exclusão nessa etapa.

## Implementado
- Único projeto ativo mantido em game-inicial/, eliminando a configuração FPS duplicada da raiz.
- Cena provisória Node2D, aviso em CanvasLayer/Control, sem scripts de gameplay.
- Nome Vale do Sino da Aurora, viewport 1280×720, canvas_items/keep, Compatibility.
- Retirada de ações de plataforma/FPS, camadas antigas e opções 3D sem uso.
- AGENTS reconciliados com escopo TD; convenções de código úteis preservadas. Conflito explícito: instrução filha antiga exigia metroidvania/legado intacto; pedido atual substitui essa direção.
- Histórico preservado; avisos de migração nos documentos que orientavam execução/tarefas antigas.
- Manifesto com dimensões e formato de todas as imagens; candidatos continuam fora da raiz Godot.

## Não implementado
Importação de arte TD, recortes/transparência, animações, Path2D, pads, torres, monstros, ondas, economia, vidas, HUD de gameplay, pausa, vitória, derrota e reinício.
Sem inspeção visual de sprites/grade/pivô e sem aprovação de arte/licença. Sem download/upgrade de Godot ou plugins.

## Arquivos alterados
- AGENTS.md (preservado conteúdo preexistente e acrescentadas regras da raiz ativa).
- README.TXT.
- game-inicial/AGENTS.md.
- game-inicial/README.TXT.
- game-inicial/project.godot.
- game-inicial/docs/ARCHITECTURE.md.
- game-inicial/docs/PROJECT_STATUS.md.
- game-inicial/docs/TODO.md.

## Arquivos criados
- game-inicial/scenes/world/aurora_staging.tscn.
- docs/STATUS.md.
- docs/DECISOES.md.
- docs/ASSET_MANIFEST.md.
- docs/reports/INDEX.md.
- docs/reports/2026-10-15_203803_migracao_segura_td.md (este relatório).
- docs/migration/INVENTARIO_INICIAL.md.
- docs/migration/INVENTARIO_ARQUIVOS.csv.
- docs/migration/MATRIZ_REUTILIZACAO.md.
- docs/migration/RELATORIO_LIMPEZA.md.
- docs/migration/BACKUP.json.
- docs/migration/AGENTS_DIFF_INICIAL.patch.
- docs/migration/GIT_STATUS_INICIAL.txt.
- docs/migration/EXCLUSOES_PLANEJADAS.txt.
- docs/migration/DUPLICADOS.md.
- docs/migration/VALIDACAO_REFERENCIAS.txt.
- docs/migration/VALIDACAO_FINAL.txt.
- docs/migration/GIT_STATUS_FINAL.txt.
- docs/migration/GIT_DIFF_FINAL.txt.
- Backup externo: cópias dos 62 caminhos discriminados no CSV.

## Arquivos removidos
19 arquivos, 43.255 bytes de conteúdo; não equivale a espaço físico de disco e o backup ocupa espaço externo. Motivos individuais e recuperação em RELATORIO_LIMPEZA.md.
- project.godot
- scenes/player/player.tscn
- scenes/world/controller_test.tscn
- scripts/player/first_person_player.gd
- scripts/player/first_person_player.gd.uid
- tests/player_controller_test.gd
- tests/player_controller_test.gd.uid
- game-inicial/scenes/player/player.tscn
- game-inicial/scenes/world/controller_test.tscn
- game-inicial/scripts/player/first_person_player.gd
- game-inicial/scripts/player/first_person_player.gd.uid
- game-inicial/tests/player_controller_test.gd
- game-inicial/tests/player_controller_test.gd.uid
- game-inicial/scenes/player/player_2d.tscn
- game-inicial/scenes/world/prototype_2d.tscn
- game-inicial/scripts/player/platformer_player.gd
- game-inicial/scripts/player/platformer_player.gd.uid
- game-inicial/tests/platformer_player_test.gd
- game-inicial/tests/platformer_player_test.gd.uid

Nenhum arquivo movido. Diretórios vazios mantidos.

## Testes e verificações efetivamente executados
1. Get-FileHash -Algorithm SHA256 sobre origem e cópia dos 62 arquivos: todos iguais.
2. Get-FileHash novamente sobre os 19 alvos e backup antes da remoção: todos iguais.
3. Varredura PowerShell de res:// em .godot/.tscn/.tres/.gd/.import: quatro referências não geradas, zero ausentes. Destinos res://.godot/ são cache a gerar e foram excluídos da checagem de fontes.
4. Get-FileHash das 18 imagens e sete documentos autorais após mudanças: 25 arquivos intactos.
5. Get-ChildItem -Recurse -Filter project.godot: uma entrada remanescente; cena neutra verificada sem Node3D/CharacterBody/scripts.
6. git diff --check: primeira rodada detectou linhas vazias extras no fim de três documentos; corrigidas. Rodada seguinte código 0. Avisos de normalização CRLF/LF não são falha de parsing.
7. git status --short e git diff --stat: registro final em GIT_STATUS_FINAL.txt e GIT_DIFF_FINAL.txt. Arquivos novos não entram na estatística de diff sem staging; estão listados neste relatório/status.
8. Metadados raster lidos com System.Drawing.Image.FromFile: dimensões e canal alfa registrados; não comprova transparência útil nem qualidade visual.

Godot não foi executado: Get-Command godot* e busca recursiva de *godot*.exe na pasta do usuário não encontraram binários; locais usuais Program Files/Programs também sem candidato.
Portanto importação, parsing pelo engine, abertura gráfica e runtime NÃO validados. Não reutilizamos os 29 testes antigos como evidência atual.
Quando disponível, executar da raiz:
godot --headless --path game-inicial --editor --import --quit
godot --headless --path game-inicial --quit-after 120

## Bugs, riscos, pendências e bloqueios
- Engine ausente das buscas bloqueia a definição de pronto quanto à abertura/execução confirmada; validação estática não substitui Godot.
- Arte em img/ não rastreada, preservada; licença/origem e adequação visual pendentes.
- Sete imagens walk em JPEG não possuem canal alfa; falta mob_golem_walk_e na coleção atual. Não há oito spritesheets validados.
- Mapa encontrado com 1024×572 difere da recomendação 2048×1152; inspecionar proporção/rota antes de importar.
- SVG player preservado órfão; ícone herdado permanece provisório. .import contém caminhos de cache esperados, ainda não gerados.
- Documentação histórica contém caminhos removidos explicitamente sinalizados como históricos.
- Backup externo é recuperável, porém não substitui política durável de backup do usuário.

## Próximos Passos — P0 (urgente), P1 (importante), P2 (opcional)
- P0: importar/abrir game-inicial/project.godot no Godot instalado e executar a cena provisória; registrar versão e logs reais.
- P1: importar mapa e sprites gerados no Nano Banana 2 após inspecionar origem/licença, mapa, transparência, seis frames por direção e pivôs; obter direção leste do golem.
- P1: alinhar manualmente Path2D à trilha e preparar primeira travessia com placeholder.
- P2: organizar diretórios de assets aprovados, decidir destino do SVG órfão e guardar backup em local durável.

Migração estrutural e descarte concluídos; confirmação de abertura Godot permanece pendente.
