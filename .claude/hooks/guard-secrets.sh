#!/usr/bin/env bash
# guard-secrets.sh — PreToolUse hook sui comandi Bash.
#
# Blocca i comandi che leggerebbero segreti o dati finanziari reali.
# È il terzo livello di difesa, dopo le deny rule di settings.json e la sandbox:
# copre i casi in cui il file è nominato dentro uno script o un one-liner
# (es. python -c "open('.env')"), che le deny rule non vedono.
#
# Exit 0 = nessuna obiezione (decide il normale flusso dei permessi).
# Exit 2 = comando bloccato; lo stderr torna a Claude come motivazione.

set -uo pipefail

INPUT="$(cat)"

# Estrae tool_input.command con jq o, in mancanza, con python3.
# Se nessuno dei due è disponibile il hook blocca (fail closed).
if command -v jq >/dev/null 2>&1; then
  CMD="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')"
elif command -v python3 >/dev/null 2>&1; then
  CMD="$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))')"
else
  echo "guard-secrets: servono jq o python3 per controllare i comandi (brew install jq)." >&2
  exit 2
fi

[ -z "$CMD" ] && exit 0

block() {
  echo "Bloccato da guard-secrets: $1" >&2
  echo "Comando: $CMD" >&2
  echo "Se serve davvero, chiedi a Lorenzo di eseguirlo lui dal terminale." >&2
  exit 2
}

# Toglie le occorrenze legittime di .env.example prima dei controlli su .env
SCRUBBED="$(printf '%s' "$CMD" | sed -E 's/\.env\.example//g')"

# 1. Riferimenti a file .env (es. .env, .env.local, config/.env)
if printf '%s' "$SCRUBBED" | grep -Eq '(^|[^A-Za-z0-9_])\.env([^A-Za-z0-9_]|$)|\.env\.[A-Za-z0-9_]+'; then
  block "il comando nomina un file .env, che contiene credenziali."
fi

# 2. Cartelle con export e dump reali
if printf '%s' "$CMD" | grep -Eq '(^|[[:space:]/"'\''=])(\./)?(inbox|archive|backups)(/|[[:space:]"'\'']|$)'; then
  block "il comando tocca inbox/, archive/ o backups/, che contengono dati finanziari reali."
fi

# 3. Export Excel reali
if printf '%s' "$CMD" | grep -Eq 'movimenti-(debito|prepagata|satispay)[^/[:space:]]*\.xlsx'; then
  block "il comando nomina un export bancario reale. Usa le fixture in tests/fixtures/."
fi

# 4. Comandi che stampano variabili d'ambiente o configurazioni risolte
if printf '%s' "$CMD" | grep -Eq '(^|[;&|[:space:](])printenv([[:space:]]|$|[;&|)])|(^|[;&|[:space:](])env[[:space:]]*($|[;&|)])|docker[[:space:]]+(compose([[:space:]]+[^;&|]*)?[[:space:]]+)?config([[:space:]]|$)|docker[[:space:]]+inspect|/proc/[^[:space:]]*/environ'; then
  block "il comando stamperebbe variabili d'ambiente o la configurazione risolta di Compose, che include i segreti."
fi

# 5. Operazioni distruttive sui volumi (contengono le label manuali)
if printf '%s' "$CMD" | grep -Eq 'down[[:space:]].*(-v|--volumes)([[:space:]]|$)|volume[[:space:]]+(rm|prune)|system[[:space:]]+prune'; then
  block "il comando cancellerebbe i volumi Docker, incluse le label manuali non ricostruibili."
fi

exit 0
