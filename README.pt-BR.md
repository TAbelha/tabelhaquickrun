<div align="center">

# Tabela Quick Run

[English](README.md) · **Português**

[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue?style=flat-square)](LICENSE)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/ianptkcs)

</div>

---

Um plugin de launcher do [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
que roda um comando de shell a partir do launcher/spotlight — mas, diferente
de uma caixa genérica de "rodar comando", ele casa com **suas funções e
abreviações do fish de verdade** enquanto você digita, e sempre executa
através de um shell fish de login (`fish -lc`), então suas funções,
abreviações e configuração de `PATH` funcionam exatamente como num terminal
de verdade.

## Por que não usar um command runner genérico?

Plugins como o [Command Runner](https://github.com/devnullvoid/dms-command-runner)
sugerem comandos via `compgen -c` do bash, que só enxerga executáveis no
`$PATH` — ele não tem como saber que suas funções do fish (`hrwiv`, `gacp`,
qualquer coisa definida em `~/.config/fish/functions/`) existem, e roda o
comando final com `sh -c`, que não consegue chamar funções/abreviações do
fish de jeito nenhum. O Quick Run foi construído ao contrário: ele pergunta
pro próprio fish (`functions -n`, `abbr --show`) o que existe, e sempre
entrega o comando final pro `fish -lc`.

## Funcionalidades

- Digite uma palavra e receba sugestões combinadas em tempo real com suas
  funções e abreviações do fish (match exato → prefixo → substring), cada
  uma mostrando onde a função está definida ou pra que a abreviação expande.
- O comando literal que você digitou é sempre a primeira sugestão, então
  comandos avulsos de shell (`htop`, `git status`, …) funcionam sem
  configuração nenhuma.
- Assim que você digita um espaço (já entrou nos argumentos), as sugestões
  saem do caminho e só o comando literal permanece — então
  `hrwiv --ai opencode` roda exatamente como digitado.
- Os dados de matching são buscados uma única vez em background quando o
  plugin carrega, não a cada tecla digitada.
- Caractere de trigger e quantidade de sugestões configuráveis.

## Requisitos

- DankMaterialShell `>=1.4.0`
- [fish shell](https://fishshell.com/) instalado e no `PATH`

## Instalação

```bash
git clone https://github.com/TabelaDev/tabelaquickrun.git \
    ~/.config/DankMaterialShell/plugins/quickRun
dms ipc call plugin-scan scan
dms ipc call plugins enable quickRun
```

Depois, associe uma tecla pra abrir o launcher já preenchido com o trigger,
por exemplo no niri:

```kdl
Mod+Semicolon { spawn "dms" "ipc" "call" "spotlight" "openQuery" ";"; }
```

## Configuração

Abra **Settings → Plugins → Quick Run** no DankMaterialShell:

- **Trigger** — o prefixo que ativa o Quick Run no launcher (padrão `;`).
- **Max suggestions** — quantas funções/abreviações combinadas mostrar
  abaixo do comando literal (padrão `8`).

## Como funciona

Ao carregar, o plugin roda dois comandos únicos via um shell fish de login e
guarda o resultado em cache:

- `functions -n` (mais `functions -D <nome>` por função) — toda função do
  fish carregada e onde ela está definida.
- `abbr --show` — toda abreviação e sua expansão.

Digitar uma palavra filtra esse cache; selecionar uma sugestão ou apertar
enter no comando literal roda `fish -lc "<comando>"` via
`Quickshell.execDetached`.

## Roadmap

Veja [ROADMAP.md](ROADMAP.md) pros itens em aberto (submissão pro registry, screenshot, etc.).

## Licença

[AGPL-3.0](LICENSE)
