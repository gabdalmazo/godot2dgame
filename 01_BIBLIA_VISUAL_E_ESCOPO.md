# Bíblia Visual e Escopo do MVP

## Identidade
- **Nome de trabalho:** Vale do Sino da Aurora.
- **Gênero:** tower defense clássico 2D.
- **Câmera:** fixa, vista superior em 3/4, sem câmera isométrica estrita e sem 3D navegável.
- **Arte:** cartoon premium inspirado na qualidade de animações 3D cinematográficas familiares: volumes suaves, materiais atraentes, silhuetas memoráveis, acabamento artesanal, leitura clara de game mobile/PC. Tudo autoral e original.
- **Cores:** neve branca/azul-acinzentada; azul-ciano mágico; verde-petróleo dos pinheiros; madeira marrom-âmbar; dourado suave de luzes; roxo usado moderadamente para magia.
- **Iluminação:** inverno ao entardecer, luz ambiente fria e pontos quentes, contraste suficiente para distinguir as unidades.
- **Perspectiva:** todos os assets devem ser vistos do mesmo ângulo de cima, ligeiramente frontal, para permitir sobreposição no cenário 2D.

## Premissa
Um sino mágico preserva a aurora e protege o vale do inverno eterno. Criaturas da nevasca seguem a trilha para apagar o brilho do sino. Torres instaladas em pedestais controlam a passagem.

## Composição do mapa
- Tamanho da arte final recomendado: **2048 × 1152 px (16:9)**, ajustado para viewport do projeto em **1280 × 720 px** com escalonamento uniforme.
- Uma **trilha única contínua**, sem ramificações, largura visível aproximada de 140–160 px na arte de 2048 × 1152.
- Início pela borda esquerda, saída pela direita, dois retornos no traçado em S. Não desenhar bifurcações ou rotas alternativas.
- Até **8 pedestais circulares vazios** para torres, posicionados ao lado da trilha sem invadi-la.
- Elementos de cenário: pinheiros com neve, pedras congeladas, lago pequeno congelado, cristais luminescentes, ponte de madeira curta opcional, ruínas discretas e ao fundo a estrutura do sino da aurora.
- Zona superior mais calma para HUD; não colocar informações textuais na ilustração.
- Mapa **sem inimigos, torres prontas, interfaces, logotipo ou textos**.
- A trilha visual deve coincidir com a curva `Path2D` construída manualmente no Godot. Gerar mapa de referência e ajustar coordenadas no editor; não confiar que o gerador de imagens obedecerá coordenadas exatas.

## Rota sugerida (referência normalizada, não precisão pixel-perfect)
Em uma área 16:9, de 0 a 1 nos dois eixos:
`(0.00, 0.52) → (0.19, 0.52) → (0.19, 0.28) → (0.44, 0.28) → (0.44, 0.70) → (0.73, 0.70) → (0.73, 0.43) → (1.00, 0.43)`.

O modelo de imagem pode aproximar a geometria. **A imagem produzida é a referência; o desenvolvedor ajusta o Path2D por cima da trilha final.**

## Três torres
1. **Sentinela do Pinheiro:** madeira e pedra, telhado pontudo coberto de neve, balestra mecânica ou pequeno arqueiro no topo. Rápida, dano físico, projétil de flecha. Silhueta vertical triangular.
2. **Lança-Geada:** base de pedra com cristal ciano inclinado, runas, pequena névoa azul. Média cadência; projétil congelante e lentidão temporária. Silhueta angular cristalina.
3. **Farol Arcano:** torre de pedra cinza-violeta, minúsculo mago encapuzado na sacada ou orbe flutuante, marcas luminosas roxas/douradas. Lenta, dano em área. Silhueta arredondada com halo mágico.

## Dois monstros
1. **Gremlin do Granizo:** criatura baixa, pequenina, corpo azul-turquesa, orelhas pontudas, nariz expressivo, cachecol coral, botas grandes e mochila de neve. Veloz, pouca vida. Não parece um personagem de franquia existente.
2. **Brutamonte de Gelo:** golem simpaticamente ameaçador feito de pedras azul-escuras e placas geladas, olho ciano, ombros grandes, pernas curtas, cascalho e cristais nas costas. Lento, muita vida. Silhueta larga.

## Estilo das animações
- Sprites 2D com visual de miniaturas 3D pré-renderizadas; **não pixel-art**.
- Eixos: norte/de costas (N), sul/de frente (S), leste (E), oeste (W). Movimento conservado em cada direção.
- Para cada monstro e direção: animação de caminhada em **6 quadros**, grade de **3 colunas × 2 linhas**, sequenciados da esquerda para a direita e de cima para baixo.
- Cada célula deve ter tamanho idêntico, sem margens, sem cortes e com pivô dos pés no mesmo lugar. Não usar texto, linhas divisórias, sombras exageradas ou fundo desenhado.
- Para lançamento inicial, uma animação de morte simples pode ser feita via escala/opacidade no Godot, com sprites de partículas separados.

## Interface
- HUD no topo, limpa: vidas (coração), moedas e onda atual.
- Seleção de um pedestal abre pequeno menu contextual com ícones e preços das 3 torres.
- Botão iniciar/próxima onda, botão pausar, vitória/derrota e reiniciar.
- Ícones e molduras originais em madeira clara, gelo e cobre; legibilidade primeiro.

## Restrições do MVP
Não implementar agora: multiplayer, save online, inventário RPG, campanha com mapas múltiplos, 15 torres, árvores de habilidades, chefes, monetização ou loja interna. Esses recursos entram no backlog após o MVP funcionar de ponta a ponta.
