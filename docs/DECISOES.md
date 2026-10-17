# Decisões

## 2026-10-15 — Migração para tower defense
Solicitação atual substitui o escopo metroidvania e a regra local antiga de manter FPS.
Preservadas convenções úteis: 2D, GDScript legível/tipado, referências cacheadas, sinais, mudanças verificáveis e documentação factual.
MVP: uma fase nevada, um caminho manual, oito posições, três torres, dois monstros, cinco ondas, moedas, vidas, HUD, pausa, reinício e resultados. Implementação fora desta tarefa.

## Uma única raiz Godot
Manter game-inicial/ como projeto ativo, conforme contexto histórico. Remover o projeto FPS duplicado da raiz após backup. Alternativa de mover o ativo à raiz rejeitada para evitar migração desnecessária de caminhos.
Documentos de controle em docs/ na raiz do repositório; histórico em game-inicial/docs preservado e sinalizado.

## Base neutra e configuração
Cena Node2D + CanvasLayer/Control provisória, sem scripts ou recursos externos de gameplay.
Viewport 1280×720, canvas_items/keep, Compatibility conforme direção TD.
Feature 4.4 indica o mínimo escolhido para recursos simples existentes, não comprova engine instalada. Nenhum upgrade/downgrade de executável ou plugin executado.
Removidos InputMap de movimento, camadas antigas e configurações 3D sem uso. Criar controles TD quando houver funcionalidades correspondentes.

## Descarte e recuperação
Backup externo integral de 62 arquivos de trabalho validado por SHA-256 antes das mudanças, incluindo conteúdo não rastreado. Sem commit automático para não incorporar documentos/imagens do usuário ao histórico sem necessidade.
19 arquivos exclusivos FPS/plataforma removidos com matriz e inventário prévios. Diretórios vazios não removidos recursivamente.
Placeholder SVG original preservado mesmo órfão. Imagens candidatas mantidas fora do projeto até inspeção de licença, transparência, grade, frames e pivô.
JPEG não suporta canal alfa: as caminhadas em JPEG não estão prontas como sprites transparentes. Não foi realizada inspeção visual ou validação de animação nesta tarefa.

## 2026-10-15 — Etapa 2: protótipo com teste manual pelo usuário
O pedido atual autoriza o loop TD completo e atribui a execução Godot ao usuário. Não buscar nem instalar engine. Usar a base Godot 4.4/Compatibility existente, sem addons. Resultado é código preparado e revisado estaticamente, não runtime comprovado.

## Rota superior e sete bases
A linha vermelha de mapa_rotas é a referência da rota única. O ramo inferior continua apenas na arte. Sete plataformas circulares válidas, preservando IDs 1, 2, 4, 5, 6, 7, 8; posição 3 rejeitada por estar sobre rochas, conforme exceção expressamente autorizada nesta etapa.
Mapa, curva, torres, inimigos e projéteis compartilham World em escala 1,25 e Y=2,5; coordenadas de origem 1024×572. HUD usa 1280×720.
A amostragem geométrica detectou ausência de cobertura de flecha/gelo na base 6 com alcances 145/160. Ajustados alcances para 180/195/210; todos atingem a rota de todas as bases. Balanceamento requer teste humano.

## Arte original preservada e placeholders
Auditoria integral dos pixels encontrou alfa 255 em todas as 18 imagens. Até PNGs com canal alfa têm quadriculado incorporado. Gremlin oeste contém golem; folhas norte/sul não correspondem à orientação esperada. Não remover fundo por limiar de cor nem recortar folhas inválidas.
Somente mapa.png foi copiado para o projeto; mapa_rotas e artes rejeitadas ficam fora de runtime. Origem informada: Nano Banana 2/IA, uso no protótipo autorizado pelo usuário.
Personagens e torres usam formas nativas, animação procedural, direção e silhuetas distintas. SpriteFrames/Texture2D opcionais nos Resources permitem substituição posterior. Espelhamento leste do golem preparado, sem alegar folha oeste validada.

## Arquitetura e ciclo de vida
Resources separados para torres, inimigos e ondas. Nível centraliza economia/vidas/estados, HUD e sistemas se comunicam por sinais. Compras são síncronas e reservam base antes de adicionar a torre.
Inimigos resolvem morte/escape uma única vez. Ondas só encerram depois do spawn completo e registro ativo vazio. Projéteis validam alvo antes de dano; área não soma dano direto. Lentidão usa menor multiplicador e maior duração restante, sem multiplicação de aplicações.
Raiz/HUD processam sempre; World e Waves explicitamente pausáveis. Reinício despausa antes de recarregar. Sem corrotinas de spawn sobrevivendo ao reinício.

## 2026-10-15 — Etapa 3: arte derivada e preservação do gameplay

O usuário confirmou manualmente a base jogável da etapa 2. A configuração recebida já declara Godot 4.7/Compatibility e foi mantida; não houve atualização do engine. O pedido atual limita a intervenção à apresentação visual.

Adotadas nove cópias RGBA derivadas com image_gen integrado, preservando originais e documentando prompts. Extração por limiar de cores foi evitada para não remover neve, olhos e brilhos. A geração é não determinística e pode alterar detalhes; a instalação dos resultados aprovados é determinística e não modifica pixels. Escolhido preservar os PNGs aprovados integralmente nesta etapa, com tamanho de importação/otimização para revisão posterior.

Torres e projéteis usam Sprite2D; monstros usam sprite estático com transformação procedural exclusiva do filho. Essa escolha entrega os personagens corretos sem depender de folhas inválidas. SpriteFrames permanece opcional, com preferência explícita; nomes/contagens não comprovam qualidade artística. Pivô nos pés, barras por altura e profundidade absoluta por Y permitem sobreposição entre atores em pais diferentes.

Texturas opcionais são caminhos exportados em Resources, carregadas sob demanda com checagem e cache compartilhado. Assim, ausência de PNG não cria ExtResource obrigatório que impeça carregar o dado de gameplay. Mantidos desenhos anteriores como fallback; falhas geram aviso. Ao corrigir arquivo após uma falha, reexecutar F5 para renovar o cache. Em futura exportação com filtro de recursos selecionados, incluir explicitamente assets/processed, pois referências por string não são dependências obrigatórias.

Preservados mapa, rota, sete bases, preços, dano, alcance, cadência, velocidades, ondas, resolução de inimigos e estados. Origem e mira dos disparos também mantidas para preservar o tempo de viagem. Só a nota da HUD mudou. Impactos de flecha/gelo permanecem nativos; decoração e ícones do atlas ficam pendentes, mantendo legibilidade.

Cópia dos arquivos ativos em `.tools/etapa3_baseline` e inventário SHA-256 antes das alterações. Contrato estático derivado dessa cópia compara funções de gameplay e dados; não equivale a parser/importação ou teste de runtime. Nenhuma exclusão, commit, staging ou instalação feita.

## 2026-10-16 — Retomada e fechamento estático da etapa 3

Retomada sem refazer as imagens. O repositório já estava limpo no commit `25fb4eb`, criado entre as interações; o backup inicial e os inventários permanecem disponíveis. Confirmados os nove PNGs e seus `.import`, a ligação cena → Resource → caminho visual → carregador, o fallback e a composição sobre o mapa. A existência de `.import` é evidência de metadados, não de execução do gameplay.

Reexecutadas auditorias dos 18 originais, das nove derivadas e dos caminhos/cenas, além do contrato comparado com o início da etapa. As contagens gerais passaram de 359/58 para 368/67 porque os nove arquivos `.import` acrescentaram referências examinadas; a checagem de preservação passou de 168 para 177 ao conferir também os nove hashes dos PNGs aprovados. Zero erros. Nenhuma nova geração, mudança de lógica, exclusão ou commit nesta retomada. A validação de runtime continua atribuída ao usuário, conforme pedido.

## 2026-10-16 — Etapa 4: caminhada, HUD, áudio e Sino da Aurora

O usuário testou a integração visual da etapa 3 no Godot: personagens corretos aparecem, ataques/efeitos melhoraram e o loop base está satisfatório. A caminhada parecia salto e a HUD pesada. O trabalho atual se limita à apresentação e a uma habilidade ativa pequena.

A caminhada continua sobre PathFollow2D com velocidade e colisão originais. Somente o Sprite2D filho recebe deslocamento senoidal vertical de até 0,35 px no gremlin e 0,18 px no golem, balanço lateral, deformação máxima de 0,4%/0,2% e inclinação discreta. Parâmetros exportados nos TDEnemyData permitem ajuste futuro. A antiga elevação por valor absoluto do seno foi removida. Golem tem frequência mais baixa para parecer mais pesado.

A HUD foi reorganizada sem mudar seus sinais de compra/onda/pausa/reinício: barra superior fina, contador separado, toast temporário, painel contextual estreito e botão do Sino no rodapé. Estilo construído com Theme/StyleBoxFlat nativos, sem baixar fonte ou atlas. O painel raiz ignora clique, mantendo as bases acessíveis; botões, menu e overlay conservam foco visível.

Escolhidos 13 efeitos WAV mono 16-bit/22.050 Hz sintetizados por `tools/generate_proto_audio.py`, sem conteúdo externo. `AuroraAudio` carrega os cues uma vez, usa oito players para sobreposição, volume por evento e limita disparos/impactos muito próximos. Falha de áudio avisa e não bloqueia gameplay. Música não foi produzida: o nó possui `music_stream` opcional e repete a futura trilha ao terminar. O som de pausa serve também ao retorno.

Sino da Aurora: acionável somente durante onda com ao menos um inimigo e cooldown zerado. Aplica a lentidão já existente ×0,55 por 3 s aos inimigos ativos, sem dano ou moedas; recarga 24 s. A contagem pausa junto com a partida e é exibida no botão. Um anel parte da localização do sino no mapa, com efeito imediato nos inimigos para resposta clara. A regra usa `apply_slow`, que já evita empilhamento multiplicativo. Os atributos das torres, recursos de onda, economia, rota e quantidade de bases não foram alterados.

Verificação estática adicional compara Resources, mapa, rota e ondas com o commit anterior à etapa e confere os WAVs byte a byte com o gerador. O validador geral ignora apenas o molde dinâmico de caminho WAV (`%s`); o verificador específico resolve todos os treze caminhos. Nenhum desses testes equivale a runtime Godot, conforme pedido do usuário.

## 2026-10-17 — Etapa 5: HUD artística baseada em `hud_nova.jpg`

A referência indicada inicialmente como `hub_nova.png` foi entregue pelo usuário como `img/hud_nova.jpg` (1024×572 RGB). Ela mostra a HUD fundida ao mapa, com números/textos incorporados e nenhum canal alfa. Recortes das placas trariam fundo, rótulos ou bordas contaminadas; portanto, nenhum pixel da referência foi importado ao projeto.

Recriar a composição em Controls Godot: placa de título, mostradores de coração/moeda, estandarte azul, pausa ornamentada, painel de construção em madeira, cartões azulados, botão de onda verde, rodapé e sobreposição de resultados. StyleBoxFlat, anchors/containers e quatro SVGs vetoriais autorais simples fornecem madeira/bronze/neve/coração/moeda/engrenagem/sino. A fidelidade ao relevo 3D e à neve irregular é limitada sem um atlas limpo transparente; solicitar assets isolados ao Nano Banana 2 caso seja prioridade após teste visual.

O menu usa os `texture_path` dos três `TDTowerData` e `AuroraVisualAssets` existente, com preço, descrição e habilitação derivados dos dados e do saldo reais. O novo script mantém os sinais e métodos chamados por `level.gd`; nenhuma regra de economia, onda, pausa, áudio ou habilidade foi modificada. Entrada e hover usam tweens curtos; saldo/vida recebem pulso de cor; cooldown aparece em ProgressBar. O estado da base ocupada remove as opções de compra e reduz a altura do painel.

Cópias exatas da cena e do script da HUD da Etapa 4 foram feitas em `.tools/etapa5_baseline/` antes da substituição. A pasta é ignorada pelo Git, mas recuperável no workspace. Verificação estática não prova importação/renderização/cliques no Godot; o usuário fará o teste manual solicitado.

## 2026-10-17 — Etapa 6: progressão estendida sem perder a fase original

Não há segunda arte de mapa pronta. A nova `aurora_level_extended.tscn` reutiliza o mapa nevado e traça manualmente a Curve2D pelo ramo inferior já pintado, em vez de desenhar estrada fora da imagem ou duplicar o mapa. Comprimento amostrado: 1.193,76 px versus 1.132,17 px (+5,4%). Uma oitava base procedural fica na ilha central. A duração cresce sobretudo com sete ondas; a cena original permanece byte a byte intacta como fallback. `project.godot` aponta F5 para a cena estendida, e a original pode ser aberta com F6. Um mapa novo maior fica para produção futura.

`TDWaveData` guarda multiplicadores de vida/velocidade da onda (padrão 1,0, preservando a fase original) e `boss_scene` opcional. O gerenciador intercala o apoio e enfileira o boss no fim; o nível configura escalas por instância antes de adicioná-la à árvore. A vitória mantém a condição de spawn encerrado, nenhum inimigo ativo e vidas positivas. A última onda tem 16 gremlins, 10 golens e o Regente da Geada, com menos corpos que a sexta, mas maior ameaça por causa do boss.

O boss usa `TDEnemyData` separado, 700 PV, velocidade 19 px/s, armadura de 15%, piso de lentidão 0,75, recompensa 120 e escape de 5 vidas. O desenho procedural de gigante/cristal é placeholder explícito; nenhuma arte nova de boss foi presumida. A barra de vida e a silhueta diferem dos outros inimigos. A HUD troca temporariamente o rótulo para CHEFE e exibe toast ao iniciar a onda 7.

Cada Resource de torre nível 1 aponta para seu Resource nível 2, que aponta para o nível 3. Os Resources de upgrade contêm stats/custo/texture_path completos; a torre troca o Resource de dados, sem duplicar lógica de ataque. Projéteis já disparados conservam o Resource anterior, evitando mudar dano em voo. O nível valida saldo/seleção e debita apenas após `upgrade_to` aceitar a transição. Enquanto faltam sprites específicos, cada nível usa o PNG atual com leve escala/cor/anéis; basta trocar o caminho visual do Resource quando a arte transparente chegar.

A construção final está incorporada ao bitmap do mapa e não pode ser alterada pixel a pixel sem nova arte. `FinalBase` desenha sobre ela um emblema/rachaduras em cinco faixas de vida; é fallback visual não destrutivo, conectado às perdas de vida na cena estendida. O tooltip de status informa a condição.

Uma trilha instrumental provisória de 16 s é sintetizada localmente em `tools/generate_aurora_music.py` (WAV PCM mono 22.050 Hz), sem mídia externa. `AuroraAudio` usa loop nativo do AudioStreamWAV quando disponível e mantém o callback `finished` como fallback; `music_volume_db` e `sfx_volume_db` são ajustes separados. A música pausa quando o jogador pausa. O volume final e a transição do loop dependem de escuta no Godot.

Antes das alterações, os scripts/cenas/Resources afetados foram copiados para `.tools/etapa6_baseline/`, preservando o trabalho não commitado das etapas anteriores. Não houve exclusões ou atualização do engine. Validadores históricos foram ajustados apenas para reconhecer a nova cena principal e o novo boss sem perder as comparações da fase original.
