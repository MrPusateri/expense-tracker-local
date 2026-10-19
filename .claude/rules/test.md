---
paths:
  - "tests/**"
  - "conftest.py"
---

# Test a tre livelli (Appendice B del libro)

- `tests/unit/`: dominio e handler con `FakeUnitOfWork` e fake degli adapter. Nessun I/O, devono girare in meno di un secondo.
- `tests/integration/`: repository, UoW, importer e migrazioni contro un Postgres vero in Docker (`make test`).
- `tests/e2e/`: dal file importato fino alla vista gold, con dbt eseguito sul db di test.
- Solo dati sintetici, costruiti da fixture o factory. Mai export reali.
- Un test per comportamento, con nome che lo descrive in italiano: `test_import_dello_stesso_file_non_crea_duplicati`.
- Un bug corretto porta sempre con sé il test che lo riproduceva.
