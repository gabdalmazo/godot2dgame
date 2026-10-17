# Status — Vale do Sino da Aurora

Atualizado em 2026-10-17. **Etapa 6 implementada em arquivos e verificada estaticamente; teste manual no Godot pendente.** O usuário confirmou que a Etapa 3 funciona no editor; as Etapas 4, 5 e 6 ainda não têm confirmação de runtime.

## Sistemas

| Sistema | Estado verificável |
|---|---|
| Projeto | `game-inicial/project.godot`, Godot 4.7/Compatibility; F5 abre `aurora_level_extended.tscn`; `aurora_level.tscn` original preservada como fallback |
| Loop TD | Cena estendida no ramo inferior: rota 1.193,76 px (+5,4%), oito bases, sete ondas; cena original de sete bases/cinco ondas intacta |
| Progressão | Gremlins/golens ganham vida ×1,00→1,62 e velocidade ×1,00→1,10 por onda na fase estendida; boss Regente da Geada entra por último na onda 7 |
| Torres | Três tipos com cadeia de Resources níveis 1→2→3, custos reais, upgrade contextual e troca de textura preparada; níveis 2/3 reutilizam PNG atual com escala/cor/anéis provisórios |
| Arte | Nove PNGs tratados da Etapa 3 continuam atribuídos; originais em `img/` intactos |
| Caminhada | Sprite estático com bob ≤0,35 px, balanço lateral, deformação ≤0,4% e inclinação leve; gremlin 9 rad/s, golem 6 rad/s |
| HUD | Placas de madeira/bronze com borda nevada, recursos e onda dinâmicos, pausa ornamentada, três cartões com arte real das torres, controle de onda verde, Sino com barra de recarga, toast e resultados temáticos; referência `img/hud_nova.jpg` não é usada como camada |
| Áudio | 13 SFX anteriores e loop musical local PCM mono 22.050 Hz/16 s na cena estendida; ganho de música e SFX separados; música pausa com a partida |
| Sino da Aurora | Ativa durante onda com inimigos: aplica lentidão ×0,55 por 3 s aos inimigos presentes; recarga 24 s, pausa congela a contagem; pulso visual |
| Base final | `FinalBase` sobre a construção do mapa; cinco graus de brilho/rachaduras conforme vidas restantes, com estado no tooltip da HUD |
| Verificações | 679 checagens gerais + 190/61/76 das Etapas 4/5/6, sem erros; sem parser/runtime Godot |

## Limites e riscos

- Godot não foi executado pelo Codex, conforme pedido. Parsing GDScript, importação de SVG/WAV, layout, cliques, música audível, equilíbrio do boss/upgrades e regressão em runtime exigem teste manual.
- A rota nova usa o ramo inferior da mesma imagem, por isso sua extensão geométrica é moderada (+5,4%); a fase fica mais longa principalmente pelas duas ondas adicionais. Uma fase substancialmente maior precisará de mapa autoral maior.
- Boss e base danificada usam desenho procedural temporário; as artes definitivas transparentes não foram entregues. Os seis níveis evoluídos reutilizam os PNGs atuais.
- `img/hud_nova.jpg` é JPEG opaco com mapa e textos incorporados: nenhum recorte foi importado. A composição foi refeita com controles e SVGs autorais simples; ornamentos ilustrados e neve irregular dependem de assets transparentes específicos para fidelidade maior.
- As folhas de caminhada antigas seguem inválidas. O visual estático permanece com fallback geométrico quando uma textura não carregar.
- A nova habilidade altera apenas a velocidade de inimigos presentes, sem dano, moedas ou mudança de atributos das torres. Ajustes de equilíbrio dependem da experiência do usuário.
- Efeitos e BGM são provisórios; a separação de volume existe nos exports, mas controles de volume/mute na HUD ficam para outra etapa. Sons simultâneos têm limitação de taxa para evitar excesso.
- Trabalho anterior e arquivos originais preservados. Nenhuma exclusão nem atualização de dependência.

## Próximos Passos

- **P0:** abrir o projeto e executar [o roteiro manual da Etapa 6](TESTE_MANUAL.md): F5 na cena estendida, upgrade, boss, base, música, pausa e regressão; informar a primeira mensagem de Output/Debugger se houver erro.
- **P1:** calibrar saúde/custos/volume/layout após jogo real; conferir a curva inferior e a nova base 9 contra o mapa no editor.
- **P2:** produzir mapa maior, boss RGBA, seis visuais evoluídos, cinco estados da base final, BGM final e spritesheets válidas.

Documentação: [decisões](DECISOES.md), [manifesto](ASSET_MANIFEST.md), [arquitetura](../game-inicial/docs/TD_ARCHITECTURE.md), [relatórios](reports/INDEX.md).
