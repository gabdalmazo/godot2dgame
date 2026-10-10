LEGADO 3D — NÃO É O PROJETO ATIVO

A direção FPS foi cancelada em 2026-10-10. Abra game-inicial/project.godot
para executar o novo protótipo 2D. Consulte game-inicial/AGENTS.md e
game-inicial/docs/PROJECT_STATUS.md. O conteúdo abaixo é documentação histórica
do protótipo 3D, preservada para referência, não instrução para o jogo atual.

TOCA DA TIGRA — FUNDAÇÃO DO CONTROLADOR FPS (HISTÓRICO)

Requer Godot 4.4 ou superior, edição padrão (GDScript).
O repositório original continha somente este README vazio. Não havia cenas,
scripts, autoloads, recursos nem Input Map para reutilizar.

ARQUIVOS

project.godot: projeto, Input Map, camadas físicas e cena principal.
scenes/player/player.tscn: Player reutilizável, sem dependência do mapa.
scripts/player/first_person_player.gd: movimentação, gravidade e mouse look.
scenes/world/controller_test.tscn: piso, paredes, obstáculo e rampa de teste.
tests/player_controller_test.gd: verificações automatizadas de comportamento.
Os arquivos .gd.uid gerados pelo Godot acompanham seus respectivos scripts.
.gitignore: exclui cache do editor e ferramentas locais de validação.
README.TXT: montagem, configuração e roteiro de teste.

ABRIR E EXECUTAR

1. No gerenciador do Godot, selecione Importar e escolha project.godot.
2. Abra scenes/world/controller_test.tscn e execute o projeto com F6 ou F5.
3. O Player nasce ligeiramente acima do piso, cai e deve permanecer apoiado.
4. Use WASD para andar e segure Shift para correr; solte para voltar a andar.
5. Mova o mouse para olhar. A rotação vertical para em -85/+85 graus.
6. Esc libera o mouse e interrompe a entrada do jogador; Esc captura novamente.
   Isso não pausa o mundo: a gravidade continua ativa, sem menu nesta etapa.
7. Ao perder foco (Alt+Tab), o controle é desativado. Retorne à janela e use
   Esc para reativar. Pare a execução pelo editor com F8.

VALIDAR OU MONTAR O PLAYER NO EDITOR

A cena player.tscn já está montada. Abra-a para validar a árvore:

Player (CharacterBody3D)
  CollisionShape3D
  Head (Node3D)
    Camera3D

1. A raiz Player usa scripts/player/first_person_player.gd. Mantenha escala
   (1, 1, 1), rotação X/Z zero e rotação Y livre para a direção inicial.
   A origem da raiz corresponde aos pés. Use pais sem escala/rotação X/Z.
2. No CollisionShape3D, use CapsuleShape3D: radius 0.3, height 1.8.
   Posição local: (0, 0.9, 0). Deixe Disabled desmarcado.
3. Head: posição local (0, 1.6, 0), sem rotação inicial.
4. Camera3D: filha de Head, posição e rotação locais zero, Current ativado,
   FOV 75, Near 0.05, Far 100.
5. Na raiz, grupo References, arraste Head para View Pivot. A cena pronta
   já possui essa referência. Uma referência ausente gera erro explícito.
6. Na raiz, Collision Layer = camada 2 (Player), Collision Mask = camada 1
   (World). Piso e paredes precisam de StaticBody3D e CollisionShape3D na
   camada 1. MeshInstance3D sozinho não gera colisão.
7. Na raiz, Floor Snap Length = 0.3, Floor Constant Speed ativado;
   Motion Mode = Grounded, Up Direction = (0, 1, 0), Floor Max Angle = 45°.
8. Instancie player.tscn no mapa acima de um piso com colisão. Para testar a
   cena Player, execute o mapa: rodar somente o Player não cria um piso.

INSPECTOR DA RAIZ PLAYER

Movement:
  walk_speed = 3.0 m/s
  run_speed = 5.5 m/s
  acceleration = 14.0 m/s² (aproxima a velocidade desejada com entrada)
  deceleration = 18.0 m/s² (freia quando não há entrada)
Mouse Look:
  mouse_sensitivity = 0.12 graus por pixel de tela
  pitch_limit = 85 graus (limite simétrico para cima e para baixo)
  capture_mouse_on_start = true
References:
  view_pivot = Head

Configure run_speed maior que walk_speed para que Shift aumente a velocidade.
A gravidade vem de Project Settings > Physics > 3D > Default Gravity
(9.8 por padrão), lida na criação do Player. Esta etapa usa gravidade vertical.

INPUT MAP

As ações já estão configuradas em Project Settings > Input Map:
  move_forward  — W físico
  move_backward — S físico
  move_left     — A físico
  move_right    — D físico
  sprint        — Shift
  pause         — Escape

O script usa somente ações para teclas, permitindo remapeamento no editor.
O mouse usa InputEventMouseMotion.screen_relative, sem multiplicar por delta,
para não alterar a sensibilidade com FPS ou escala de renderização.

ROTEIRO DE VALIDAÇÃO MANUAL

1. Ande nas quatro direções e em diagonais: diagonais não devem ser mais rápidas.
2. Gire 90° e ande para frente: o movimento acompanha a direção horizontal.
3. Olhe para cima/baixo e ande: olhar não altera a altura nem provoca voo.
4. Segure Shift enquanto anda; solte Shift e depois WASD. Compare a mudança
   gradual da velocidade e a frenagem. Ajuste os valores no Inspector e repita.
5. Caminhe e corra contra as quatro paredes e o cubo à esquerda. Não atravesse
   os objetos; mantenha uma diagonal contra a parede para testar o deslizamento.
6. Vá até a rampa laranja à direita. Suba pelo lado próximo ao spawn, pare no
   meio e desça. Saia pela lateral elevada: deve cair até o piso sem flutuar.
7. Faça movimentos grandes do mouse: a cabeça não deve girar além do limite.
8. Use Esc enquanto corre. WASD e mouse ficam inativos, o cursor fica visível.
   Esc retoma. Repita com Alt+Tab e verifique a recuperação de foco.
9. Confira Debugger/Output: não deve haver erros de script, referências ou input.

ARQUITETURA E INTEGRAÇÃO FUTURA

A física usa _physics_process(delta) e move_and_slide(); velocidade horizontal
é interpolada como vetor, mantendo aceleração consistente nas diagonais.
Rotação horizontal ocorre no corpo e vertical apenas no Head. A cena é o módulo
reutilizável; o script pequeno divide entrada, câmera, gravidade e movimento em
métodos. Não há autoloads, buscas de nós a cada frame ou dependência do mapa.

Um futuro menu pode chamar player.set_input_enabled(false) antes de pausar a
SceneTree e player.set_input_enabled(true) depois de retomar. O menu deverá
processar durante a pausa e consumir a ação pause para evitar o toggle local.

Esc aqui é apenas um mecanismo de teste para captura/entrada, não um sistema de
pausa completo. Não foram implementados salto, agachamento, subir degraus,
inventário, interação, lanterna, áudio, inimigos ou efeitos visuais PS1.
O cenário é um espaço técnico de teste, não o mapa ou a direção de arte final.

REFERÊNCIAS DE API

https://docs.godotengine.org/en/4.4/classes/class_characterbody3d.html
https://docs.godotengine.org/en/4.4/classes/class_inputeventmousemotion.html

VALIDAÇÃO AUTOMATIZADA

Executado com Godot 4.4.1: 23 verificações aprovadas, nenhuma falha.
Importação no editor também verificada em modo headless.
Para repetir, a partir da raiz do projeto, substitua godot pelo caminho do
executável Godot disponível na sua máquina:

godot --headless --path . --editor --import --quit
godot --headless --path . --script res://tests/player_controller_test.gd

O primeiro comando importa os scripts e registra FirstPersonPlayer. O segundo
executa a física real na cena de teste e retorna código 1 se houver falhas.
A cópia portátil usada nesta sessão está em .tools/godot, ignorada pelo Git.

Os testes automatizados cobrem velocidades, limite de diagonal, frenagem,
colisões, rampa, queda, orientação, limites de pitch e ativação/desativação da
entrada. São headless: sensação do mouse, captura real do cursor, teclas físicas
e aparência precisam ser validadas manualmente com o roteiro acima.
