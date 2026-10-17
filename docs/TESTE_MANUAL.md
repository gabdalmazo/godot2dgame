# Roteiro de teste — etapa 6: expansão e regressão

**Estado:** o usuário confirmou a Etapa 3 em runtime, com personagens corretos e gameplay satisfatória. As Etapas 4, 5 e 6 passaram apenas por verificações estáticas do Codex. Abra no mesmo Godot; a configuração recebida declara 4.7/Compatibility. Não é necessário instalar addons.

## Etapa 6 — executar primeiro

1. Importe/abra `game-inicial/project.godot`, aguarde o novo WAV e os Resources serem importados e pressione **F5**. A cena principal agora é `res://scenes/world/aurora_level_extended.tscn`; a antiga `aurora_level.tscn` continua acessível no editor e pode ser executada com **F6** como fallback. Se houver erro, registre a **primeira** mensagem completa do Output/Debugger.
2. A cena estendida deve mostrar o mesmo mapa nevado com **oito** bases válidas (1, 2, 4, 5, 6, 7, 8 e **9** na ilha central), 170 moedas, 15 vidas e onda 0/7. Ative `Debug Route` no Inspector da raiz apenas para inspecionar: a linha deve seguir o **ramo inferior** sem cortar rochas, plataformas ou neve. Desative em seguida. A prévia de engenharia em `docs/assets/etapa6_extended_route.png` não é captura de gameplay.
3. Ouça a música provisória: deve começar automaticamente, ficar baixa em relação aos tiros e repetir a cada 16 s sem estalo perceptível. Pause com Esc/botão: música e mundo devem pausar; retome e confirme continuidade. Verifique se os treze SFX anteriores ainda são audíveis. `music_volume_db` e `sfx_volume_db` ficam no nó `Audio` para ajustes no Inspector.
4. Construa uma Sentinela (55). Ao selecionar a base ocupada, confirme nome, **NÍVEL 1**, dano 12, alcance 180, intervalo 0,65 s e botão de evolução por **95 moedas**. Com saldo insuficiente ele deve ficar desabilitado; ao reunir moedas, evolua: o saldo cai uma vez, nível 2 mostra dano 19/alcance 205/intervalo 0,62 s e o desenho ganha leve escala/cor/anel. A próxima evolução custa **155** e chega ao nível 3 (27/225/0,48 s). No máximo, o botão deve mostrar “NÍVEL MÁXIMO” e impedir outro débito.
5. Teste a Lança-Geada: L2 custa **110** (13 dano, 215 alcance, 0,48× de velocidade por 2,3 s); L3 custa **175** (20 dano, 235 alcance, 0,40× por 2,8 s). Teste o Farol Arcano: L2 custa **145** (39 dano, área 55 px), L3 custa **220** (56 dano, área 70 px). Confirme que cada torre na mesma fase evolui independentemente e projéteis em voo não trocam atributos retroativamente.
6. Percorra as sete ondas, anotando compras e vidas: totais esperados **8, 12, 16, 21, 25, 30, 27** (a última inclui o boss). Vida/velocidade dos gremlins e golens sobem suavemente entre ondas; os primeiros ainda devem ensinar o jogo. O botão de onda não deve habilitar até spawn e resolução de todos os inimigos da onda atual.
7. Na onda 7, a HUD deve indicar **CHEFE** e exibir aviso do Regente da Geada. Ele surge depois do apoio, como silhueta procedural escura/cristalina maior que o golem, com barra de vida de 700 PV, velocidade 19 px/s, recompensa 120 moedas, redução de dano de 15% e resistência à lentidão (não fica abaixo de 75% da velocidade). Use Lança-Geada e Sino; verifique que pode morrer e que sua recompensa entra uma única vez. A vitória só deve aparecer depois dele e de todos os demais inimigos estarem resolvidos, com vidas acima de zero.
8. Para conferir a base final, reinicie e inicie ondas sem torres até haver escapes. Observe o edifício à direita: brilho ciano passa a tons quentes e surgem rachaduras em cinco faixas de vida. O tooltip do status indica a condição. Cada gremlin/golem que escapa remove 1 vida; o boss remove 5. Na derrota, a base deve estar quase destruída, o mundo parar e Reiniciar restaurar 15 vidas e o visual íntegro. O edifício é parte da imagem do mapa; o dano é um overlay temporário.
9. Repita pausa, Sino (3 s/24 s), compra, HUD, redimensionamento e os testes de áudio da etapa anterior. Compare a cena original via F6: ela deve conservar a rota superior, sete bases e cinco ondas; upgrades podem aparecer nela, mas sem boss/base overlay/música vinculada à cena estendida.

**Assets ainda provisórios:** boss e base danificada são desenhos de código; os níveis 2/3 reutilizam PNGs de nível 1. Envie captura da rota/boss/base e a primeira mensagem completa do Debugger se encontrar desvio, corte, erro de importação ou desequilíbrio.

## Regressão da Etapa 5

1. Abra `game-inicial/project.godot`, aguarde a importação dos quatro SVGs em `assets/ui/aurora/` e dos 13 WAVs, pressione **F5** e confira Output/Debugger. A referência `img/hud_nova.jpg` fica fora do projeto e não deve aparecer como mapa sobreposto.
2. Em 1280×720, compare a HUD com a referência: placa de título à esquerda, coração/vida, moeda/saldo, estandarte azul de onda e engrenagem de pausa no topo; painel de madeira contextual com três cartões ilustrados; rodapé com estado, Sino, botão verde de iniciar onda e reinício. A arte é uma aproximação nativa: teste legibilidade, contornos claros, espaçamento e se o mapa continua visível.
3. Clique em uma base vazia. O painel deve surgir com leve fade e mostrar as três artes reais, nomes, funções e custos 55/75/100 vindos dos Resources. Passe o mouse para ver o realce e tooltip; compre uma torre, confira saldo e toast. Base ocupada deve mostrar somente dados e Fechar, sem permitir compra duplicada.
4. Compre Sentinela e Lança-Geada (restam 40 moedas), selecione outra base: os três cartões devem ficar indisponíveis e o custo em cor de alerta. Feche o painel e confirme que cliques no mapa continuam selecionando bases; não deve haver uma HUD antiga duplicada atrás da nova.
5. Inicie uma onda. O botão verde deve desabilitar durante onda ativa; vida, moedas e onda devem acompanhar dano, mortes, compras e progressão. O Sino deve habilitar somente com inimigos presentes, mostrar barra de recarga de 24 s e tooltip de lentidão de 3 s. Teste pausa por botão e Esc, retomar, vitória, derrota e reinício.
6. Redimensione a janela para aproximadamente 960×540, 800×600 e 640×480. Verifique se cartões, botões, recursos, toasts e tela de resultado permanecem legíveis/clicáveis e se não cobrem as bases continuamente. Anote largura/altura e forneça captura se houver corte ou sobreposição.
7. Repita as verificações de caminhada, áudio e gameplay da Etapa 4 abaixo. Se aparecer erro, envie a primeira mensagem completa do Output/Debugger e o passo que a gerou. Teste estático não substitui esse teste no Godot.

## Regressão da Etapa 4 (alguns números abaixo descrevem a cena original)

1. Abra `game-inicial/project.godot`, aguarde a importação dos 13 WAVs e pressione **F5**. Registre a primeira mensagem do Output/Debugger se houver erro de script, recurso ou áudio.
2. Observe a HUD antes de iniciar: barra superior fina com vidas, moedas, onda e pausa; rodapé com estado, Sino, iniciar onda e reiniciar. Clique em uma base: menu contextual deve mostrar três torres, preço e função em espaço menor. Fechar e clicar no mapa devem continuar funcionando. Mensagens devem aparecer brevemente como toast e desaparecer sem cobrir a fase permanentemente.
3. Inicie onda 1 e observe gremlins nas curvas; na onda 2 observe golens. Os pés devem seguir a mesma rota e a cabeça não deve saltar. Gremlin balança um pouco mais rápido; golem oscila menos e parece pesado. Barras de vida, mira e acertos devem continuar alinhados. Arte real e tamanho relativo devem ser preservados.
4. Durante uma onda com inimigos visíveis, clique **Sino da Aurora**. Esperado: anel claro partindo da edificação à direita, som de sino, lentidão por 3 s dos inimigos já presentes e botão mostrando a recarga de 24 s. Inimigos que surgirem depois do toque não devem receber o efeito retroativamente. O botão deve impedir acionamento repetido e ficar indisponível sem inimigos, em pausa, vitória ou derrota.
5. Pause durante a lentidão e a recarga: personagens, anel e contagem devem congelar. Retome e confirme que continuem do mesmo ponto. O Sino não causa dano, não custa moedas e não altera vidas diretamente. Compare a lentidão com a Lança-Geada; ela deve usar a regra anterior sem multiplicar efeitos.
6. Com som ativado no sistema, confira clique de botão, construção, início de onda, três tipos de disparo, impacto, morte, escape, pausa/retorno, Sino, vitória e derrota. Os sons devem ser curtos e discretos, sem estalos ou volume desconfortável. Não há música nesta etapa.
7. Repita os testes de compra, saldo insuficiente, sete bases, cinco ondas, área, gelo, escapes, vitória, derrota e reinício abaixo. Confirme que preços, dano e totais não mudaram. Teste em uma janela mais estreita para detectar corte de HUD e menu.

Os passos históricos abaixo descrevem a cena original de cinco ondas. Use F6 com `aurora_level.tscn` para repetir seus números exatos; na cena estendida F5 use os valores da seção Etapa 6. Imagens de `docs/assets` não são capturas de runtime.

## Abrir e iniciar

1. No gerenciador do Godot, clique **Importar** e selecione `game-inicial/project.godot` dentro deste repositório. `res://` é essa pasta.
2. Aguarde a importação automática de PNGs, scripts e classes. Se havia outro projeto aberto, reabra este para atualizar as configurações.
3. Abra `res://scenes/world/aurora_level.tscn` e pressione **F6** para executar a fase original de regressão. F5 executa a cena estendida; inimigos isolados dependem do Path2D da fase.
4. Deve aparecer o mapa nevado original, sete bases numeradas **1, 2, 4, 5, 6, 7, 8**, 15 vidas, 170 moedas, onda 0/5, controles de pausa/reinício e uma instrução inicial. A posição 3 não pode receber torre.
5. As torres devem usar as artes de madeira/neve, cristal ciano e orbe roxo. Os monstros devem mostrar o gremlin com cachecol e o golem de gelo. Flecha, cristal e orbe usam arte transparente. Não devem aparecer quadrados quadriculados nem o mapa com linhas vermelhas.

## Compra e combate

6. Clique na base 2. Deve abrir uma faixa inferior com três torres e seus custos. Passe o mouse sobre os botões para ver dano, alcance e cadência.
7. Compre **Sentinela do Pinheiro (55)**. As moedas devem cair de 170 para 115 e a base mostrar uma torre com cobertura de alcance ao selecionar/passar o mouse.
8. Clique repetidamente no botão/base: não deve surgir segunda torre nem haver segundo desconto. Base ocupada mostra informações, upgrade e **Fechar**. Não há venda nesta versão.
9. Compre **Lança-Geada (75)** na base 5. Restam 40 moedas: todas as opções de compra devem ficar desabilitadas em uma nova base. Nenhum saldo pode ficar negativo.
10. Clique **Iniciar onda 1**. Surgem seis gremlins pela esquerda. O botão de próxima onda fica indisponível até o último inimigo morrer ou escapar.
11. As torres atacam automaticamente: flecha dourada, cristal ciano com lentidão e orbe roxo com área. Barras de vida aparecem após dano. Ao matar gremlin, receber 8 moedas; golem, 20.
12. Para testar a arcana cedo, reinicie e compre **Farol Arcano (100)** + **Sentinela (55)**, nas bases 5 e 2. O orbe deve atingir grupos próximos, com um único dano por inimigo em cada impacto.
13. No gelo, observe a redução temporária de velocidade e o halo ciano. Após dois segundos sem novo impacto, a velocidade normal deve retornar. Repetição de gelo renova a duração, sem multiplicar a redução.

## Rota e término das ondas

14. Os inimigos devem seguir o ramo **superior** da estrada. A estrada inferior permanece no desenho, mas não é uma rota alternativa nesta versão. Observe curvas sem saltos e chegada ao acesso da construção direita.
15. O golem aparece a partir da onda 2, maior, mais resistente e mais lento. Os sprites estáticos viram horizontalmente e têm balanço sutil; não há poses reais para norte/sul. A barra deve ficar acima da cabeça após dano, sem cortar o personagem.
16. Só iniciar próxima onda depois da mensagem de conclusão. Totais: **6, 10, 13, 17 e 21** inimigos. Onda concluída exige todos gerados e nenhum ativo.

## Vidas, derrota e vitória

17. **Escape/derrota:** reinicie, não compre torres e inicie a onda 1. Cada escape remove uma vida e não dá moedas. Deve restar 9 vidas após os seis gremlins. Inicie a onda 2 sem torres: a derrota deve ocorrer ao chegar a zero; nenhum novo spawn deve continuar e o mundo deve parar.
18. **Vitória:** reinicie, construa e complete as cinco ondas com vidas restantes. A vitória só deve aparecer depois que o último inimigo for resolvido, nunca no instante do último spawn. O loop anterior foi confirmado pelo usuário; repita como teste de regressão e registre compras/bases se notar diferença.
19. Na vitória/derrota, **Reiniciar fase** deve restaurar 170 moedas, 15 vidas, onda 0/5, bases vazias e nenhum projétil/inimigo antigo.

## Pausa e robustez

20. Pause com **Esc** ou botão durante um grupo em movimento. Inimigos, disparos, spawn, impactos e duração de lentidão devem congelar. A interface de retomar/reiniciar deve continuar respondendo.
21. Retome: tudo continua do mesmo ponto. Repita durante preparação e intervalo. Esc não deve sair das telas de vitória/derrota.
22. Reinicie também durante onda ativa e durante pausa. Não deve haver ondas antigas, sinal duplicado ou jogo permanentemente pausado.
23. Redimensione a janela em proporções diferentes: mapa deve manter a proporção, bases e curva alinhadas, HUD legível. Teste cliques nas sete bases e nos botões.

## Diagnóstico e próxima interação

24. No editor, confira **Output** e **Debugger**. Copie a primeira mensagem completa, caminho do arquivo, número da linha e passos que a causaram. Erros de parser impedem a execução; não ignore avisos de referência ausente.
25. Para conferir o trajeto, selecione a raiz `AuroraLevel` e marque **Debug Route** no Inspector; a linha aparecerá apenas nessa configuração. Desmarque para jogar. Ajuste pontos em `World/EnemyPath`, usando o mapa original como referência.
26. Envie screenshots da HUD, erros do Output/Debugger e resultados de caminhada, áudio, Sino, pausa, vitória/derrota. Próxima interação: corrigir observações reais da Etapa 4.

## Repetir verificações estáticas

Na raiz do repositório, com Python + Pillow disponíveis:

```text
python tools/audit_assets.py
python tools/validate_td.py --output docs/validation/etapa6_general.json --preview docs/assets/etapa6_route_original.png
python tools/validate_stage4.py
python tools/validate_stage5.py
python tools/validate_stage6.py
git diff --check
```

Execute os scripts com uma instalação Python que tenha Pillow; o Codex usou o Python incluído no ambiente do aplicativo. Esses comandos auditam originais, WAVs, referências, nós, dados, geometria e contratos da HUD. `validate_visual_integration.py` era o contrato histórico da Etapa 3 e não deve ser reexecutado como verificação atual: ele rejeita intencionalmente as mudanças de HUD e caminhada. Nenhum verificador substitui o parser Godot ou executa gameplay.

## Regressão visual da Etapa 3

1. Aguarde a importação das nove imagens em `res://assets/processed/`. F5 deve iniciar sem erro. Confirme cada torre em uma base, reiniciando para comprar combinações diferentes com as 170 moedas.
2. Confira chão visível ao redor da silhueta, neve preservada, bandeira/cristais/orbe inteiros e base da torre centrada na plataforma. Observe também perto das bordas e da HUD. Se aparecer desenho geométrico em lugar da arte, conferir avisos de textura no Output.
3. Inicie ondas 1 e 2; veja gremlin e golem em várias curvas. Pés devem seguir a estrada; bob/squash não devem deslocar o trajeto. Golem deve parecer maior. Teste pausa durante o movimento: sprite, projétil e impacto devem congelar.
4. Após dano, confira barras legíveis acima da cabeça. Observe lentidão e a recuperação da velocidade. Torres/inimigos devem sobrepor conforme posição dos pés; projéteis devem ficar visíveis por cima. Seleção/alcance devem continuar funcionando.
5. Compare flecha dourada, cristal ciano, orbe roxo e explosão arcana. Verifique ausência de quadrado opaco, brilho excessivo ou corte. Origem/mira do disparo foram preservadas; registre se o encaixe visual exigir ajuste.
6. Repita compra, saldo insuficiente, morte/escape, vitória, derrota e reinício descritos acima. Confirme ausência de novas mensagens de erro no Debugger.
7. **Fallback opcional, sem apagar arquivos:** com o jogo parado, anote `static_texture_path` de um inimigo e deixe vazio no Inspector. F5 deve mostrar o desenho procedural, mantendo o movimento/combate. Restaure o valor e execute F5 novamente. O mesmo teste pode ser feito com `texture_path`, `projectile_texture_path` e `impact_texture_path`. Não altere atributos de gameplay. O cache só é renovado ao reexecutar o jogo.

As imagens em docs/assets/etapa3_* são composições técnicas, não comprovação de runtime. Envie o primeiro erro completo e indique torre/inimigo/base/onda caso encontre falha.
