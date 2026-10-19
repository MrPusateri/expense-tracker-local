---
name: studio
description: Modalità studio per capire una tecnologia del progetto (Docker, Postgres, SQLAlchemy, dbt, MLflow, Streamlit…) con esempi isolati, senza toccare il codice di progetto.
argument-hint: "[tecnologia o argomento]"
disable-model-invocation: true
---

# Studio: $ARGUMENTS

Siamo in modalità esplorazione, non implementazione.

1. Fammi **una sola domanda** su cosa so già di $ARGUMENTS e calibra il livello sulla risposta. Se in `docs/05-percorso-esplorazione.md` c'è un modulo dedicato, usa le sue domande come traccia.
2. Spiega **come funziona** e **perché è fatto così**, con esempi minimi e isolati: uno script, un compose giocattolo, una query.
3. Gli esempi vanno solo in `esercizi/<argomento>/`, mai in `src/`, `dbt/`, `migrations/` o nei file Docker del progetto.
4. Collega ogni concetto al progetto: dove si inserisce in `docs/02-architettura.md` e quale decisione aiuta a prendere.
5. Quando ci sono alternative, mostra i trade-off e chiudi con una raccomandazione per il mio caso: un utente, qualche migliaio di righe l'anno, tutto in locale.
6. Se l'argomento dipende dalla versione di una libreria, verifica la documentazione attuale e indica versione e fonte.
7. Chiudi con un esercizio piccolo che posso fare da solo.

Se propongo qualcosa che crea uno dei problemi di `docs/06-punti-critici.md`, segnalalo.
