# Estado atual — etapa 3, 2026-10-15

Base da etapa 2 validada pelo usuário. Nove artes transparentes integradas, sprites estáticos procedurais e camadas por pés; gameplay preservado por comparação estática. Teste visual/regressão no Godot pendente. Fontes atuais: [arquitetura TD](TD_ARCHITECTURE.md), [status](../../docs/STATUS.md) e [teste manual](../../docs/TESTE_MANUAL.md).

---

## Registros anteriores (estado histórico)

# Histórico de desenvolvimento

## 2026-10-10

### Adicionado

- Player 2D reutilizável com CharacterBody2D, Sprite2D, Camera2D e colisor.
- Movimento horizontal com aceleração/frenagem, gravidade, pulo e orientação.
- Sala de teste 2D com chão, degrau, desnível, plataformas e obstáculo.
- Sprite SVG placeholder original e HUD simples de instruções.
- Ação jump (Espaço) e setas alternativas para move_left/move_right.
- 29 verificações automatizadas de comportamento no Godot 4.4.1.
- Validação da inicialização e inspeção de duas capturas reais da cena em OpenGL.
- AGENTS.md e documentos vivos de status, arquitetura, decisões e tarefas.
- Orientação na pasta pai sobre qual cópia é ativa e qual é legado.

### Alterado

- Main Scene de game-inicial passa de controller_test.tscn para prototype_2d.tscn.
- Nome do jogo, renderer Compatibility, viewport 960 × 540 e fundo de debug.
- README do projeto ativo passa a explicar a fundação 2D e sua validação.
- Projeto da pasta pai identificado como legado 3D; não usado no jogo ativo.

### Corrigido

- Inicialização do projeto ativo deixa de abrir a direção 3D cancelada.
- A/D deixam de usar o filtro de device 16 encontrado na configuração e passam
  a aceitar eventos de teclado padrão; teste valida também as setas e Espaço.

### Removido

- Nenhum arquivo removido. Forward+/D3D12 deixam de ser a configuração ativa.
- Sistemas 3D retirados do fluxo principal, preservados nos caminhos originais.

## 2026-10-15 — Etapa 2: primeiro protótipo tower defense
Mapa original copiado, rota superior Path2D, sete bases válidas, dois inimigos e três torres reutilizáveis, projéteis, lentidão/área, cinco ondas, economia, HUD, pausa e resultados implementados em arquivos.
Arte opaca/direções inválidas substituídas por placeholders procedurais. Originais preservados.
Verificações estáticas aprovadas; Godot não executado conforme pedido. Ver ../../docs/TESTE_MANUAL.md.
