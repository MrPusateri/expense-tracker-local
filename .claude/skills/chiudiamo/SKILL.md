---
name: chiudiamo
description: Chiude una sessione di lavoro o di studio registrando le decisioni prese come ADR, l'elenco di cosa resta aperto e le modifiche ai documenti di progetto.
disable-model-invocation: true
---

# Chiusura della sessione

Rileggi la conversazione e produci tre blocchi.

## 1. Nuove ADR

- Leggi `docs/07-registro-decisioni.md` e trova il numero dell'ultima ADR.
- Scrivi una ADR per ogni decisione presa in questa sessione, numerata di seguito, nel formato del file:

```
## ADR-NNN · Titolo breve
- Data: aaaa-mm-gg (oggi)
- Stato: proposta | accettata
- Contesto: il problema e i vincoli
- Decisione: cosa si fa
- Alternative scartate: cosa e perché
- Conseguenze: cosa diventa più facile e cosa più difficile
```

- Se una decisione modifica un'ADR esistente, non riscriverla: crea la nuova e indica che la vecchia diventa `sostituita da ADR-NNN`.
- Se una decisione va contro un'ADR esistente senza sostituirla esplicitamente, segnalalo.

## 2. Cosa resta aperto

Elenco puntato breve: domande non risolte, issue da aprire, verifiche da fare. Se qualcosa risponde a una domanda di `docs/06` (D1–D9), indicalo.

## 3. Modifiche ai documenti

Per `docs/02`, `docs/04` o `docs/06`, scrivi solo le sezioni da cambiare come blocchi sostitutivi completi, indicando quale sezione sostituiscono.

## Applicazione

Mostrami i tre blocchi e chiedi conferma. Solo dopo il mio ok aggiungi le ADR in fondo a `docs/07-registro-decisioni.md` (le vecchie non si cancellano mai) e applica i blocchi agli altri documenti.
