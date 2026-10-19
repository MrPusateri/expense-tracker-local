---
paths:
  - "docker-compose*.yml"
  - "compose*.yml"
  - "Dockerfile*"
  - "Makefile"
  - ".env.example"
---

# Docker, Compose e Makefile

- Ogni porta esposta è legata a `127.0.0.1` (es. `127.0.0.1:8501:8501`), mai solo `8501:8501`.
- Immagini compatibili con `linux/arm64`. Se un'immagine non lo è, segnalalo prima di usarla.
- I segreti stanno in `.env`, che non si legge e non si committa. `.env.example` elenca le variabili con valori finti.
- Volumi con nome per `pg_data` e `mlflow_artifacts`. Nessun target del Makefile usa `down -v`, `volume rm` o `prune`.
- `app`, `jobs` e `tests` usano la stessa immagine con comandi diversi. I job sono one-shot (`docker compose run --rm`).
- Postgres ha un healthcheck e gli altri servizi lo aspettano con `depends_on: condition: service_healthy`.
- Ogni nuovo target del Makefile va aggiunto alla tabella comandi in `CLAUDE.md`.
- Le modifiche a questi file richiedono la mia approvazione: girano fuori dalla sandbox.
