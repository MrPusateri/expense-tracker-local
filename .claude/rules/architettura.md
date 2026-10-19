---
paths:
  - "src/spese/**/*.py"
---

# Architettura del codice (ADR-005)

- Le dipendenze vanno sempre verso l'interno: `entrypoints` → `service_layer` (message bus, handler, UoW) → `domain` e porte astratte. Mai il contrario.
- `domain/` non importa niente fuori dalla standard library: niente SQLAlchemy, pandas, MLflow, Streamlit.
- `ml/` non importa né Streamlit né `service_layer`.
- Le scritture passano sempre da un command sul message bus (`commands.py` → `handlers.py`). Le letture per la UI passano da `views.py` con SQL diretto sul gold (CQRS minimale, cap. 12).
- Le dipendenze concrete (UoW, classifier, importer) si iniettano in `bootstrap.py` (cap. 13). Negli handler si ricevono come parametri, mai importate direttamente.
- Le porte astratte (`AbstractRepository`, `AbstractUnitOfWork`, `AbstractClassifier`, `AbstractImporter`) vivono accanto alle loro implementazioni in `adapters/` o in `service_layer/unit_of_work.py`, come nel libro.
- Configurazione solo da variabili d'ambiente tramite `config.py`. Nessun valore di connessione scritto nel codice.
- Prima di aggiungere un pattern del libro chiediti se serve davvero a un'app con un utente e qualche migliaio di righe l'anno. Se il dubbio resta, chiedimelo.
