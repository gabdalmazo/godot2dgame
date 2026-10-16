# Status — Vale do Sino da Aurora

Atualizado em 2026-10-15. **Etapa 2 validada manualmente pelo usuário; etapa 3 integrada em arquivos e conferida estaticamente, aguardando teste visual no Godot.**

## Etapa atual

Três torres, dois monstros, três projéteis e um impacto usam nove PNGs derivados das artes fornecidas, com alfa real. Nenhum original foi alterado. Movimento procedural anima o sprite estático dos monstros; folhas inconsistentes permanecem fora do runtime.

| Sistema | Estado verificável |
|---|---|
| Projeto | game-inicial/project.godot; cena aurora_level.tscn; configuração existente 4.7/Compatibility preservada byte a byte |
| Base jogável | Mapa, HUD, construção, movimento, combate, economia, pausa, vitória/derrota e reinício confirmados pelo usuário antes desta etapa |
| Mapa/rota | Mapa original; 27 pontos no ramo superior; sete bases 1, 2, 4, 5, 6, 7, 8 preservados |
| Torres | Sentinela, Lança-Geada e Farol com PNGs transparentes; seleção/alcance e valores originais preservados |
| Monstros | Gremlin ~42 px, golem ~56 px; pivô nos pés, bob, squash e flip; barras reposicionadas |
| Caminhadas | SpriteFrames opcional; nenhuma das sete folhas aprovada; fallback procedural disponível |
| Projéteis | Flecha, gelo e orbe com arte; impacto arcano derivado; impactos de flecha/gelo permanecem nativos |
| Camadas | Atores ordenados por Y dos pés; projéteis/impactos acima, HUD independente |
| Ondas/economia | Cinco ondas 6/10/13/17/21; 170 moedas, 15 vidas; preços, dano, velocidades e recompensas sem alteração |
| Resiliência | Texturas opcionais por caminho, cache compartilhado; desenho anterior quando ausentes |
| Verificação | 359 verificações gerais, 58 referências; auditoria visual/preservação em docs/validation/etapa3_visual_static.json |

## Limites e pendências

- Godot não foi procurado, instalado ou executado nesta etapa, conforme pedido. Importação, parser e regressão de runtime dependem do teste manual.
- Edição de imagens por image_gen pode alterar detalhes de traço/brilho; não é segmentação pixel a pixel. Alfa e escala conferidos em composição técnica, sem equivaler a screenshot do jogo.
- Caminhadas continuam sem quatro direções reais; fontes opacas e direções/personagens incorretos documentados na inspeção.
- Nove PNGs 1254×1254 somam ~53,99 MiB RGBA antes da compressão; cache evita duplicação por instância. Desempenho ainda não medido.
- HUD usa Controls nativos; decoração extra, áudio, save, upgrades/venda e build não fazem parte desta etapa.
- Trabalho anterior, staging e configuração do usuário preservados. Nenhuma exclusão, movimentação, commit ou stage nesta etapa.

## Próximos Passos

- **P0:** abrir no Godot utilizado pelo usuário, aguardar importação e executar o [roteiro manual](TESTE_MANUAL.md), verificando arte e regressão do loop.
- **P1:** corrigir achados visuais de escala, recorte, sobreposição e origem dos disparos; preparar folhas com alfa, direções e pivôs consistentes.
- **P2:** otimizar dimensões/importação após medir, integrar ícones e efeitos adicionais sem cobrir a rota.

Detalhes: [arquitetura](../game-inicial/docs/TD_ARCHITECTURE.md), [inspeção etapa 3](assets/INSPECAO_ETAPA3.md), [relatórios](reports/INDEX.md).
