# Prompts prontos — Nano Banana 2

## Fluxo obrigatório de consistência
1. Envie o **Prompt 0** com as imagens de referência do usuário. Use o resultado como imagem-guia da identidade visual.
2. Gere a arte-base de mapa com o Prompt 1; escolha **uma versão final**, não misture mapas de geometria diferente.
3. Gere cada uma das três torres separadamente, enviando como referência a imagem-guia, o mapa e a última torre aprovada.
4. Gere **uma imagem-mestre para cada monstro** e use sempre a mesma imagem de referência nas animações.
5. Para cada monstro, gere 4 spritesheets de caminhada: S, N, E e W (total **8 spritesheets**). Não peça quatro direções no mesmo pedido se a ferramenta errar a consistência.
6. Gere projéteis/efeitos e ícones em arquivos separados. Inspecione a transparência verdadeira e os recortes de cada quadro.

### Prompt 0 — Bíblia visual (folha de estilo)
> Estou desenvolvendo um tower defense 2D autoral chamado "Vale do Sino da Aurora". Analise as imagens de referência anexadas apenas para extrair qualidades visuais gerais — composição clara de tower defense, caminhos em curvas, arquitetura de fantasia e clima nevado — sem copiar personagens, objetos ou cenários específicos. Crie uma folha de DIREÇÃO DE ARTE para um jogo 2D de câmera fixa em ângulo superior 3/4, como se os elementos tivessem sido esculpidos para uma animação 3D cinematográfica familiar premium e depois pré-renderizados para sprites 2D. Deve parecer um universo novo: neve branco-azulada, pinheiros verde-petróleo, cristais ciano, pedra cinza, madeira âmbar, magia violeta e luz dourada. Volumes suaves, materiais ricos, acabamento lúdico, bordas limpas, silhuetas fortes, leitura excelente em tamanho pequeno. Apresente apenas amostras de paleta, materiais, formatos de pinheiros, pedras, piso, arquitetura, magia, 3 pequenas torres e 2 monstros ORIGINAIS coerentes entre si. Perspectiva rigorosamente consistente, nunca isométrica exagerada, sem interface, sem logotipos, sem marcas d'água. Arte de pré-produção para jogo, não uma captura de jogo existente.

### Prompt 1 — Mapa final, cenário base (2048×1152, 16:9)
> Gere um ÚNICO MAPA CENOGRÁFICO 2D de tower defense original para "Vale do Sino da Aurora", proporção EXATA 16:9, resolução-alvo 2048×1152, câmera fixa em perspectiva superior 3/4, totalmente ortográfica, sem horizonte nem perspectiva profunda de câmera 3D. Visual de animação 3D cinematográfica familiar, mas resultado destinado a jogo 2D com sprites sobrepostos. Local: vale encantado de inverno ao entardecer, solo coberto de neve fofa azulada, pinheiros densos nas margens, lago congelado pequeno, poucos cristais luminosos ciano e fragmentos de ruínas de pedra. Um sino antigo mágico de luz azul está protegido em uma estrutura pequena perto da BORDA DIREITA; é a saída da fase. A trilha única de terra clara e neve pisada ENTRA pela BORDA ESQUERDA e SAI pela BORDA DIREITA, fazendo curvas bem largas em forma de S: entra a meia altura, segue à direita, curva para cima, segue à direita, curva para baixo, segue à direita, curva para cima e segue à saída. Caminho único, contínuo, com largura constante de aproximadamente 7 vezes a largura de um inimigo pequeno, sem bifurcações, pontes sobrepostas, árvores, pedras ou objetos obstruindo a trilha. Inclua 8 plataformas circulares de pedra coberta de neve, VAZIAS, ao lado da trilha, para colocar torres posteriormente; não desenhar torres. Cada plataforma deve ser claramente distinguível e acessível visualmente, nunca invadir a trilha. O mapa deve ser elegante, excepcionalmente legível e original, com espaço livre na faixa superior para HUD. Iluminação suave fria e pontos quentes de lanternas. Paleta branco-gelo, azul, verde-petróleo e madeira dourada. SEM personagens, SEM monstros, SEM torres, SEM texto, SEM botões, SEM interface, SEM marcadores de caminho, SEM grade, SEM marca d'água. A imagem inteira é o cenário de FUNDO sobre o qual o Godot colocará as entidades móveis.

**Nota técnica:** a IA pode não seguir curvas/medidas com exatidão. Escolha o mapa visualmente melhor e desenhe o `Path2D` no Godot correspondendo à trilha efetivamente renderizada. A arte é só a camada visual; não é um navmesh ou collision map.

### Prompt 2 — Variante da mesma arte para auditoria do traçado
> Use como REFERÊNCIA IMUTÁVEL a imagem final do mapa anexada. NÃO redesenhe nem desloque a trilha, árvores, plataformas, rochas ou estruturas. Produza uma cópia de referência para desenvolvimento com LINHA CENTRAL visível e fina acompanhando rigorosamente todo o caminho desde a entrada à esquerda até a saída à direita. Numere os 8 pedestais de torre de 1 a 8 por cima da imagem. Marque entrada e saída com setas discretas. Este arquivo é um GUIA TÉCNICO, não deve entrar como cenário no jogo. Preserve a mesma proporção, enquadramento e composição do mapa-base. Não adicione nem remova conteúdo do cenário.

**Se o Nano Banana deformar a arte:** NÃO usar esse guia. O Codex deve sobrepor caminho e pedestais diretamente no editor do Godot ou produzir guia programaticamente com coordenadas.

### Prompt 3A — Sentinela do Pinheiro, torre de flechas
> Crie UM ÚNICO ASSET de torre de defesa original para um jogo 2D de fantasia nevada. Nome conceitual "Sentinela do Pinheiro": torre alta e charmosa de madeira escura reforçada com pedra, telhado íngreme coberto de neve, pequena balestra dourada no topo, bandeirinha azul-petróleo, detalhes em couro e cobre, base de pedra circular. Silhueta TRIANGULAR, fácil de reconhecer em tamanho pequeno, sem se parecer com torres de jogos existentes. Câmera superior em 3/4 idêntica à imagem-guia anexada, render de qualidade de animação 3D cinematográfica familiar, acabamento limpo e volumes suaves. ÚNICO objeto CENTRALIZADO, inteiro dentro do quadro, sem chão nem cenário, fundo TOTALMENTE TRANSPARENTE PNG alfa, uma única versão, sem sombras projetadas grandes, sem UI, texto, bordas, marcas d'água ou outras unidades. O pé da torre deve estar centrado horizontalmente e perto da base da imagem. Alvo: imagem quadrada alta resolução para reduzir depois a sprite.

### Prompt 3B — Lança-Geada, torre congelante
> Crie UM ÚNICO ASSET de torre de defesa 2D autoral chamada "Lança-Geada". Uma construção curta de pedra ancestral com um cristal pontiagudo azul-ciano inclinado no alto, runas delicadas, argolas metálicas prateadas, cobertura de neve e pequena névoa fria sutil. Silhueta ANGULAR e claramente diferente de uma torre de madeira. Estilo e câmera iguais à folha de estilo anexada: vista superior 3/4 ortográfica, cartoon premium de animação 3D cinematográfica familiar renderizado como sprite. Base circular, ponto de apoio coerente, inteiro no quadro. Apenas torre, centralizada, fundo PNG TRANSPARENTE REAL, sem paisagem, sem inimigos, sem texto, sem interface, sem bordas nem marca d'água. O cristal deve ser bem visível mesmo quando reduzido.

### Prompt 3C — Farol Arcano, torre mágica
> Crie UM ÚNICO ASSET de torre mágica 2D original chamada "Farol Arcano". Torre arredondada de pedra cinza-violeta, sacada pequena com UM MAGO original encapuzado de rosto não visível, grande orbe violeta flutuante rodeado por fino aro dourado e partículas sutis, um pouco de neve no topo. Silhueta REDONDA e mística, muito diferente da Sentinela do Pinheiro e da Lança-Geada. Mesma câmera superior 3/4 e mesmos materiais/iluminação da referência anexada. Qualidade de animação 3D cinematográfica familiar, sprite pré-renderizado 2D. Apenas torre isolada em PNG com TRANSPARÊNCIA REAL, inteira dentro do quadro, centralizada, base circular, sem cenário, sem UI, sem palavras, sem emblemas de outras franquias ou marca d'água.

### Prompt 4A — Monstro-mestre: Gremlin do Granizo
> Crie o PERSONAGEM-MESTRE para animação 2D de tower defense, monstro original chamado "Gremlin do Granizo". Criatura pequena e travessa da neve, corpo azul-turquesa, orelhas pontudas assimétricas, nariz arredondado expressivo, olhos âmbar, cachecol vermelho-coral, botas desproporcionais e mochila pequena de bolas de neve. Expressão determinada, não grotesca; silhueta muito reconhecível. Uma criatura inteira, cabeça a pés, em postura neutra de caminhada, câmera superior em 3/4 compatível com nosso mapa e torres anexados. Visual de filme de animação 3D familiar premium pré-renderizado como personagem 2D, texturas suaves, excelente leitura em miniatura. UM personagem, centralizado, sem chão, cenário ou objetos extras, fundo PNG TRANSPARENTE REAL, sem letras, interface ou marca d'água. Esta imagem é a REFERÊNCIA OFICIAL DE IDENTIDADE para todas as futuras animações: não alterar rosto, roupas, proporções ou paleta.

### Prompt 4B — Monstro-mestre: Brutamonte de Gelo
> Crie o PERSONAGEM-MESTRE para animação 2D de tower defense, monstro original chamado "Brutamonte de Gelo". Golem robusto de rochas azul-acinzentadas, gelo leitoso, cristais ciano brotando nos ombros e costas, dois olhos luminosos ciano, sobrancelhas de pedra e braços grandes; pernas curtas e passadas pesadas. Silhueta larga, memorável, visual de criatura resistente, sem copiar monstros de franquias existentes. Vista superior 3/4 idêntica aos assets de referência anexados. Render de animação 3D cinematográfica familiar, mas asset usado como sprite 2D. Corpo inteiro centralizado, no mesmo piso imaginário e sem elementos externos. Fundo PNG TRANSPARENTE REAL, sem cenário, sem texto, sem borda e sem marca d'água. Esta é a REFERÊNCIA IMUTÁVEL para todas as animações do golem, com rosto, cores, cristais e proporções constantes.

### Prompt 5 — Spritesheet de caminhada (repetir 8 vezes)
**Preencher:** MONSTRO = `Gremlin do Granizo` ou `Brutamonte de Gelo`; DIREÇÃO = `SUL (visto parcialmente de frente)` / `NORTE (visto parcialmente de costas)` / `LESTE (virado à direita)` / `OESTE (virado à esquerda)`.

> Usando a imagem anexada como REFERÊNCIA OBRIGATÓRIA E EXATA do personagem, crie UM spritesheet de animação de caminhada para [MONSTRO], movendo-se na direção [DIREÇÃO] de um jogo tower defense 2D em perspectiva superior 3/4. GRADE PERFEITA com 3 COLUNAS × 2 LINHAS: SEIS quadros em ordem temporal, lendo linha superior da esquerda para a direita e depois linha inferior da esquerda para a direita. Movimento em ciclo contínuo, passo esquerdo → apoio → passo direito → apoio, balanço corporal sutil, cabeça e aparência rigorosamente estáveis. SOMENTE UM personagem por célula e o MESMO personagem em todos os quadros: identidade, roupa, acessórios, iluminação, câmera, escala e proporção imutáveis. CADA CÉLULA quadrada, exatamente do mesmo tamanho, sem margem externa e sem espaço entre células. Os PÉS devem manter o mesmo ponto de ancoragem horizontal e vertical em cada quadro; todo o personagem cabe na célula, nada cortado. As seis poses precisam ser diferentes mas coerentes, nenhuma pose inventando membros. Fundo PNG TRANSPARENTE REAL em TODAS as células. Nenhum cenário, sombra projetada fora da célula, texto, separador, borda, números, interface ou marca d'água. Visual de animação 3D cinematográfica familiar renderizada para sprites 2D, ângulo superior 3/4 igual à referência. Fonte grande o suficiente para reduzir no Godot.

**Nomes de arquivos:**
- `mob_gremlin_walk_s.png`, `mob_gremlin_walk_n.png`, `mob_gremlin_walk_e.png`, `mob_gremlin_walk_w.png`
- `mob_golem_walk_s.png`, `mob_golem_walk_n.png`, `mob_golem_walk_e.png`, `mob_golem_walk_w.png`

**Importante:** quando o modelo confundir 6 quadros, gerar 1 pose por vez usando a imagem-mestre e depois montar o spritesheet **fora da IA**, em Aseprite/Krita/GIMP/Python. É preferível consistência real a um spritesheet bonito mas inutilizável. Uma única imagem com 6 poses não equivale automaticamente a uma animação pronta: cada célula precisa estar correta.

### Prompt 6 — Projéteis e partículas
> Gere uma folha de assets 2D originais do MESMO universo de fantasia de inverno, itens isolados com fundo PNG transparente real: (1) flecha curta com ponta dourada, (2) pequeno dardo de gelo luminoso ciano, (3) esfera de magia violeta, (4) faíscas de impacto de madeira, (5) impacto circular de cristais de gelo, (6) pequena explosão arcana violeta, (7) fragmentos de neve. Cada item separado, centralizado dentro de uma célula de uma grade 4×2, sem sobreposição, com bastante espaço de segurança, traço visual consistente, legibilidade em tamanho pequeno, luz e perspectiva coerentes com as torres já anexadas. Não desenhar texto, números, fundo, quadriculado, bordas ou marca d'água. Não gerar animação nessa etapa: são formas estáticas para efeitos animados via Godot.

### Prompt 7 — Interface e ícones
> Crie um conjunto de elementos visuais originais e coesos de HUD para nosso tower defense 2D nevado "Vale do Sino da Aurora": ícone de coração de vida em vermelho-coral, moeda dourada com símbolo abstrato de floco, símbolo de onda em forma de bandeirola azul, botão circular de início de onda, botão de pausa, moldura contextual de compra e três ícones minúsculos das torres nas silhuetas de madeira triangular, cristal de gelo e magia redonda. Estética premium de fantasia animada, madeira âmbar, gelo azul e cobre, leve relevo, ótima legibilidade sobre neve, contornos discretos. Organize os itens NÃO SOBREPOSTOS e separados em uma folha para recorte. Fundo TRANSPARENTE real, sem telas completas, sem letras nem números; estes serão textos nativos do Godot. Sem logotipos nem marca d'água.

### Prompt 8 — Decorações avulsas (opcional, recomendado após primeira versão)
> Gere 8 props ambientais separados, em uma folha organizada para recorte, na identidade visual de "Vale do Sino da Aurora": pinheiro grande com neve, pinheiro pequeno, rocha gelada, cristal ciano, poste de lanterna amarela, tronco caído, pequeno altar de pedra com neve e arbusto nevado. Vista superior 3/4 consistente com o mapa anexado, proporções adequadas para o cenário, sprites 2D pré-renderizados com acabamento de animação 3D cinematográfica familiar. Cada prop isolado, inteiro e com muito espaço entre si, fundo transparente real; sem solo, sem caminho, sem sombras externas grandes, sem texto, sem interface ou marca d'água.

## Organização recomendada dos arquivos do jogo
Coloque os arquivos produzidos dentro da pasta do **projeto Godot real**, conservando estes caminhos relativos quando possível:

```text
res://assets/
  backgrounds/
    level_01_snow.png
    level_01_path_guide.png       # Somente referência; não aparece no build
  towers/
    tower_pine.png
    tower_frost.png
    tower_arcane.png
  enemies/
    gremlin/master.png
    gremlin/walk_s.png
    gremlin/walk_n.png
    gremlin/walk_e.png
    gremlin/walk_w.png
    golem/master.png
    golem/walk_s.png
    golem/walk_n.png
    golem/walk_e.png
    golem/walk_w.png
  effects/
    projectiles.png
    hit_fx.png
  ui/
    ui_icons.png
  environment/
    props.png
```

Regra: estes são **caminhos sugeridos, não fatos sobre seu disco**. Se os arquivos estiverem em outra pasta, descreva o caminho real ao Codex. Para spritesheets, verifique dimensões divisíveis por 3 e 2; no Godot use `AnimatedSprite2D` com `SpriteFrames` e defina o alinhamento do pivô dos pés. Não dependa de transparência falsa branca/cinza: inspecione o canal alfa.
