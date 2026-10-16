# Relatório de limpeza — 2026-10-15

Backup externo: 
C:\Users\matheus\.codex\visualizations\2026\10\15\01a141ea-9cfe-75a2-b0e7-b4e242acb74a\backup_migracao_2026-10-15_203524

Recuperação: copiar o caminho relativo do backup para a raiz; para restaurar o protótipo inteiro, usar uma nova pasta externa com todo o backup. O backup inclui alterações não commitadas; HEAD 400d9e4 é recuperação adicional dos arquivos rastreados.

Exclusões individuais, validadas antes da primeira remoção:

| Caminho | Bytes | Motivo |
|---|---:|---|
| project.godot | 1187 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scenes/player/player_2d.tscn | 905 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scenes/player/player.tscn | 769 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scenes/world/controller_test.tscn | 4428 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scenes/world/prototype_2d.tscn | 4715 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scripts/player/first_person_player.gd | 3790 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scripts/player/first_person_player.gd.uid | 20 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scripts/player/platformer_player.gd | 2052 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/scripts/player/platformer_player.gd.uid | 20 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/tests/platformer_player_test.gd | 6101 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/tests/platformer_player_test.gd.uid | 20 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/tests/player_controller_test.gd | 4898 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| game-inicial/tests/player_controller_test.gd.uid | 20 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| scenes/player/player.tscn | 798 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| scenes/world/controller_test.tscn | 4571 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| scripts/player/first_person_player.gd | 3889 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| scripts/player/first_person_player.gd.uid | 21 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| tests/player_controller_test.gd | 5030 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |
| tests/player_controller_test.gd.uid | 21 | Exclusivo FPS/plataforma; cadeia integral substituída por cena neutra. |

Total: 19 arquivos; 43255 bytes de conteúdo removidos do projeto (não mede alocação física em disco). Nenhuma pasta removida recursivamente.

Preservados: 18 imagens não rastreadas, sete documentos autorais do kit, SVG placeholder e .import, ícone e .import, configurações Git/editor e documentação histórica. Nenhum save, segredo, cache ou plugin foi removido.

Adaptados: AGENTS raiz/filho; README raiz/filho; game-inicial/project.godot; avisos nos documentos PROJECT_STATUS, TODO e ARCHITECTURE. Cena aurora_staging.tscn criada.

O project.godot legado da raiz foi removido para manter uma única entrada. Ações FPS/plataforma, camadas Player/World e opções Jolt/esqueleto removidas da configuração ativa. Não existe pausa implementada.

Não excluídos por ambiguidade: imagens img/ (origem e adequação pendentes) e placeholder autoral player.svg (possível reuso). Históricos mantêm caminhos antigos como registro, explicitamente sem vigência.
