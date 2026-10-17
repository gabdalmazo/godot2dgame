# Instruções locais — Vale do Sino da Aurora

Aplicam-se integralmente as regras de ../AGENTS.md e a documentação de controle em ../docs/.
Este é o único projeto Godot ativo. Cena inicial após a Etapa 6: res://scenes/world/aurora_level_extended.tscn; a cena original aurora_level.tscn permanece como fallback.
Protótipo TD expandido: cena original com sete bases/cinco ondas e cena estendida com oito bases/sete ondas/boss/upgrades/música/base final. O usuário confirmou que a Etapa 3 roda com os personagens corretos. A Etapa 4 integra caminhada suavizada, áudio local e Sino da Aurora; a Etapa 5 substitui a aparência da HUD com base em `img/hud_nova.jpg`. Execução/regressão das Etapas 4–6 ainda pendem de teste manual. Não declarar essas etapas validadas em runtime sem evidência.
Configuração existente declara Godot 4.7, Compatibility; preservar sem atualização desnecessária. Nesta etapa o usuário executará o Godot; não procurar/instalar o engine sem novo pedido.
GDScript com tipos úteis, snake_case, @export para balanceamento, referências cacheadas, sinais e erros explícitos de configuração.
Não reintroduzir FPS, física lateral, pulo ou câmera seguindo jogador sem pedido explícito.
Histórico anterior e instruções substituídas estão no backup externo registrado em ../docs/migration/BACKUP.json.
Relatórios, status, decisões e manifesto ficam em ../docs/, evitando duplicar fontes de verdade.
