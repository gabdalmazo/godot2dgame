================================================================================
                    PROJETO TD NEON - TOWER DEFENSE 2D
================================================================================
Engine: Godot 4 (GDScript) | Render: Forward+ | Resolucao: 1024x558
Tematica: Ficcao Cientifica / Futurista Neon
Status: MVP Avancado com Ciclo Completo de Gameplay

--------------------------------------------------------------------------------
1. VISAO GERAL DO PROJETO
--------------------------------------------------------------------------------
Projeto TD Neon e um jogo de estrategia no estilo Tower Defense em 2D. O jogador 
deve defender o nucleo de sua base contra ondas crescentes de invasores ciberneticos,
gerenciando sua economia de creditos para posicionar e aprimorar torres de defesa ao
longo das rotas de invasao.

O ciclo principal (Core Loop) consiste em:
  [SOBREVIVER] Invasores percorrem rotas guiadas por Path2D em direcao a base.
  [ELIMINAR]   Torres detectam e disparam projeteis contra os inimigos em campo.
  [COLETAR]    Inimigos destruidos dropam Creditos gerenciados globalmente.
  [EXPANDIR]   Creditos sao investidos na compra e no upgrade de torres taticas.
  [ESCALAR]    Novas ondas aumentam o desafio, culminando em Miniboss e Chefes Finais.

--------------------------------------------------------------------------------
2. SISTEMAS E MECANICAS IMPLEMENTADOS
--------------------------------------------------------------------------------

[A] ARQUITETURA GLOBAL (AUTOLOADS / SINGLETONS)
  * GameManager (game_manager.gd):
    - Controle global de vida da base (inicia com 20) e creditos (inicia com 100).
    - Sinais reativos: recursos_atualizados, vida_atualizada e game_over.
    - Metodos de debito/credito com validacao rigorosa de saldo disponivel.
    - Funcoes de reset e reinicio seguro de cena.
    - Atalho de depuracao: tecla 'K' causa dano fatal imediato para teste de derrota.

  * AudioManager (AudioManager.gd):
    - Trilha sonora BGM persistente (bgm_neon.ogg) em loop com volume ambiental (-14 dB).
    - Execucao polifonica de efeitos sonoros SFX sem interrupcao de canais.
    - Captura automatica de clique: conecta feedback sonoro a qualquer BaseButton.
    - SFX dedicados: laser de tiro, impacto, explosao, dano na base e acao invalida.
    - Suporte nativo aos barramentos Master, BGM e SFX do AudioServer.
    - Configurado com PROCESS_MODE_ALWAYS para responder com o jogo pausado.

  * NotificationManager (NotificationManager.tscn / NotificationManager.gd):
    - Sistema de alertas e toasts in-game empilhados verticalmente.
    - Animacao fluida de surgimento, translacao vertical e fade-out (Tween).
    - Codificacao cromatica: Verde (construcao), Amarelo (recompensas/upgrades),
      Azul (convocacao de ondas) e Vermelho (dano a base e alertas de chefes).
    - Atalho de depuracao: tecla 'N' para disparar notificacao de teste.

[B] SISTEMA DE TORRES E CONSTRUCAO
  * TowerBuilder (TowerBuilder.gd):
    - Construcao baseada em grade (Grid) perfeitamente alinhada via map_to_local().
    - Compativel com TileMap tradicional e TileMapLayer (Godot 4.3+).
    - Bloqueio inteligente de rota: calcula e bloqueia automaticamente celulas que
      colidem com curvas de Path2D, impedindo construcao sobre a esteira inimiga.
    - Custo base: 50 creditos por torre.
    - Sistema de Aprimoramento (Upgrade Nivel 1): Clicar com Botao Esquerdo sobre uma
      torre existente realiza o upgrade por 100 creditos. Dobra o dano, eleva a
      cadencia em 25%, aumenta o raio em 10% e altera o visual para dourado/neon.
    - Sistema de Venda (Sell): Clicar com Botao Direito sobre uma torre desfaz a
      construcao e reembolsa 50% de todo o valor investido (base + upgrade).

  * Torre de Defesa (tower.gd / Tower.tscn):
    - Detecao por Area2D com raio circular parametrizavel.
    - Algoritmo de mira prioritario: seleciona o inimigo mais avancado na rota
      (maior progresso no PathFollow2D), evitando dispersao de dano.
    - Spritesheet com rotacao de mira em 8 direcoes (fatiamento de 45 graus).
    - Audio posicional 2D com variacao dinamica de pitch nos disparos.

[C] INIMIGOS, CHEFES E MINIBOSS
  * Inimigo Comum (enemy.gd / enemy.tscn):
    - Deslocamento suave guiado por PathFollow2D.
    - Rotacao de sprite em 8 direcoes calculada pelo vetor de movimento real.
    - Barra de vida visual (ProgressBar) com atualizacao em tempo real.
    - Recompensa ao ser destruido: +10 creditos.
    - Status Imutaveis por Onda: Vida e velocidade sao vinculadas estritamente a onda
      de nascimento, garantindo que acumulacao de ondas nao modifique inimigos ja vivos.

  * Miniboss Intermediario (Onda 5):
    - Surge como o ultimo invasor da Onda 5 ("Miniboss Sentinela").
    - Vida e porte elevados com alerta sonoro e visual para preparacao tatica.

  * Chefes Finais (Boss.gd / Boss.tscn - Onda 10):
    - 2 Super Chefes ("Giga Invasor Alpha" e "Giga Invasor Beta").
    - Vida massiva (800+ base escalada) e deslocamento pesado.
    - Recompensa massiva: +150 creditos ao ser abatido.
    - Condicao de Morte Subita: Se alcancar a base, causa 999 de dano (derrota fatal).

[D] BASE DO JOGADOR (PlayerBase.gd / player_base.tscn)
  * Localizada no ponto terminal da rota.
  * Inicia com 20 pontos de vida maxima.
  * Inimigos comuns causam 1 de dano e sao consumidos sem gerar recompensa financeira.
  * Spritesheet de integridade estrutural com 4 estagios visuais baseados na vida restante:
    - Nivel 1: > 75% de integridade.
    - Nivel 2: 50% a 75% de integridade.
    - Nivel 3: 25% a 50% de integridade.
    - Nivel 4: < 25% de integridade (altamente danificada).
  * Gatilho de Screen Shake e SFX ao ser atingida.

[E] GERENCIAMENTO DE ONDAS (wave_manager.gd)
  * Total de 10 ondas progressivas com escalonamento matematico:
    - Vida escalada por fator de 1.2x por onda.
    - Velocidade escalada por fator de 1.1x por onda.
    - Quantidade de inimigos: 5 + (onda - 1) * 2.
  * Suporte a rotas multiplas (Path2D superior e inferior alternados no Level 1).
  * Mecanica de Chamada Antecipada (Fast-forward tatico): O jogador pode chamar
    a proxima onda a qualquer instante, acumulando ondas simultaneas no mapa para
    acelerar o ganho de creditos e aumentar o desafio.
  * Disparo de vitoria (fase_concluida) ao eliminar o ultimo invasor da onda 10.

[F] PROJETEIS E GAME FEEL
  * Projeteis Balisticos (projectile.gd / projectile.tscn):
    - Trajetoria balistica reta em alta velocidade (400 px/s).
    - Rotacao de sprite em 8 direcoes acompanhando o angulo de disparo.
    - Destruicao com som de impacto e instanciacao de texto de dano.
  * Numeros Flutuantes de Dano (FloatingText.gd / FloatingText.tscn):
    - Exibe o valor do dano no local do impacto com translacao suave para cima e fade.
  * Camera Shake (CameraShake.gd):
    - Tremor de tela puramente matematico aplicando perturbacao no offset da Camera2D.
    - Decaimento exponencial suave via interpolacao linear (lerp).
  * Shader Color Key (color_key.gdshader):
    - Remocao ou recoloracao de cores de fundo para sprites pixel art.

[G] INTERFACES DE USUARIO (UI) E MENUS COMPLETOS
  * Menu Principal (MainMenu.tscn / MainMenu.gd):
    - Botoes para Iniciar o Jogo, acessar Opcoes de Audio e Sair do aplicativo.
  * Selecao de Niveis (LevelSelect.tscn / LevelSelect.gd):
    - Navegacao de fases com reinicializacao limpa do estado economico.
  * HUD de Partida (HUD.tscn / HUD.gd):
    - Contadores de Vida e Creditos sincronizados com sinais do GameManager.
    - Botao "Chamar Onda (X/10)" com debounce anti-duplo clique e status da onda.
  * Menu de Pausa (PauseMenu.tscn / PauseMenu.gd):
    - Acionado via tecla ESC (ui_cancel), congela o cenario sem travar botoes.
    - Opcoes: Retomar, Ajustar Audio (submenu integrado) e Sair para o Menu.
  * Menu de Opcoes (OptionsMenu.tscn / OptionsMenu.gd):
    - Controles de volume com sliders lineares convertidos para decibeis no AudioServer.
    - Canais: Master, BGM (Musica) e SFX (Efeitos), com mute automatico no zero.
  * Modal de Derrota (game_over_modal.tscn / game_over_modal.gd):
    - Jingle de Game Over e botao para reiniciar a partida instantaneamente.
  * Modal de Vitoria (LevelComplete.tscn / LevelComplete.gd):
    - Jingle triunfal de vitoria ao superar a onda 10 e retorno a selecao de fases.

--------------------------------------------------------------------------------
3. CONTROLES E ATALHOS DO JOGO
--------------------------------------------------------------------------------
  * Botao Esquerdo do Mouse (LMB):
    - Clicar no cenario vazio: Constroi uma torre na grade (Custo: 50 creditos).
    - Clicar sobre uma torre existente: Aplica Upgrade (Custo: 100 creditos).
    - Clicar no botao do HUD: Inicia / Convocacao antecipada da proxima onda.
  * Botao Direito do Mouse (RMB):
    - Clicar sobre uma torre: Vende a torre com reembolso de 50% dos creditos.
  * Tecla ESC:
    - Abre ou fecha o Menu de Pausa da partida.
  * Tecla K (Debug / Testes):
    - Causa dano fatal imediato na base para testar o modal de Game Over.
  * Tecla N (Debug / Testes):
    - Dispara uma notificacao in-game de teste na interface.
  * Tecla Espaco (Debug / Testes):
    - Causa 20 de dano manual ao primeiro inimigo em teste.

--------------------------------------------------------------------------------
4. MAPAS E CENARIOS DISPONIVEIS
--------------------------------------------------------------------------------
  * Level_1.tscn:
    - Fase oficial de introducao com duas entradas de invasores (caminho superior
      e inferior) que convergem ate a base centralizada a direita.
    - TileMap estruturado com camadas de construcao e fundo sci-fi.
    - Câmera configurada com CameraShake e todos os CanvasLayers integrados.
  * test_level.tscn:
    - Arena de testes de mecanicas isoladas, prototipagem de torres e ondas.

--------------------------------------------------------------------------------
5. ESTRUTURA DO PROJETO
--------------------------------------------------------------------------------
  /
  |-- GDD.md                          # Game Design Document original
  |-- README.TXT                      # Este documento descritivo
  |-- novo-projeto-de-jogo/
      |-- project.godot               # Configuracoes gerais do motor Godot 4.7
      |-- game_manager.gd             # Autoload singleton da economia e vida
      |-- AudioManager.gd             # Autoload singleton de audio e musica
      |-- NotificationManager.gd/tscn # Autoload singleton de toasts in-game
      |-- TowerBuilder.gd             # Gerenciador de construcao, upgrade e venda
      |-- tower.gd / Tower.tscn       # Torre de defesa automatica
      |-- projectile.gd/.tscn         # Disparo balistico em 8 direcoes
      |-- enemy.gd / enemy.tscn       # Inimigo base e controle de rota
      |-- Boss.gd / Boss.tscn         # Chefe massivo e condicoes especiais
      |-- wave_manager.gd             # Gerenciador das 10 ondas e progressao
      |-- PlayerBase.gd / player_base.tscn # Nucleo da base e estagios de dano
      |-- CameraShake.gd              # Game feel de impacto e tremor
      |-- FloatingText.gd/.tscn       # Numeros de dano flutuante no impacto
      |-- color_key.gdshader          # Shader para tratamento de sprites
      |-- MainMenu.gd/.tscn           # Menu principal
      |-- LevelSelect.gd/.tscn        # Tela de selecao de fases
      |-- OptionsMenu.gd/.tscn        # Menu de ajuste de volumes de audio
      |-- PauseMenu.gd/.tscn          # Menu de pausa in-game (ESC)
      |-- HUD.gd/.tscn                # Interface de jogo com status e onda
      |-- game_over_modal.gd/.tscn    # Modal de derrota da partida
      |-- LevelComplete.gd/.tscn      # Modal de vitoria da fase
      |-- Level_1.tscn                # Fase oficial com rotas duplas
      |-- test_level.tscn             # Cenario de testes tecnicos
      |-- assets/                     # Sprites, texturas, trilha sonora e SFX

--------------------------------------------------------------------------------
6. COMO EXECUTAR O PROJETO
--------------------------------------------------------------------------------
  1. Abra o Godot Engine (versao 4.3 ou superior / testado em 4.7).
  2. Clique em "Importar" e aponte para o arquivo 'novo-projeto-de-jogo/project.godot'.
  3. Pressione F5 para executar o jogo a partir da cena inicial (MainMenu.tscn),
     ou abra 'Level_1.tscn' e pressione F6 para testar a primeira fase diretamente.
================================================================================
