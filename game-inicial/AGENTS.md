# Referência principal para agentes

Última atualização: 2026-10-10. Os caminhos abaixo são relativos a este projeto.

## Visão do projeto

Jogo 2D de ação, exploração e terror com estrutura metroidvania. Ambientação
fictícia inspirada na região da Toca da Tigra, Santana da Boa Vista, RS.
Natureza, arquitetura rural brasileira, folclore e elementos sobrenaturais.
Referências de gênero servem para princípios; não copiar assets, personagens,
nomes, músicas, código, mapas ou narrativa de outras obras.

## Tecnologias

Godot 4.x, GDScript tipado, CharacterBody2D, Sprite2D, Camera2D,
StaticBody2D e colisores 2D. Base testada no Godot 4.4.1.
Renderer Compatibility; viewport lógico 960 × 540, stretch canvas_items/keep.
Nenhum autoload, plugin de gameplay ou dependência externa de execução.

## Direção do gameplay

Side scroller com exploração interconectada e progressão futura por habilidades.
Nesta etapa: andar, acelerar, frear, pular, cair, colidir e virar o sprite.
Não implementar combate ou habilidades adicionais sem nova solicitação.

## Direção artística

Futura pixel art sombria/gótica combinada com ambientes rurais brasileiros.
Agora somente placeholders: polígonos sólidos e um sprite SVG original simples.
O SVG não é arte final. Não criar arte final ou sistemas de parallax nesta etapa.

## Arquitetura

`scenes/world/prototype_2d.tscn` é a Main Scene. Instancia o Player reutilizável,
geometria estática e HUD de instruções. Não possui script de mundo.
`scenes/player/player_2d.tscn` usa `scripts/player/platformer_player.gd`.
O controlador pequeno separa métodos de movimento, gravidade, pulo e orientação.
Camera2D segue por hierarquia, sem script. Não há state machine ou singleton.
Separar componentes quando sistemas concretos precisarem deles; não antecipar APIs.

## Convenções de código

- GDScript Godot 4, type hints úteis, funções e arquivos em snake_case.
- Propriedades de balanceamento via @export, agrupadas no Inspector.
- Física em _physics_process(delta), usando velocity e move_and_slide().
- Não mover o jogador alterando position durante gameplay. Reposicionamento em
  testes é setup, não mecanismo de movimento.
- Input Actions para teclas; não consultar teclas diretamente no controlador.
- Referências exportadas/cacheadas; evitar buscas de árvore a cada frame.
- Falhas de configuração devem gerar erros explícitos.
- Comentários explicam intenção. Evitar refatorações ou abstrações especulativas.

## Estrutura de pastas

- `scenes/player/player_2d.tscn`: módulo do jogador ativo.
- `scenes/world/prototype_2d.tscn`: sala de debug ativa.
- `scripts/player/platformer_player.gd`: controlador ativo.
- `assets/placeholders/player.svg`: visual temporário do jogador.
- `tests/platformer_player_test.gd`: testes de comportamento do protótipo 2D.
- `docs/`: status, changelog, arquitetura, decisões e tarefas.
- `.godot/`, `.tools/`: caches/ferramentas locais, ignorados pelo Git.
- `player.tscn`, `controller_test.tscn`, `first_person_player.gd` e
  `player_controller_test.gd`: legado 3D nos diretórios originais; ver inventário
  detalhado em `docs/ARCHITECTURE.md`. Não instanciados pela Main Scene.

## Input Actions

Ativas: `move_left` = A/←, `move_right` = D/→, `jump` = Espaço.
Preservadas exclusivamente para o legado: `move_forward` = W,
`move_backward` = S, `sprint` = Shift, `pause` = Esc.
Esc não pausa o protótipo 2D. O mouse permanece livre.
Attack, secondary_attack, interact, dash, inventory e map ainda não foram criadas.

## Sistemas implementados

Fundação 2D validada por 29 verificações headless no Godot 4.4.1:
aceleração/frenagem, movimento bilateral, pulo no chão, gravidade, colisões,
orientação do sprite, plataformas alcançáveis e Camera2D seguindo o jogador.
Sala com chão em duas alturas, degrau, plataformas, obstáculo e limites laterais.

## Sistemas em desenvolvimento

Validação manual e balanceamento da sensação de movimento pelo usuário.
Não há outro sistema de gameplay em implementação nesta entrega.

## Sistemas planejados

Mediante solicitação: coyote time, jump buffer, pulo variável e animações.
Em etapas posteriores: combate, inimigos, equipamentos, inventário, mapa,
salas conectadas, save points, NPCs e habilidades de exploração.
Planejado não significa implementado ou autorizado nesta tarefa.

## Decisões importantes

Direção 3D cancelada; fundação 2D nova, sem converter a classe FPS.
`game-inicial/` é o projeto ativo; a cópia na pasta pai é legado 3D.
Manter arquivos antigos intactos nesta migração para evitar quebra de referências.
Usar colisões sólidas nas plataformas; não há one-way ou descer por comando.
Usar Compatibility para reduzir a exigência gráfica do protótipo simples.

## Limitações conhecidas

Pulo fixo, somente no chão. Sem coyote time, buffer, pulo duplo, dash ou wall jump.
Sem subir degraus automaticamente: o degrau exige pulo.
Sem menu de pausa, captura do mouse, animações, camera limits ou transições.
A câmera segue também na vertical; pode mostrar o exterior vazio da sala.
Gravidade vertical fixa lida do projeto, sem campos de gravidade por Area2D.
Testes automatizados não substituem avaliação humana de sensação e teclas físicas.
Não afirmar validação no Godot 4.7: o executável disponível para teste é 4.4.1.

## Regras para futuros agentes

1. Inspecionar arquivos, referências, Input Map e este documento antes de editar.
2. Explicar mudanças relevantes antes de realizá-las. Trabalhar incrementalmente.
3. Não usar sistemas 3D para o gameplay principal; não alterar legado por conveniência.
4. Executar importação e testes adequados usando o projeto deste diretório.
5. Atualizar status/changelog/TODO após tarefas significativas; atualizar também
   AGENTS, arquitetura e decisões quando a estrutura mudar.
6. Relatar arquivos, comportamento, validação, limitações e próximos passos.
7. Não iniciar combate, coyote time, jump buffer ou pulo variável sem solicitação.
8. Não marcar funcionalidades futuras como prontas; registrar evidências reais.

## Estado atual do projeto

Main Scene 2D configurada; testes de comportamento aprovados. Pronto para o
usuário validar sensação de movimento no editor. Ver `docs/PROJECT_STATUS.md`
para a evidência mais recente e `README.TXT` para execução/teste manual.
Inicialização headless e renderização real em Compatibility também verificadas,
incluindo capturas do spawn e da plataforma elevada.
