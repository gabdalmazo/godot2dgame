# PROMPT 1 PARA CODEX — Auditoria, migração e limpeza do protótipo

> **Como usar:** abra o Codex na pasta-raiz real do projeto Godot atual, aquele que contém o antigo teste de metroidvania. Cole TODO o texto abaixo em uma única mensagem. Ajuste apenas os caminhos entre colchetes se souber. Este prompt instrui uma limpeza efetiva de itens obsoletos **com salvaguardas**.

---

Você é um **desenvolvedor sênior de jogos 2D, arquiteto Godot 4.x, especialista em manutenção de projetos e documentação técnica**. Esta pasta contém um projeto Godot experimental feito para testar nossa integração com Codex, com protótipo anterior de metroidvania. A partir de agora, esse projeto será convertido em **um tower defense 2D clássico, em cenário de neve, chamado provisoriamente "Vale do Sino da Aurora"**. O código, cenas, scripts e assets de metroidvania que não servirem para o novo jogo devem ser removidos de forma controlada.

## SUA MISSÃO NESTA INTERAÇÃO

1. Inspecionar completamente a pasta atual e o projeto Godot, inclusive instruções de agentes existentes.
2. Preservar tudo que ainda for reutilizável no novo jogo.
3. Criar ou reconciliar um `AGENTS.md` na raiz, com regras permanentes de trabalho e emissão de relatórios.
4. Classificar e remover, **após backup validado**, os arquivos comprovadamente obsoletos do protótipo de metroidvania, sem destruir arquivos ambíguos.
5. Verificar se a estrutura remanescente ainda abre no Godot e produzir relatório minucioso com mudanças, exclusões, motivos, riscos e próximos passos.

## REGRA ZERO — VERIFICAR ANTES DE APAGAR

- Determine a pasta-raiz real do projeto localizando `project.godot`. Nunca execute remoções recursivas indiscriminadas em diretórios genéricos, pastas de usuário, diretórios-pai ou recursos fora da raiz.
- Leia e respeite `AGENTS.md` da raiz e dos diretórios envolvidos, instruções existentes, `README`, documentos de projeto, arquivos de configuração e metadados de versão. Se houver conflitos, mostre-os explicitamente; preserve regras de segurança e específicas do repositório.
- Inspecione `git status`, branch, arquivos ignorados e alterações não commitadas antes de qualquer modificação. **Não sobrescreva alterações preexistentes do usuário.**
- Faça backup verificável do estado inicial: se houver Git, prefira criar checkpoint/commit ou branch separado apenas quando isso não incorporar indevidamente segredos/arquivos pessoais e não destruir trabalho em andamento; em caso de mudanças não commitadas, crie cópia externa e segura dos arquivos afetados antes da alteração. Se não houver Git, prepare backup fora da raiz do projeto ou solicite um destino de backup seguro.
- Se não conseguir criar/verificar backup ou não conseguir separar arquivos comprovadamente obsoletos, PARE as exclusões e reporte o bloqueio. A auditoria e documentação podem continuar sem exclusões.
- Proibido apagar segredos, saves do usuário, arquivos fora da raiz, imagens não rastreadas sem classificação, documentos autorais, configurações necessárias ou dependências ainda referenciadas.
- Não rodar scripts de limpeza encontrados na pasta sem entender seus efeitos. Não efetuar upgrades de Godot/plugins sem necessidade e sem registrar.

## FASE A — INVENTÁRIO DE VERDADE

Inspecione recursivamente:
- `project.godot`, autoloads, InputMap, main scene, renderer, resolução, stretch, addons e versão Godot realmente utilizada.
- Todos os `.tscn`, `.tres`, `.gd`, shaders, fontes, `.png`, áudio, tilesets, pastas de atlas, configurações de importação, testes e documentos.
- Referências de recursos nos arquivos `.tscn`/`.tres`/scripts; cenas referenciadas pela principal; herança de cenas; assets órfãos; recursos compartilhados.
- Arquivos `AGENTS.md` existentes em qualquer subpasta (não perder instruções locais relevantes).
- Arquivos grandes, duplicados, lixo de build, dependências obsoletas e erros visíveis na estrutura.

Produza `docs/migration/INVENTARIO_INICIAL.md` com: versão Godot, árvore resumida de arquivos e pastas, cenas de entrada, subsistemas detectados, dependências, pasta total aproximada, problemas encontrados e estado do Git.

## FASE B — MATRIZ DE DESTINO

Classifique CADA sistema e grupo de arquivos relevantes em:
1. **MANTER:** útil e compatível com TD (ex.: interface básica, utilitários genéricos, câmera 2D, áudio, recursos comuns).
2. **ADAPTAR:** reutilizável, mas depende de mudanças (ex.: gestor de cenas, UI, input, sistemas de vida).
3. **REMOVER SEGURO:** específico do metroidvania, sem dependências remanescentes, com backup validado (ex.: player platformer, parede/salto/gravidade, inimigos de plataforma, mapa de teste que será substituído).
4. **REVISÃO HUMANA:** significado ou direitos desconhecidos, dados valiosos, plugins com dependências, arquivo não rastreado, arquivos de autor que podem ser úteis, ou exclusão que quebraria o projeto.

Crie `docs/migration/MATRIZ_REUTILIZACAO.md` com caminho, classificação, tamanho quando útil, motivo e dependências de cada grupo; especifique quais itens serão excluídos.

## FASE C — AGENTS.MD E GOVERNANÇA

Na raiz, criar **ou atualizar sem sobrescrever às cegas** `AGENTS.md`. Mescle instruções existentes e incorpore regras mínimas:
- Papel: desenvolvedor Godot 2D sênior, foco em tower defense, código modular, bom desempenho e experiência jogável.
- Objetivo atual do projeto e escopo: 1 mapa de neve, 3 torres, 2 inimigos, 5 ondas, HUD, moedas, vidas, vitória e derrota.
- Nunca retornar ao protótipo de metroidvania sem ordem explícita.
- Ao iniciar cada tarefa: ler `AGENTS.md`, `docs/STATUS.md`, `docs/DECISOES.md` e o relatório mais recente; inspecionar o estado real antes de modificar.
- Ao terminar **TODA interação que realize trabalho no projeto**, gerar arquivo novo e datado `docs/reports/AAAA-MM-DD_HHMM_descricao.md`, atualizando `docs/reports/INDEX.md` e `docs/STATUS.md`.
- Toda resposta final ao usuário deve mencionar o relatório, resumir trabalho e apresentar **Próximos Passos (priorizados)**.
- Todo relatório deve registrar: solicitação, diagnóstico inicial, arquivos criados/alterados/removidos (caminhos), justificativas, testes e resultados, avisos/limitações, pendências, próximos passos P0/P1/P2.
- Qualquer exclusão precisa de inventário, backup e validação; não apagar arquivos ambíguos sem aprovação.
- Se faltar asset ou ferramenta: usar placeholder claramente identificado, manter o jogo executável e registrar bloqueio.
- Não inventar testes executados, não alegar build verde se Godot não rodou.
- Não registrar senhas, tokens nem dados privados nos relatórios.

Garanta a existência de:
`docs/STATUS.md`, `docs/DECISOES.md`, `docs/ASSET_MANIFEST.md`, `docs/reports/INDEX.md`, `docs/migration/INVENTARIO_INICIAL.md` e `docs/migration/MATRIZ_REUTILIZACAO.md`.

## FASE D — LIMPEZA CONTROLADA

- Primeiro grave backup e matriz. Depois remova somente arquivos de **REMOVER SEGURO** cuja exclusão não deixe referências vivas, e atualize `project.godot`, cenas principais e referências pertinentes.
- Não exclua um sistema genérico só porque pertencia ao protótipo: avalie reaproveitamento real.
- Preserve/registre qualquer arquivo duvidoso em **REVISÃO HUMANA** e apresente ao usuário com justificativa.
- Crie `docs/migration/RELATORIO_LIMPEZA.md` contendo tabela ou listagem de cada caminho removido e justificativa, total de arquivos e espaço liberado (quando mensurável), arquivos preservados, arquivos adaptados, backup/commit de recuperação e itens não excluídos.
- Se algo precisar ser substituído para o projeto continuar abrindo, crie cena principal mínima 2D e neutra em Godot, explicitamente provisória; não invente arte final.
- Não deixe referências quebradas deliberadamente. Arquivos `.godot` de cache devem ser tratados conforme as práticas do projeto e nunca contados como arte autoral excluída.

## FASE E — VERIFICAÇÃO E ENTREGA

1. Analise as referências de recursos após as exclusões e scripts órfãos.
2. Se Godot estiver instalado, execute verificação de parsing/importação/headless compatível com a versão detectada e registre comando e resultado reais. Caso contrário, faça validação estática e assinale que teste runtime não foi executado.
3. Apresente `git status`/diff final ou outro registro verificável dos arquivos efetivamente modificados.
4. Crie um relatório da interação em `docs/reports/`.
5. Atualize `docs/STATUS.md` com próximo objetivo: importar mapa e sprites gerados no Nano Banana 2.
6. Responda em português do Brasil resumindo inventário, categorias, itens removidos, riscos, testes e sugestão do próximo passo.

### DEFINIÇÃO DE PRONTO
O projeto deve estar inventariado, documentado, com `AGENTS.md` permanente, descarte de metroidvania justificado/recuperável, sem referências deliberadamente quebradas e pronto para receber assets de tower defense. **Ainda NÃO implementar todo o tower defense nesta tarefa**: primeiro concluir a migração com segurança.
