---
paths:
  - "src/spese/adapters/orm.py"
  - "src/spese/adapters/repository.py"
  - "src/spese/service_layer/unit_of_work.py"
  - "migrations/**"
  - "alembic.ini"
---

# Persistenza: SQLAlchemy e Alembic (ADR-003)

- Mapping imperativo (`registry.map_imperatively`) come nel libro: le classi di dominio non ereditano da niente di SQLAlchemy.
- La UoW apre la sessione, fa `commit` solo se richiesto esplicitamente e fa `rollback` all'uscita.
- Alembic gestisce **solo** gli schemi `bronze`, `app`, `ml`. In `env.py` un `include_name`/`include_object` esclude `silver` e `gold`, che sono di dbt.
- Ogni migrazione autogenerata va riletta: autogenerate non vede rinomini, vincoli con nome e viste.
- Il bronze è append-only: insert con `ON CONFLICT (transaction_id) DO NOTHING`, mai update o delete.
- Le migrazioni che toccano `app.labels` o `transaction_id` richiedono il mio ok esplicito: sono l'unico dato non ricostruibile (punto critico 12).
