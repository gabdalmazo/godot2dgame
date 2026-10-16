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
