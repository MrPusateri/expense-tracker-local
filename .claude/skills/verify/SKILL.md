---
name: verify
description: Controlli da eseguire prima di ogni commit del tracker spese — lint, test e verifica che in staging non ci siano dati reali, segreti o porte esposte. Usala prima di ogni commit o quando chiedo "è tutto a posto?".
allowed-tools: Bash(make lint *) Bash(make test *) Bash(git diff *) Bash(git status *)
---

# Verifica prima del commit

Esegui i passi in ordine e fermati al primo che fallisce, spiegando cosa sistemare.

1. **Cosa sta per entrare nel commit**: `git status --short` e `git diff --cached --name-only`.
   Blocca il commit se in staging c'è uno di questi:
   - `.env` o qualsiasi `.env.*` diverso da `.env.example`;
   - file sotto `inbox/`, `archive/`, `backups/`;
   - file `.xlsx` fuori da `tests/fixtures/`;
   - file `.claude/settings.local.json` o `CLAUDE.local.md`.
2. **Contenuto del diff**: con `git diff --cached` cerca
   - porte Docker non legate a `127.0.0.1`;
   - stringhe che sembrano credenziali (`password=`, `postgresql://utente:password@`, token);
   - IBAN, numeri di carta o nomi di esercenti che non sembrano inventati nelle fixture.
3. **Lint**: `make lint`. Se il Makefile non esiste ancora (prima di M0), salta e dillo.
4. **Test**: `make test`. Se fallisce, riporta il primo errore e la causa probabile, non l'intero log.
5. **Esito**: una riga tra `OK, si può committare` e `Non committare: <motivo>`.

Non correggere niente durante la verifica: riporta e aspetta.
