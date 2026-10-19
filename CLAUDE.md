# Tracker spese in locale

App personale per tracciare spese ed entrate. Importa gli export Excel di conto corrente, carta prepagata e Satispay, li unifica in Postgres a livelli (bronze → silver → gold) e li categorizza con un modello di ML gestito con MLflow, che migliora man mano che correggo le categorie a mano. Il codice segue *Architecture Patterns with Python* (Percival & Gregory, "Cosmic Python").

## Fonti di verità

I documenti di progetto sono in `docs/`. Leggi quello pertinente prima di toccare l'area che descrive:

- `docs/01-contesto-e-requisiti.md`: obiettivi, vincoli, perimetro
- `docs/02-architettura.md`: container, schema DB, moduli, flussi
- `docs/03-fonti-dati.md`: formato degli export, trappole, regola del `transaction_id`
- `docs/04-tassonomia.md`: categorie, macro, tag
- `docs/06-punti-critici.md`: dove l'architettura rischia di rompersi
- `docs/07-registro-decisioni.md`: decisioni prese (ADR)

Se una modifica va contro un'ADR di `docs/07`, fermati e dimmelo esplicitamente, spiegando perché varrebbe la pena rivederla. Non cambiarla in silenzio. Le nuove decisioni si registrano con `/chiudiamo`.

## Come lavoriamo

- Il lavoro è organizzato in issue GitHub raggruppate in milestone (M0 scheletro → M9 operatività). Si lavora **una issue alla volta**, partendo con `/issue <numero>`.
- Prima di scrivere codice proponi un piano breve e aspetta il mio ok se la issue tocca più di un layer o una chiave (ID, schema, label).
- Test prima del codice per dominio e handler (unit con fake), poi integration con Postgres vero. Vedi `.claude/rules/test.md`.
- Il progetto è anche didattico: quando introduci un pattern o una tecnologia nuova, aggiungi 2–3 righe sul **perché** nel messaggio finale, non nel codice.
- Per lo studio di una tecnologia senza toccare il codice di progetto c'è `/studio <argomento>`.
- Quando una risposta dipende dalla versione di una libreria (MLflow, dbt, SQLAlchemy, Streamlit, Docker Compose), verifica la documentazione attuale e indica la versione.

## Comandi

Tutto gira in Docker tramite `make` (definito in `Makefile`):

| Comando | Cosa fa |
|---|---|
| `make up` / `make down` | avvia / ferma i servizi (`down` senza `-v`: i volumi restano) |
| `make test` | pytest in container contro un Postgres di test |
| `make lint` | ruff check + ruff format --check + mypy |
| `make migrate` | migrazioni Alembic (schemi `bronze`, `app`, `ml`) |
| `make transform` | `dbt build` (viste `silver` e `gold`) |
| `make ingest` / `make train` | job one-shot |
| `make backup` / `make restore` | `pg_dump` + artefatti MLflow |

Prima di ogni commit gira `/verify` (lint + test + controllo che non ci siano dati o segreti in staging). Il `git push` lo faccio io.

## Regole che non si negoziano

- **I dati reali non entrano mai nel contesto.** Non leggere `.env`, `inbox/`, `archive/`, `backups/` né file Excel reali. Per i test usa solo fixture sintetiche in `tests/fixtures/`, costruite dalla struttura descritta in `docs/03`. Quello che leggi viene inviato all'API: leggere un export vero violerebbe ADR-001.
- **Niente servizi terzi a runtime**: nessuna chiamata di rete dall'app, nessuna telemetria, modelli di embedding scaricati in build e mai a runtime.
- Porte esposte solo su `127.0.0.1`.
- Mai `docker compose down -v`, `docker volume rm` o `prune`: cancellano `pg_data`, che contiene le label manuali (l'unico dato non ricostruibile).
- Un solo scrittore per schema: Alembic gestisce `bronze`, `app`, `ml`; dbt gestisce `silver` e `gold`.
- La regola del `transaction_id` (`docs/03`) non si cambia senza nuovo prefisso (`v2:`) e migrazione delle label.

## Convenzioni

- Python 3.12, layout `src/spese/`, dipendenze con `uv`, formattazione `ruff`.
- Identificatori, classi, command ed eventi in inglese (come in `docs/02`); docstring, commenti, messaggi di commit e documentazione in italiano.
- Commit piccoli in stile Conventional Commits, con riferimento alla issue: `feat(ingestion): importer Satispay (#12)`.
- Le regole di dettaglio per area sono in `.claude/rules/` e si caricano da sole quando tocchi i file corrispondenti.
