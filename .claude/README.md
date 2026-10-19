# Configurazione di Claude Code

| Percorso | Cosa contiene | Quando si carica |
|---|---|---|
| `../CLAUDE.md` | contesto del progetto, regole non negoziabili, comandi | a ogni sessione |
| `../CLAUDE.local.md` | note personali (non versionato) | a ogni sessione |
| `settings.json` | permessi, sandbox, hook | a ogni sessione |
| `rules/*.md` | regole per area (dominio, importer, dbt, ML, test, Docker) | quando Claude tocca file che corrispondono ai `paths` |
| `skills/` | `/issue`, `/verify`, `/chiudiamo`, `/studio` | su richiesta (`/verify` anche prima di ogni commit) |
| `agents/` | `revisore-architettura`, `guardiano-privacy` (sola lettura) | quando li chiedo per nome |
| `hooks/` | `guard-secrets.sh` (blocca comandi su segreti e dati reali), `format-python.sh` (ruff dopo ogni modifica) | prima/dopo ogni tool call |

## Protezione di segreti e dati reali

Tre livelli indipendenti, perché nessuno da solo copre tutto:

1. **Permessi** (`permissions.deny`): bloccano Read, Grep, Glob ed Edit su `.env`, `inbox/`, `archive/`, `backups/` ed export reali, più `cat`/`head`/`tail` su quei percorsi. `blockReadsOutsideWorkingDirectories` impedisce di leggere fuori dalla cartella del progetto.
2. **Hook** `guard-secrets.sh`: blocca i comandi Bash che nominano quei percorsi anche dentro script o one-liner, e quelli che stampano l'ambiente (`printenv`, `docker compose config`, `docker inspect`).
3. **Sandbox** del sistema operativo: i comandi Bash sandboxati non possono leggere quei percorsi né la home, qualunque processo li apra. `make`, `docker compose` e `gh` girano fuori dalla sandbox perché Docker non è compatibile: per questo le modifiche a `Makefile`, Compose e `Dockerfile` chiedono sempre conferma.

Limite noto: i container avviati con `make` leggono `.env` per costruzione (è così che ricevono le credenziali). Il controllo vale su ciò che legge Claude, non su ciò che fanno i container.

Documentazione di riferimento: https://code.claude.com/docs/en/permissions · https://code.claude.com/docs/en/sandboxing · https://code.claude.com/docs/en/memory
