---
name: issue
description: Lavora una issue GitHub del tracker spese dall'analisi al commit, una alla volta.
argument-hint: "[numero-issue]"
disable-model-invocation: true
allowed-tools: Bash(gh issue view *) Bash(git status *) Bash(git switch *) Bash(git diff *)
---

# Lavora la issue #$ARGUMENTS

1. **Leggi la issue**: `gh issue view $ARGUMENTS --comments`. Riassumi in 3 righe obiettivo, milestone e definition of done. Se la definition of done manca o è ambigua, fermati e chiedimela.
2. **Contesto**: leggi solo le sezioni di `docs/` che la issue tocca. Controlla in `docs/07-registro-decisioni.md` se ci sono ADR pertinenti e in `docs/06-punti-critici.md` se la issue tocca un punto critico. Se sì, citali.
3. **Branch**: `git switch -c <tipo>/$ARGUMENTS-<slug-breve>` (tipo: `feat`, `fix`, `chore`, `docs`, `test`).
4. **Piano**: proponi i passi (file da creare o modificare, test da scrivere, comandi da eseguire). Se la issue tocca più di un layer, uno schema DB o il `transaction_id`, **aspetta il mio ok** prima di procedere.
5. **Test prima**: scrivi i test che descrivono il comportamento atteso e verifica che falliscano.
6. **Implementa** il minimo per farli passare, rispettando `.claude/rules/`.
7. **Verifica**: esegui `/verify`.
8. **Commit**: un commit (o pochi) in stile `feat(area): descrizione (#$ARGUMENTS)`. Non fare push e non chiudere la issue.
9. **Chiusura**: in massimo 5 righe dimmi cosa è cambiato, cosa resta fuori e, se hai introdotto un pattern o una tecnologia nuova, perché è fatta così. Se è emersa una decisione architetturale, suggerisci di lanciare `/chiudiamo`.
