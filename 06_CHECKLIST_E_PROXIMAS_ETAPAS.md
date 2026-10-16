# Checklist e sequência futura

## Fase 0 — Organização
- [ ] Repositório e backup verificados.
- [ ] Auditoria e relatório da limpeza do antigo metroidvania.
- [ ] `AGENTS.md` integrado às instruções existentes.
- [ ] Pastas de assets, cenas, scripts, docs e reports padronizadas.

## Fase 1 — Arte mínima
- [ ] Bíblia visual aprovada.
- [ ] Mapa de neve em 16:9 escolhido e validado (sem personagens nem torres embutidas).
- [ ] 3 torres PNG com alfa e mesma perspectiva.
- [ ] 2 imagens-mestre dos monstros com alfa e design estável.
- [ ] 8 spritesheets de caminhada (2 monstros × 4 direções), cada um com 6 frames utilizáveis.
- [ ] 3 projéteis e impactos básicos.
- [ ] Ícones fundamentais de HUD.
- [ ] Licença/origem e versões de cada asset anotadas no manifesto.

## Fase 2 — Jogabilidade mínima
- [ ] Projeto abre e mapa aparece na proporção correta.
- [ ] `Path2D` encaixado sobre a estrada, entrada e saída testadas.
- [ ] Gremlin e Brutamonte percorrem a rota com animação por direção.
- [ ] 8 pedestais têm clique e verificação de ocupação.
- [ ] 3 torres compráveis, cada uma com comportamento distinto.
- [ ] Economia, mortes e redução de vida funcionam.
- [ ] 5 ondas, vitória, derrota, pause e restart.
- [ ] HUD claro e efeitos básicos.
- [ ] Teste de ponta a ponta registrado.

## Fase 3 — Polimento do primeiro mapa
- [ ] VFX de flecha, gelo e magia.
- [ ] Áudio original/licenciado para compra, tiros, morte, vitória e derrota.
- [ ] Música ambiente suave com variações de ameaça.
- [ ] Efeito de neve leve e aurora discreta que não atrapalhem leitura.
- [ ] Ajustar telemetria básica de tempo de onda, economia e dificuldade.
- [ ] Revisão de desempenho, alvos, warnings e importações.
- [ ] Tutorial de uma ou duas mensagens.

## Fase 4 — Profundidade (após o jogo estar divertido)
- [ ] Melhorias nível 2/3 por torre e venda/reembolso.
- [ ] Inimigo com escudo ou resistência mágica (terceiro tipo só após balanceamento dos dois).
- [ ] Mini-chefe de fim da fase.
- [ ] Sistema de estrelas, placar e dificuldade.
- [ ] Segunda fase com bioma exclusivo, mantendo sistema base.
- [ ] Escolha de herói mago (se o MVP justificar), mas separado do mago decorativo da torre.
- [ ] Gamepad, localização e opções de acessibilidade.

## Fase 5 — Preparação para venda
- [ ] Definir plataformas e modelo de negócio.
- [ ] Ajustar direitos de uso comercial dos assets gerados, sons, fontes e plugins.
- [ ] Testes com pessoas externas, análise de funil e balanceamento.
- [ ] Menu de opções, volumes, fullscreen, resolução, save e créditos.
- [ ] Revisão de UX e acessibilidade (contraste, tamanhos de texto, redução de flashes).
- [ ] Builds Windows/Linux/macOS conforme plano, testes em hardware-alvo.
- [ ] Screenshots e trailer com gameplay real, não só mockups.
- [ ] Página de loja, descrição e materiais promocionais.
- [ ] Checklist legal, privacidade e QA final; publicar somente após estabilidade.

## Ordem recomendada de próximos pedidos ao Codex
1. **"Audite o protótipo e realize a limpeza segura com AGENTS.md e relatório."**
2. **"Importe o cenário e alinhe visualmente o Path2D. Faça um inimigo placeholder atravessar a fase."**
3. **"Importe os 8 spritesheets e crie as animações por direção."**
4. **"Implemente a primeira torre e os pads com sistema de economia."**
5. **"Implemente as outras torres, ondas, HUD e estados de vitória/derrota."**
6. **"Ajuste balanceamento, UX, partículas, áudio e valide uma partida completa."**

## Pontos importantes para revisar após cada interação
O arquivo de relatório existe? Descreve todas as alterações reais? Godot abriu? Há erros de importação? Foi mantido o escopo do MVP? Qual é a próxima tarefa prioritária e verificável?
