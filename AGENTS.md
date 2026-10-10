# Orientação do repositório

O jogo ativo está em `game-inicial/`. Leia `game-inicial/AGENTS.md` antes de
alterar o gameplay. Seus documentos vivos estão em `game-inicial/docs/`.

A direção 3D foi cancelada em 2026-10-10. O jogo agora é um metroidvania 2D.
O `project.godot` desta raiz, `scenes/`, `scripts/` e `tests/` são a primeira
cópia do protótipo 3D, preservada como legado. Não são o projeto ativo.
Abra `game-inicial/project.godot` para executar e editar a fundação 2D.

Não mantenha duas implementações do gameplay. Não copie alterações novas para
o protótipo da raiz. Não remova legado sem verificar referências e autorização.
Não edite caches `.godot/` nem ferramentas `.tools/` como se fossem código do jogo.

Após tarefas significativas, atualize `game-inicial/docs/PROJECT_STATUS.md`,
`CHANGELOG_DEV.md` e `TODO.md`. Mudanças estruturais também exigem atualização
de `game-inicial/AGENTS.md`, `ARCHITECTURE.md` e `DECISIONS.md`.
Não declare concluído um sistema sem implementação e evidência de validação.
