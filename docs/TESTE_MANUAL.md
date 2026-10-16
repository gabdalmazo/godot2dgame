# Roteiro de teste — etapa 3: arte e regressão

**Estado:** etapa 2 confirmada pelo usuário. Etapa 3 revisada estaticamente, ainda sem execução pelo Codex. Abra no Godot usado no teste anterior; a configuração recebida declara 4.7/Compatibility e foi preservada. Não é necessário instalar addons.

## Abrir e iniciar

1. No gerenciador do Godot, clique **Importar** e selecione `game-inicial/project.godot` dentro deste repositório. `res://` é essa pasta.
2. Aguarde a importação automática de PNGs, scripts e classes. Se havia outro projeto aberto, reabra este para atualizar as configurações.
3. A cena principal é `res://scenes/world/aurora_level.tscn`. Pressione **F5** para executar a fase. F6 também funciona se essa cena estiver aberta; inimigos isolados dependem do Path2D da fase.
4. Deve aparecer o mapa nevado original, sete bases numeradas **1, 2, 4, 5, 6, 7, 8**, 15 vidas, 170 moedas, onda 0/5, controles de pausa/reinício e uma instrução inicial. A posição 3 não pode receber torre.
5. As torres devem usar as artes de madeira/neve, cristal ciano e orbe roxo. Os monstros devem mostrar o gremlin com cachecol e o golem de gelo. Flecha, cristal e orbe usam arte transparente. Não devem aparecer quadrados quadriculados nem o mapa com linhas vermelhas.

## Compra e combate

6. Clique na base 2. Deve abrir uma faixa inferior com três torres e seus custos. Passe o mouse sobre os botões para ver dano, alcance e cadência.
7. Compre **Sentinela do Pinheiro (55)**. As moedas devem cair de 170 para 115 e a base mostrar uma torre com cobertura de alcance ao selecionar/passar o mouse.
8. Clique repetidamente no botão/base: não deve surgir segunda torre nem haver segundo desconto. Base ocupada mostra informações e **Fechar**. Não há upgrade/venda nesta versão.
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
26. Envie screenshots do mapa/HUD, erros do Output/Debugger e resultados de compra, pausa, vitória/derrota. Próxima interação: corrigir eventuais problemas de importação, recorte, escala, alinhamento ou regressão observados na etapa 3.

## Repetir verificações estáticas

Na raiz do repositório, com Python + Pillow disponíveis:

```text
python tools/install_visual_assets.py
python tools/validate_td.py --output docs/validation/etapa3_static.json --preview docs/assets/etapa3_route_validation.png
python tools/validate_visual_integration.py
python tools/preview_visual_assets.py
git diff --check
```

Esses comandos auditam pixels, referências, nós, dados e geometria. Não validam a sintaxe GDScript pelo parser Godot nem executam gameplay.

## Conferência visual específica da etapa 3

1. Aguarde a importação das nove imagens em `res://assets/processed/`. F5 deve iniciar sem erro. Confirme cada torre em uma base, reiniciando para comprar combinações diferentes com as 170 moedas.
2. Confira chão visível ao redor da silhueta, neve preservada, bandeira/cristais/orbe inteiros e base da torre centrada na plataforma. Observe também perto das bordas e da HUD. Se aparecer desenho geométrico em lugar da arte, conferir avisos de textura no Output.
3. Inicie ondas 1 e 2; veja gremlin e golem em várias curvas. Pés devem seguir a estrada; bob/squash não devem deslocar o trajeto. Golem deve parecer maior. Teste pausa durante o movimento: sprite, projétil e impacto devem congelar.
4. Após dano, confira barras legíveis acima da cabeça. Observe lentidão e a recuperação da velocidade. Torres/inimigos devem sobrepor conforme posição dos pés; projéteis devem ficar visíveis por cima. Seleção/alcance devem continuar funcionando.
5. Compare flecha dourada, cristal ciano, orbe roxo e explosão arcana. Verifique ausência de quadrado opaco, brilho excessivo ou corte. Origem/mira do disparo foram preservadas; registre se o encaixe visual exigir ajuste.
6. Repita compra, saldo insuficiente, morte/escape, vitória, derrota e reinício descritos acima. Confirme ausência de novas mensagens de erro no Debugger.
7. **Fallback opcional, sem apagar arquivos:** com o jogo parado, anote `static_texture_path` de um inimigo e deixe vazio no Inspector. F5 deve mostrar o desenho procedural, mantendo o movimento/combate. Restaure o valor e execute F5 novamente. O mesmo teste pode ser feito com `texture_path`, `projectile_texture_path` e `impact_texture_path`. Não altere atributos de gameplay. O cache só é renovado ao reexecutar o jogo.

As imagens em docs/assets/etapa3_* são composições técnicas, não comprovação de runtime. Envie o primeiro erro completo e indique torre/inimigo/base/onda caso encontre falha.
