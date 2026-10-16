# Inventário inicial — 2026-10-15

## Raízes e versão
Repositório: C:/Users/matheus/Desktop/GIT/godot2dgame. Branch GPT-GAME, HEAD 400d9e4.
Dois project.godot: raiz (FPS legado, feature 4.4) e game-inicial/ (ativo segundo documentação anterior, feature 4.7). Config format=5, GDScript, Compatibility em ambos.
Godot 4.4.1 aparece apenas como validação histórica. Nenhum executável encontrado no PATH, busca recursiva na pasta do usuário ou locais usuais de instalação; versão instalada não confirmada.
Documentos de controle na raiz e índice de relatórios inexistiam. AGENTS da raiz já modificado e sete documentos mais img/ não rastreados: preservados e incluídos no backup.

## Estrutura e subsistemas
- Raiz: AGENTS, README, sete documentos do kit TD, projeto/cenas/scripts/testes FPS duplicados.
- game-inicial/: configurações editor/Git, AGENTS, README, cinco documentos históricos, ícone SVG e import.
- game-inicial/scenes/: player 3D, sala 3D, player lateral 2D e sala de plataformas.
- game-inicial/scripts/: controladores FPS e lateral. Sem utilitários genéricos independentes.
- game-inicial/tests/: testes específicos FPS/plataformas; não validam TD.
- game-inicial/assets/placeholders/: player.svg e import; preservados.
- img/: 18 imagens candidatas do TD, sem rastreamento Git; nenhuma foi classificada para descarte.
- Não encontrados addons, autoloads, shaders, fontes, áudio, tilesets, .tres, builds, caches .godot ou ferramentas .tools.
Inventário exaustivo: INVENTARIO_ARQUIVOS.csv (caminho, bytes, SHA-256). 62 arquivos fora de .git, 22530202 bytes (~21,49 MiB); metadados Git excluídos do total/backup.

## Entradas e referências
Raiz: project → controller_test.tscn → player.tscn → first_person_player.gd; teste carrega mundo 3D.
Ativo: project → prototype_2d.tscn → player_2d.tscn → platformer_player.gd + player.svg.
Ativo contém também a mesma cadeia FPS sem uso pela cena 2D. SVG e ícone têm .import apontando ao cache gerado.
Cenas não usam herança; player é instanciado. Ausência de dependências externas de runtime.
Input raiz: WASD, sprint, pause. Input ativo: mesmas ações mais jump e setas laterais.
Viewport raiz 1152×648; ativo 960×540, canvas_items. Camadas World/Player; configuração Jolt 3D e compatibilidade de esqueleto no ativo são resíduos.
Câmera 2D é filha do jogador lateral; não é câmera fixa TD reaproveitável como sistema.
HUD contém somente instruções de plataforma; não há vida, moedas, ondas, torres ou inimigos.
Duplicatas exatas podem ser consultadas em DUPLICADOS.md; maior volume está em imagens, não em lixo de build.

## Conflitos e tratamento
AGENTS filho exige metroidvania e manter legado; solicitação atual explicitamente autoriza migração e descarte recuperável. Atualizar instruções preservando convenções úteis e registros históricos.
Não elevar feature 4.7 a prova de engine instalada. Base provisória passa a declarar 4.4, compatível com os recursos usados; sem instalar/atualizar dependências.
Backup integral dos arquivos de trabalho, incluindo modificações não commitadas: C:\Users\matheus\.codex\visualizations\2026\10\15\01a141ea-9cfe-75a2-b0e7-b4e242acb74a\backup_migracao_2026-10-15_203524. Cada cópia conferida por SHA-256 antes de mudanças. Git preservado intacto.
