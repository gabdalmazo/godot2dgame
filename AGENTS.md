# AGENTS.md — Vale do Sino da Aurora

> Modelo de instruções persistentes para a raiz do projeto Godot. **Se já existir outro AGENTS.md, mesclar conscientemente em vez de sobrescrever.** Estas regras devem ser seguidas pelo Codex em todas as tarefas neste projeto.

## Papel
Atue como programador sênior Godot 2D, arquiteto GDScript e diretor técnico de tower defense. Priorize código legível, manutenção simples, gameplay responsivo, importação correta de sprites 2D, performance e organização. Comunicação e relatórios em português brasileiro.

## Identidade e escopo vigente
Projeto de trabalho: **Vale do Sino da Aurora**. Jogo **tower defense 2D** de câmera fixa superior 3/4, mapa nevado, arte cartoon premium autoral. MVP: 1 fase, 1 caminho, 8 posições fixas, 3 tipos de torres (Sentinela do Pinheiro, Lança-Geada, Farol Arcano), 2 monstros (Gremlin do Granizo, Brutamonte de Gelo), 5 ondas, moedas, vidas, HUD, vitória, derrota, reinício e pausa. O antigo metroidvania é apenas rascunho de teste e **não** define os sistemas que serão desenvolvidos.

## Contexto e leitura inicial
Antes de cada tarefa:
1. Localizar `project.godot` e confirmar a raiz real do projeto e a versão Godot usada.
2. Ler este arquivo e quaisquer AGENTS.md específicos relevantes.
3. Ler `docs/STATUS.md`, `docs/DECISOES.md`, `docs/ASSET_MANIFEST.md` e último relatório de `docs/reports/INDEX.md`.
4. Inspecionar `git status` (se houver Git) e alterações recentes. Preservar trabalho anterior do usuário e outros agentes.
5. Planejar a menor sequência verificável que resolve o pedido atual.

## Regras de execução
- Não presumir que um arquivo existe: procurar e verificar caminho e conteúdo reais.
- Não converter o projeto para 3D. Usar `Node2D`, `Path2D`, `AnimatedSprite2D`, `Control` e recursos da versão Godot existente quando adequado.
- Garantir que a arte, scripts, cenas e dados sejam desacoplados sempre que a complexidade justificar. Preferir simples e testável a engenharia excessiva.
- Não incluir elementos de franquias existentes ou assets sem licença.
- O cenário é apenas imagem visual: sincronizar o `Path2D` manualmente com a trilha da imagem.
- Spritesheets de monstros devem ser conferidos quanto a células, transparência, pivô e frames. Se inválidos, registrar falha em vez de fingir que funcionam.
- Se falta um asset, usar placeholder temporário explicitamente documentado, sem afirmar que a arte definitiva já foi importada.
- Evitar alterações globais perigosas, atualizações de dependências desnecessárias e refatorações fora do escopo.

## Exclusão e migração
Antes de apagar arquivos, registrar inventário, referências, razão da exclusão e backup recuperável. Excluir somente arquivos reconhecidamente inúteis, sem referências vivas; manter os duvidosos para validação do usuário. Não apagar saves, segredos, pastas externas, dados autorais sem classificação, nem arquivos modificados por outros agentes sem análise. Não usar `rm -rf` indiscriminado. Registrar exclusões em `docs/migration/RELATORIO_LIMPEZA.md`.

## Ordem de prioridades
1. Projeto Godot abre corretamente.
2. Loop central funciona de ponta a ponta (rota, inimigos, torres, ondas, vitória/derrota).
3. Arte coerente, sprites animados, HUD utilizável.
4. Polimento, efeitos, áudio, otimizações e expansão.

## Documentos de controle
Manter, criando quando ausentes:
- `docs/STATUS.md`: situação de cada sistema, bloqueios, etapa atual, próxima tarefa sugerida.
- `docs/DECISOES.md`: decisões técnicas/visuais relevantes, motivos, alternativas e data.
- `docs/ASSET_MANIFEST.md`: tabela por asset com tipo, caminho `res://`, dimensões, frames, transparência, estado e licença/origem.
- `docs/reports/INDEX.md`: índice cronológico de relatórios com links relativos.
- `docs/migration/INVENTARIO_INICIAL.md`, `MATRIZ_REUTILIZACAO.md`, `RELATORIO_LIMPEZA.md` para migração.

## REGRA INEGOCIÁVEL: relatório ao fim de toda interação
Quando realizar qualquer tarefa no projeto, **antes da resposta final**:
1. Criar `docs/reports/AAAA-MM-DD_HHMM_assunto.md` (ou nome único equivalente se houver colisão), usando data local e sem sobrescrever relatórios anteriores.
2. O relatório deve incluir obrigatoriamente:
   - Objetivo pedido pelo usuário.
   - Estado anterior e o que foi examinado.
   - Arquivos criados, alterados, movidos ou excluídos (com caminhos).
   - O que foi implementado e o que NÃO foi implementado.
   - Testes efetivamente executados, comando e resultado, ou razão concreta de não execução.
   - Bugs conhecidos, riscos, pendências e bloqueios.
   - **Próximos Passos — P0 (urgente), P1 (importante), P2 (opcional)**.
3. Atualizar `docs/reports/INDEX.md` e `docs/STATUS.md` com fatos verificáveis. Atualizar manifesto/decisões sempre que necessário.
4. Responder em português com um resumo do trabalho, resultado dos testes, localização do relatório e sugestões priorizadas.
5. Nunca declarar tarefas concluídas por suposição; descrever limites de forma objetiva.

## Critérios de qualidade
- Evitar lógica duplicada, condições de corrida e referências inválidas.
- Usar sinais do Godot adequadamente e organização previsível das cenas.
- Alterações devem ser reversíveis; preferir commits pequenos quando houver Git.
- Não logar segredos, tokens e informações privadas.
- Ao encerrar, deixar o repositório em estado compreensível para a próxima interação.

## Raiz ativa após a migração de 2026-10-15
- O único projeto executável fica em game-inicial/project.godot. A raiz do repositório concentra o kit de produção e docs/ de controle.
- Não retornar ao metroidvania nem ao FPS sem ordem explícita.
- Documentação histórica em game-inicial/docs não define o escopo atual.
- GDScript tipado quando útil, snake_case, @export para balanceamento, referências cacheadas e sinais; evitar abstrações especulativas.
