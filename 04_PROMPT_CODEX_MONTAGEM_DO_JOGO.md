# PROMPT 2 PARA CODEX — Montagem da primeira versão jogável

> **Como usar:** envie este prompt depois de executar a auditoria, aprovar a estrutura e colocar as imagens produzidas nas pastas do Godot. Substitua caminhos apenas se forem diferentes dos sugeridos.

---

Você é um **programador líder de jogos 2D no Godot**, especialista em arquitetura GDScript, tower defense clássico, animação por spritesheet, UI e jogabilidade em PC. Trabalhe DIRETAMENTE dentro do projeto que está aberto neste workspace. A etapa anterior converteu o antigo rascunho de metroidvania para um projeto de tower defense nevado. Agora precisamos criar uma PRIMEIRA VERSÃO JOGÁVEL, limpa e extensível de **"Vale do Sino da Aurora"**.

## OBRIGATÓRIO ANTES DE ESCREVER CÓDIGO

1. Localize e leia `project.godot`, todos os `AGENTS.md` pertinentes, `docs/STATUS.md`, `docs/DECISOES.md`, `docs/ASSET_MANIFEST.md`, os relatórios anteriores e o inventário do projeto. Respeite a versão exata do Godot já presente. Prefira Godot 4.x se já for o projeto existente; não migre de versão sem me informar.
2. Localize os ARQUIVOS REAIS de imagem no workspace. Primeira hipótese de pastas:
   - `res://assets/backgrounds/level_01_snow.png`
   - `res://assets/backgrounds/level_01_path_guide.png` (guia de produção; não exibir no jogo final)
   - `res://assets/towers/tower_pine.png`, `tower_frost.png`, `tower_arcane.png`
   - `res://assets/enemies/gremlin/walk_[s,n,e,w].png`
   - `res://assets/enemies/golem/walk_[s,n,e,w].png`
   - `res://assets/effects/` e `res://assets/ui/`
   Estes caminhos são UMA CONVENÇÃO DESEJADA, não uma suposição de que já existam. Detecte os caminhos reais, registre no manifesto e reorganize com segurança apenas se não quebrar importação/referências. Se os arquivos estiverem em pasta externa ao projeto, PARE e peça a localização; não os invente.
3. Para qualquer sprite, valide dimensões, proporção, presença real de transparência e a quantidade correta de quadros. Se um spritesheet estiver ruim, informe qual imagem precisa de correção. É permitido usar placeholder TEMPORÁRIO rotulado para manter o protótipo executável.
4. Escreva plano de execução em `docs/STATUS.md` e avance por etapas pequenas e verificáveis.

## OBJETIVO DO MVP

Uma fase completa jogável com:
- Fundo 2D nevado exibido em 16:9 e viewport de referência 1280×720, preservando escala e proporção, com câmera fixa. Não construir projeto 3D.
- Uma rota única de inimigos desenhada manualmente como `Path2D` seguindo a trilha visível do mapa (não assuma que as coordenadas do briefing coincidem pixel-perfect com a arte da IA).
- 8 posições fixas para torres, via `TowerPad` clicável; ao clicar, aparecer seleção/compra, não colocar torres sobre a estrada.
- 3 torres: Sentinela do Pinheiro (flecha rápida), Lança-Geada (reduz velocidade temporariamente), Farol Arcano (projetil mágico com dano em área).
- 2 inimigos: Gremlin do Granizo (rápido/frágil), Brutamonte de Gelo (lento/tanque), ambos andando pela rota com spritesheets nas quatro direções. Ao mudar direção, escolher a animação correta (n/s/e/w).
- Pelo menos 5 ondas progressivas. Inimigo derrotado gera moedas; inimigo que passa pela saída reduz vidas.
- HUD: moedas, vidas, onda, botão iniciar próxima onda, pausa, tela de vitória/derrota, botão reiniciar.
- Experiência minimamente polida: feedback de compra, animações, barra de vida opcional pequena, efeitos simples, áudio placeholder apenas se houver recurso licenciado.

## ARQUITETURA RECOMENDADA, ADAPTÁVEL AO PROJETO REAL

```text
res://
  scenes/
    main_menu.tscn
    levels/level_01.tscn
    gameplay/enemy.tscn
    gameplay/tower.tscn
    gameplay/tower_pad.tscn
    gameplay/projectile.tscn
    ui/game_hud.tscn
    ui/tower_purchase_menu.tscn
  scripts/
    gameplay/enemy.gd
    gameplay/tower.gd
    gameplay/tower_pad.gd
    gameplay/projectile.gd
    systems/wave_manager.gd
    systems/game_manager.gd
    systems/economy.gd
    ui/game_hud.gd
  data/
    enemies/            # resources ou dados tipados, se útil
    towers/
    waves/
  assets/               # imagens fornecidas
  docs/
    reports/
    migration/
    STATUS.md
    DECISOES.md
    ASSET_MANIFEST.md
```

Não recriar mecanicamente pastas se já existem equivalentes bons. Modularidade pragmática: preferir poucos scripts legíveis a arquitetura excessiva.

## REGRAS TÉCNICAS

- `Path2D` + `PathFollow2D` ou abordagem equivalente documentada para posicionamento dos inimigos no percurso. Ajustar manualmente curva visível, sem confiar em detecção automática da estrada pelo PNG.
- Use `AnimatedSprite2D` e `SpriteFrames` para spritesheets consistentes, direção e quadro; se não houver 4 direções válidas, exiba placeholder/mensagem clara e registre pendência. Evite girar personagens de maneira visualmente errada.
- Programe estados claros para inimigos: percorrendo, sofrendo lentidão, morrendo, chegou ao final; evite morte e escape simultâneos.
- Torre possui alcance, cadência, custo, dano e alvo. Selecionar alvo dentro do alcance preferencialmente pelo maior progresso na rota. Projétil verifica alvo válido antes de aplicar dano.
- A lentidão deve expirar; impactos mágicos em área aplicam dano a múltiplos inimigos em um raio claro, sem duplo processamento acidental.
- Economia centralizada; compras somente quando há moedas e pad está vazio; impedir compras duplicadas por clique rápido.
- Interface via `Control`, responsiva ao aspecto 16:9, fonte legível, nenhum texto de HUD embutido no mapa gerado.
- Preserve a resolução apropriada de sprites e configure filtro de textura adequado à arte pintada/pré-renderizada (não usar filtro de pixel art por padrão).
- Evite dependências externas e addons desnecessários; use GDScript nativo do projeto.
- Debug opcional via flag: desenhar curva, alcance, posições dos pads e pivôs de personagem **sem aparecer no jogo de lançamento**.

## BALANCEAMENTO INICIAL (VALORES-PONTO DE PARTIDA, NÃO INEGOCIÁVEIS)

- Vida do jogador: 15. Moedas iniciais: 170. Número de ondas: 5.
- Custos: Sentinela 55, Lança-Geada 75, Farol Arcano 100.
- Gremlin: cerca de 35 de vida, rápido, recompensa 8 moedas.
- Golem: cerca de 120 de vida, lento, recompensa 20 moedas.
- Waves exemplo: 6G; 8G+2B; 10G+3B; 12G+5B; 15G+6B. As unidades precisam surgir em intervalos que produzam pressão progressiva, não todas de uma vez.
- Ajustar velocidade e dano conforme o comprimento REAL do `Path2D`, registrar alterações no balanceamento.
- Os níveis precisam ser vencíveis com ao menos duas estratégias plausíveis; realizar testes manuais ou automatizados compatíveis.

## ORDEM OBRIGATÓRIA DE IMPLEMENTAÇÃO

1. Criar/carregar cena de mapa e UI mínima. Conferir escala/viewport.
2. Desenhar `Path2D`, criar inimigo provisório e confirmar que ele percorre toda a rota sem travar.
3. Importar os spritesheets dos dois inimigos; selecionar direção de acordo com movimento. Testar recortes e pivôs.
4. Criar 8 `TowerPad` e compra de uma torre Sentinela do Pinheiro; testar custo e targeting.
5. Acrescentar Lança-Geada e Farol Arcano, projéteis, efeitos de gelo e dano em área.
6. Acrescentar gerenciador das cinco ondas e regras de derrota/vitória.
7. Finalizar HUD, telas, pausa, reinício, feedback visual e ajustes iniciais.
8. Rodar validação compatível com a versão Godot instalada e testar a rodada completa. Corrigir erros reais antes de declarar pronto.

Se o ambiente não permitir terminar tudo em uma interação, conclua um incremento funcional, documente a situação e aguarde a próxima tarefa. Não declare o MVP pronto se faltar sistema obrigatório.

## TESTES MÍNIMOS E CONDIÇÕES DE ACEITE

- O projeto abre sem erro grave de parser/importação (ou explicitar por que não foi possível comprovar).
- O mapa e os sprites têm proporções/posições coerentes e a trilha é atravessável até o fim.
- Ambos os monstros percorrem a rota e trocam corretamente as animações entre os quatro sentidos disponíveis.
- Cada torre ataca, tem alcance, preço e efeito individual; compra reduz moedas e não duplica torres em um pad.
- As cinco ondas podem ser iniciadas, concluídas e não criam condição de corrida; moedas e vidas mudam corretamente.
- Vitória/derrota/pausa/reinício realmente funcionam.
- Não existem erros recorrentes no output que possam ser evitados, nem recursos essenciais quebrados.

## RELATÓRIO A CADA INTERAÇÃO — NÃO OPCIONAL

Ao finalizar QUALQUER tarefa, **não apenas este prompt**, siga o `AGENTS.md` da raiz e:
1. Crie um novo `docs/reports/AAAA-MM-DD_HHMM_<tema>.md` com: objetivo, o que foi investigado, alterações de cada arquivo, assets adicionados/ausentes, testes realmente executados e resultados, problemas, pendências e **Próximos Passos P0 / P1 / P2**.
2. Atualize `docs/STATUS.md` e `docs/reports/INDEX.md`.
3. Atualize `docs/ASSET_MANIFEST.md` após qualquer mudança em imagens, sons e spritesheets.
4. Mantenha `docs/DECISOES.md` para mudanças arquiteturais importantes.
5. Na resposta ao usuário, inclua resumo legível, status atual **(não iniciado/em progresso/jogável/validado)**, relatório salvo e recomendação concreta da próxima tarefa.

## RESULTADO DESEJADO
Uma primeira fase de tower defense Godot **real, testável, organizada e visualmente coerente**, sem os sistemas abandonados do metroidvania. Trabalhe com os arquivos existentes, não assuma que a arte ainda não gerada já esteja presente e não afirme testes que não realizou.
