# Instruções locais — Vale do Sino da Aurora

Aplicam-se integralmente as regras de ../AGENTS.md e a documentação de controle em ../docs/.
Este é o único projeto Godot ativo. Cena inicial: res://scenes/world/aurora_level.tscn.
Protótipo TD com sete bases e mapa original. Etapa 2 confirmada manualmente pelo usuário; etapa 3 integra nove PNGs transparentes, com teste visual/regressão ainda pendente. Não declarar a etapa 3 validada em runtime sem evidência.
Configuração existente declara Godot 4.7, Compatibility; preservar sem atualização desnecessária. Nesta etapa o usuário executará o Godot; não procurar/instalar o engine sem novo pedido.
GDScript com tipos úteis, snake_case, @export para balanceamento, referências cacheadas, sinais e erros explícitos de configuração.
Não reintroduzir FPS, física lateral, pulo ou câmera seguindo jogador sem pedido explícito.
Histórico anterior e instruções substituídas estão no backup externo registrado em ../docs/migration/BACKUP.json.
Relatórios, status, decisões e manifesto ficam em ../docs/, evitando duplicar fontes de verdade.
