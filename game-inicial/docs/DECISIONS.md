# Decisões

## 2026-10-10 — Migrar de 3D para 2D

**Decisão:** cancelar a direção FPS e criar uma nova fundação com CharacterBody2D,
Camera2D e colisões 2D, independente das classes do protótipo anterior.

**Motivo:** nova direção solicitada: ação/exploração/terror em metroidvania lateral.

**Impacto:** Main Scene passa a prototype_2d.tscn. A implementação 3D permanece
como legado e não é usada pelo gameplay principal. Nenhum arquivo foi excluído.

## 2026-10-10 — Definir o projeto ativo

**Decisão:** desenvolver em game-inicial/, a cópia que o usuário abriu no Godot.

**Motivo:** evitar editar a cópia errada ou manter duas versões do jogo.

**Impacto:** AGENTS e README na pasta pai indicam o projeto correto. A cópia raiz
continua sendo legado e recebe identificação explícita no nome do projeto.

## 2026-10-10 — Preservar o legado nos caminhos existentes

**Decisão:** não mover ou apagar cenas/scripts/testes 3D nesta etapa.

**Motivo:** as referências res:// internas do legado ainda formam uma cadeia.

**Impacto:** nomes novos e distintos para o 2D; inventário em ARCHITECTURE.md.
Ações FPS e configuração de física 3D mantidas apenas para esse legado.

## 2026-10-10 — Controlador pequeno, sem sistemas especulativos

**Decisão:** um script de movimento com métodos específicos e referências
exportadas. Sprite e câmera usam nós nativos; sem autoload/state machine.

**Motivo:** a primeira etapa só precisa validar movimento e pulo.

**Impacto:** Inspector permite balanceamento. Combat/health/animation serão
componentes separados quando houver tarefas concretas, sem criá-los agora.

## 2026-10-10 — Renderização e placeholders

**Decisão:** Compatibility, viewport 960 × 540, formas sólidas e SVG simples
com filtro nearest no sprite. Plataformas sólidas e câmera seguindo diretamente.

**Motivo:** validação rápida e baixa exigência gráfica, sem arte final.

**Impacto:** abandonar Forward+/D3D12 como requisito do protótipo 2D. Sem shaders,
iluminação avançada, parallax, animações, plataformas one-way ou limites de câmera.
