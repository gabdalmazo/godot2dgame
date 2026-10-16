# GDD — Vale do Sino da Aurora (v0.1)

## Resumo
Tower defense clássico, câmera 2D fixa 3/4, cenário de neve e fantasia, defesa de sino mágico. Jogador constrói torres em 8 pads para impedir inimigos de atravessarem um único caminho. Primeiro marco: uma fase com 5 ondas, duração-alvo de 6 a 12 minutos a validar.

## Identidade da fase
Nome: "Vale do Sino da Aurora". Paisagem: pinheiros congelados, aurora discreta, lago congelado, ruínas, lanternas e cristais. Caminho sinuoso bem legível. Entrada na borda esquerda; destino do sino na borda direita.

## Loop do jogador
1. Começar com 170 moedas e 15 vidas.
2. Selecionar um dos 8 pedestais livres.
3. Comprar uma de 3 torres se houver dinheiro.
4. Clicar em iniciar onda; monstros percorrem `Path2D`.
5. Torres detectam/atacam; inimigos mortos rendem moedas; escapados tiram vida.
6. Comprar mais torres entre/durante ondas conforme a interface definida.
7. Vitória quando todas as 5 ondas terminarem, nenhum inimigo permanecer e restarem vidas; derrota se vidas chegarem a zero.

## Torres (números iniciais, a balancear)
| Torre | Custo | Alvo principal | Mecânica | Visual |
|---|---:|---|---|---|
| Sentinela do Pinheiro | 55 | Único | Flechas físicas rápidas | Madeira, neve, triângulo |
| Lança-Geada | 75 | Único | Dano leve + lentidão temporária, sem empilhamento ilimitado | Pedra, cristal ciano |
| Farol Arcano | 100 | Área | Mísseis arcanos com explosão de raio definido | Pedra violeta, mago pequeno |

## Inimigos (números iniciais)
| Inimigo | HP | Velocidade | Recompensa | Leitura |
|---|---:|---|---:|---|
| Gremlin do Granizo | 35 | 1.0× referência rápida | 8 | Azul/coral, passo apressado |
| Brutamonte de Gelo | 120 | 0.55× da velocidade do gremlin | 20 | Largura maior, passo pesado |

Unidades de velocidade reais dependem do comprimento da curva no Godot. Balancear por duração da travessia, não por número arbitrário de pixels/s.

## Ondas (provisório)
| Onda | Gremlins | Brutamontes | Intenção |
|---|---:|---:|---|
| 1 | 6 | 0 | Apresentação |
| 2 | 8 | 2 | Introduzir tanque |
| 3 | 10 | 3 | Exigir combinação de torres |
| 4 | 12 | 5 | Pressão intermediária |
| 5 | 15 | 6 | Clímax controlado |

Cuidar para que a primeira rodada seja possível com a torre inicial, e o jogador receba informação suficiente sobre custos e efeitos.

## Controles / UX
Mouse como controle principal. Clique pedestal → menu contextual → compra, mostrando custo e alcance. Clique botão → próxima onda. Esc → pausa (se adequado). HUD com ♥ Vidas, moeda, ícone de onda. Ao passar o cursor sobre torre, destaque de alcance; ao tentar compra impossível, feedback legível. Instrução curta no começo da primeira fase.

## Arte e técnica
Mapa source 2048×1152, viewport referencial 1280×720, escalonamento sem esticar. Personagens pré-renderizados em 2D, não pixel-art, spritesheets 6 quadros por direção por monstro, 4 direções. Trilha no `Path2D` sobre a estrada desenhada, `TowerPads` fixos. Torredes com imagens estáticas e efeitos de projétil gerenciados pelo Godot. Fundos gerados com IA precisam ser inspecionados e limpos. Sprite com transparência real.

## Critérios para primeira demonstração
Fase carrega, onda começa, 2 inimigos se movimentam, 3 torres atacam com funções diferentes, compra válida, moedas/vida atualizam, 5 ondas acabam, telas de resultado funcionam, sem erros graves no projeto. A fase não precisa ter loja, múltiplos mapas, tutorial extenso ou saves.

## Backlog pós-MVP
Upgrade de torres, posicionamento livre (se desejado), sons próprios, música dinâmica, neve ambiente leve, mini-chefe, biomas, efeitos climáticos, modo difícil, árvore de melhorias, localização, controle para gamepad, acessibilidade e Steam.
