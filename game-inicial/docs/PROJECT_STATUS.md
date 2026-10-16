# Estado atual — etapa 3, 2026-10-15

Base da etapa 2 validada pelo usuário. Nove artes transparentes integradas, sprites estáticos procedurais e camadas por pés; gameplay preservado por comparação estática. Teste visual/regressão no Godot pendente. Fontes atuais: [arquitetura TD](TD_ARCHITECTURE.md), [status](../../docs/STATUS.md) e [teste manual](../../docs/TESTE_MANUAL.md).

---

## Registros anteriores (estado histórico)

# Estado atual — etapa 2, 2026-10-15

Protótipo TD preparado em scenes/world/aurora_level.tscn; execução manual pendente. Documentação atual: [arquitetura TD](TD_ARCHITECTURE.md), [status](../../docs/STATUS.md) e [roteiro manual](../../docs/TESTE_MANUAL.md). Próxima tarefa: executar no editor e corrigir erros observados; depois revisar arte e balanceamento.

---

# Aviso de migração — 2026-10-15

Registro histórico do protótipo substituído. Instruções e referências abaixo não descrevem o projeto atual. Consulte ../../docs/STATUS.md e ../../docs/DECISOES.md.

---

# Estado do projeto

Atualizado em 2026-10-10.

- **Projeto ativo:** `game-inicial/project.godot` (esta pasta, não a pasta pai).
- **Main Scene:** `res://scenes/world/prototype_2d.tscn`.
- **Estado:** fundação 2D implementada; validação manual de sensação pendente.
- **Última funcionalidade:** controlador lateral com pulo e sala de teste 2D.
- **Funcionando em testes:** aceleração, desaceleração, esquerda/direita, orientação
  do sprite, pulo no chão, gravidade, colisões de piso/parede/teto, degrau,
  plataformas alcançáveis, desnível e acompanhamento da câmera.
- **Evidência:** 29 verificações aprovadas no Godot 4.4.1 headless; nenhuma falha.
- **Inicialização:** Main Scene executada por 120 frames headless sem erros.
- **Renderização:** duas capturas reais conferidas (spawn e plataforma elevada)
  com Compatibility/OpenGL no Godot 4.4.1; log gráfico sem erros.
- **Sistemas quebrados conhecidos no novo gameplay:** nenhum encontrado nos testes.
- **Limites da validação:** não houve teste interativo humano de controles; Godot
  4.7 mostrado pelo usuário não está disponível para execução local nesta sessão.
- **Tarefa atual:** usuário executar a sala e avaliar velocidades e altura de pulo.
- **Próximo objetivo recomendado:** após aprovação, coyote time/jump buffer/pulo
  variável; não implementados nem iniciados nesta tarefa.

## Legado

A direção 3D está cancelada. Os arquivos FPS permanecem intactos, sem ligação
com a nova Main Scene. A pasta pai também contém um projeto 3D antigo. As ações
exclusivas dele foram preservadas, mas não são utilizadas no controlador 2D.
O legado não foi revalidado nesta migração; seus testes não validam o jogo atual.

## Como repetir a validação

Na pasta deste projeto, usando um executável Godot 4.4+ disponível:

```text
godot --headless --path . --editor --import --quit
godot --headless --path . --script res://tests/platformer_player_test.gd
godot --headless --path . --quit-after 120
```

Importar primeiro registra a classe PlatformerPlayer e importa o SVG.
O script de teste retorna código 1 se alguma verificação falhar.
Para testar manualmente, abra o projeto no editor e use F5. Roteiro no README.
